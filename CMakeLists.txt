cmake_minimum_required(VERSION 3.16)
project(AutoPlayer VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick Multimedia)

qt_standard_project_setup()
qt_policy(SET QTP0001 NEW)

qt_add_executable(appAutoPlayer
        src/main.cpp
        src/core/MediaPlayer.h
        src/core/MediaPlayer.cpp
        src/core/MediaEngine.cpp
        src/core/MediaEngine.h
        src/core/UsbScanner.cpp
        src/core/UsbScanner.h
        src/controllers/PlaybackController.cpp
        src/controllers/PlaybackController.h
        src/controllers/SettingsController.h
        src/controllers/SettingsController.cpp
        src/models/MediaModel.cpp
        src/models/MediaModel.h
        src/models/TrackItem.h
)

qt_add_qml_module(appAutoPlayer
        URI app_id
        VERSION 1.0
        QML_FILES
        ui/main.qml
        ui/components/SideBar.qml
        ui/components/CustomSlider.qml
        ui/components/PlaybackControls.qml
        ui/components/TrackDelegate.qml
        ui/views/PlayerView.qml
        ui/views/MediaLibraryView.qml
        ui/views/SettingsView.qml

        RESOURCES
        assets/doge.png
        assets/doge2.png
)

target_link_libraries(appAutoPlayer PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
        Qt6::Multimedia
)