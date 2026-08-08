#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "src/core/MediaEngine.h"
#include "src/controllers/PlaybackController.h"
#include "src/controllers/SettingsController.h"
#include <QDir>
using namespace Qt::StringLiterals;
int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    // 1. Khởi tạo mớ Backend
    MediaEngine engine;
    QString username = qgetenv("USER");
    if (username.isEmpty()) username = qgetenv("LOGNAME");

    QString mediaBasePath = "/run/media/" + username;
    QDir mediaBaseDir(mediaBasePath);

    if (mediaBaseDir.exists()) {
        // Lấy danh sách toàn bộ USB đang cắm
        QStringList usbFolders = mediaBaseDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot);

        for (const QString &usbName : usbFolders) {
            QString fullUsbPath = mediaBaseDir.absoluteFilePath(usbName);
            qDebug() << "🔌 Phát hiện USB:" << fullUsbPath;

            // Quét tự động không quan tâm tên USB là MUSIC hay MP3 hay gì cả
            engine.startScan(fullUsbPath);
        }
    } else {
        qWarning() << "⚠️ Không tìm thấy thư mục mount USB:" << mediaBasePath;
    }

    PlaybackController playbackController(&engine);
    SettingsController settingsController;

    QQmlApplicationEngine qmlEngine;

    // 2. Đăng ký C++ Objects thành các biến Global cho QML xài trực tiếp
    QQmlContext *context = qmlEngine.rootContext();
    context->setContextProperty("mediaEngine", &engine);
    context->setContextProperty("mediaModel", engine.model());
    context->setContextProperty("playbackController", &playbackController);
    context->setContextProperty("settingsController", &settingsController);

    // 3. Load file giao diện chính
    const QUrl url(u"qrc:/qt/qml/app_id/ui/main.qml"_s);
    QObject::connect(&qmlEngine, &QQmlApplicationEngine::objectCreated,
            &app, [url](const QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);
    qmlEngine.load(url);

    return QGuiApplication::exec();
}