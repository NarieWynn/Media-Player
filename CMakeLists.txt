cmake_minimum_required(VERSION 3.16)
project(AutoPlayer VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick Multimedia)

qt_standard_project_setup()
# Bật policy QTP0001 để Qt6 tự động fix đường dẫn resource cho folder con
qt_policy(SET QTP0001 NEW)

qt_add_executable(appAutoPlayer
        src/main.cpp
        src/core/AudioPlayer.h
        src/core/AudioPlayer.cpp
)

# Đổi URI thành AutoPlayer đồng bộ với project
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
)

target_link_libraries(appAutoPlayer PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
        Qt6::Multimedia
)