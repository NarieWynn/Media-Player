#include <QtQml/qqmlprivate.h>
#include <QtCore/qdir.h>
#include <QtCore/qurl.h>
#include <QtCore/qhash.h>
#include <QtCore/qstring.h>

namespace QmlCacheGeneratedCode {
namespace _qt_qml_app_id_ui_main_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_app_id_ui_components_SideBar_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_app_id_ui_components_CustomSlider_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_app_id_ui_components_PlaybackControls_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_app_id_ui_components_TrackDelegate_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_app_id_ui_views_PlayerView_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_app_id_ui_views_MediaLibraryView_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_app_id_ui_views_SettingsView_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_app_id_ui_views_VideoPlayerView_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}

}
namespace {
struct Registry {
    Registry();
    ~Registry();
    QHash<QString, const QQmlPrivate::CachedQmlUnit*> resourcePathToCachedUnit;
    static const QQmlPrivate::CachedQmlUnit *lookupCachedUnit(const QUrl &url);
};

Q_GLOBAL_STATIC(Registry, unitRegistry)


Registry::Registry() {
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/app_id/ui/main.qml"), &QmlCacheGeneratedCode::_qt_qml_app_id_ui_main_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/app_id/ui/components/SideBar.qml"), &QmlCacheGeneratedCode::_qt_qml_app_id_ui_components_SideBar_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/app_id/ui/components/CustomSlider.qml"), &QmlCacheGeneratedCode::_qt_qml_app_id_ui_components_CustomSlider_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/app_id/ui/components/PlaybackControls.qml"), &QmlCacheGeneratedCode::_qt_qml_app_id_ui_components_PlaybackControls_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/app_id/ui/components/TrackDelegate.qml"), &QmlCacheGeneratedCode::_qt_qml_app_id_ui_components_TrackDelegate_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/app_id/ui/views/PlayerView.qml"), &QmlCacheGeneratedCode::_qt_qml_app_id_ui_views_PlayerView_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/app_id/ui/views/MediaLibraryView.qml"), &QmlCacheGeneratedCode::_qt_qml_app_id_ui_views_MediaLibraryView_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/app_id/ui/views/SettingsView.qml"), &QmlCacheGeneratedCode::_qt_qml_app_id_ui_views_SettingsView_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/app_id/ui/views/VideoPlayerView.qml"), &QmlCacheGeneratedCode::_qt_qml_app_id_ui_views_VideoPlayerView_qml::unit);
    QQmlPrivate::RegisterQmlUnitCacheHook registration;
    registration.structVersion = 0;
    registration.lookupCachedQmlUnit = &lookupCachedUnit;
    QQmlPrivate::qmlregister(QQmlPrivate::QmlUnitCacheHookRegistration, &registration);
}

Registry::~Registry() {
    QQmlPrivate::qmlunregister(QQmlPrivate::QmlUnitCacheHookRegistration, quintptr(&lookupCachedUnit));
}

const QQmlPrivate::CachedQmlUnit *Registry::lookupCachedUnit(const QUrl &url) {
    if (url.scheme() != QLatin1String("qrc"))
        return nullptr;
    QString resourcePath = QDir::cleanPath(url.path());
    if (resourcePath.isEmpty())
        return nullptr;
    if (!resourcePath.startsWith(QLatin1Char('/')))
        resourcePath.prepend(QLatin1Char('/'));
    return unitRegistry()->resourcePathToCachedUnit.value(resourcePath, nullptr);
}
}
int QT_MANGLE_NAMESPACE(qInitResources_qmlcache_appAutoPlayer)() {
    ::unitRegistry();
    return 1;
}
Q_CONSTRUCTOR_FUNCTION(QT_MANGLE_NAMESPACE(qInitResources_qmlcache_appAutoPlayer))
int QT_MANGLE_NAMESPACE(qCleanupResources_qmlcache_appAutoPlayer)() {
    return 1;
}
