#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "src/core/MediaEngine.h"
#include "src/controllers/PlaybackController.h"
#include "src/controllers/SettingsController.h"

using namespace Qt::StringLiterals;
int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    // 1. Khởi tạo mớ Backend
    MediaEngine engine;
    engine.startScan("/home/nariewynn/Music/mp3");
    engine.startScan("/home/nariewynn/Music/mp4");
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