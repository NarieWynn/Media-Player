import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "components"
import "views"

Window {
    id: rootWindow
    width: 1024
    height: 600
    visible: true
    title: "Vortex Automotive HMI"
    color: "#0A0A0C"

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // ================= 1. SIDEBAR ĐIỀU HƯỚNG =================
        SideBar {
            id: sideBar
            Layout.fillHeight: true
            Layout.preferredWidth: 100

            onTabClicked: (index) => {
                mainStack.currentIndex = index
                console.log("Đã chuyển sang Tab: " + index)
            }
        }

        // ================= 2. KHU VỰC MÀN HÌNH CHÍNH =================
        // ================= 2. KHU VỰC MÀN HÌNH CHÍNH =================
        StackLayout {
            id: mainStack
            Layout.fillWidth: true
            Layout.fillHeight: true

            currentIndex: sideBar.currentIndex

            PlayerView {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            MediaLibraryView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                // ======== BỔ SUNG KHÚC NÀY NÈ MÀY ========
                // Hứng tín hiệu chọt bài từ Library để nhảy sang tab Player
                onSwitchToPlayerRequested: {
                    sideBar.currentIndex = 0 // Đổi UI Sidebar sáng lên ở nút Player
                    mainStack.currentIndex = 0 // Đổi màn hình chính sang PlayerView
                }
            }

            SettingsView {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    readonly property var memeList: [
        "qrc:/qt/qml/app_id/assets/doge.png",
        "qrc:/qt/qml/app_id/assets/doge2.png"
    ]

    Image {
        id: clickMeme
        width: 80
        height: 80
        visible: false
        z: 9999
        fillMode: Image.PreserveAspectFit

        ParallelAnimation {
            id: memeAnim

            NumberAnimation {
                target: clickMeme
                property: "y"
                to: clickMeme.y - 20
                duration: 800
                easing.type: Easing.OutCubic
            }

            NumberAnimation {
                target: clickMeme
                property: "opacity"
                from: 1.0
                to: 0.0
                duration: 800
                easing.type: Easing.OutCubic
            }

            onFinished: clickMeme.visible = false
        }
    }

    MouseArea {
        anchors.fill: parent
        z: 9998
        propagateComposedEvents: true

        onPressed: (mouse) => {
            memeAnim.stop();
            clickMeme.x = mouse.x - 40;
            clickMeme.y = mouse.y - 40;
            clickMeme.source = rootWindow.memeList[Math.floor(Math.random() * rootWindow.memeList.length)];

            clickMeme.opacity = 1.0;
            clickMeme.visible = true;
            memeAnim.start();

            mouse.accepted = false;
        }
    }

}