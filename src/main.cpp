#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QStorageInfo>
#include <QDir>
#include <QDebug>
#include <QTimer>
#include "src/core/MediaEngine.h"
#include "src/controllers/PlaybackController.h"
#include "src/controllers/SettingsController.h"

using namespace Qt::StringLiterals;

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    MediaEngine engine;
    PlaybackController playbackController(&engine);
    SettingsController settingsController;

    QQmlApplicationEngine qmlEngine;

    // 1. Đăng ký C++ Objects cho QML trước
    QQmlContext *context = qmlEngine.rootContext();
    context->setContextProperty("mediaEngine", &engine);
    context->setContextProperty("mediaModel", engine.model());
    context->setContextProperty("playbackController", &playbackController);
    context->setContextProperty("settingsController", &settingsController);

    // 2. Load UI main.qml
    const QUrl url(u"qrc:/qt/qml/app_id/ui/main.qml"_s);
    QObject::connect(&qmlEngine, &QQmlApplicationEngine::objectCreated,
            &app, [url](const QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);
    qmlEngine.load(url);

    // 3. ĐỢI UI LOAD XONG MỚI BẮT ĐẦU QUÉT USB (Delay 500ms)
    QTimer::singleShot(500, [&engine]() {
        bool found = false;
        for (const QStorageInfo &storage : QStorageInfo::mountedVolumes()) {
            if (!storage.isValid() || !storage.isReady() || storage.isRoot()) continue;

            QString path = storage.rootPath();
#ifdef Q_OS_ANDROID
            if ((path.startsWith("/storage") || path.startsWith("/mnt")) && !path.contains("/emulated")) {
                qDebug() << "🔌 Android USB scan:" << path;
                engine.startScan(path);
                found = true;
            }
#else
            QString username = qgetenv("USER");
            if (username.isEmpty()) username = qgetenv("LOGNAME");
            if (path.startsWith("/run/media/" + username) || path.startsWith("/media")) {
                qDebug() << "🔌 Desktop USB scan:" << path;
                engine.startScan(path);
                found = true;
            }
#endif
        }
        if (!found) {
            qWarning() << "⚠️ Không tìm thấy USB nào!";
        }
    });

    return QGuiApplication::exec();
}