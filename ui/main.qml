import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "components" // Kéo đồ trong thư mục components ra
import "views"      // Kéo đồ trong thư mục views ra

Window {
    id: rootWindow
    width: 1024
    height: 600
    visible: true
    title: "Vortex Automotive HMI"
    color: "#0A0A0C" // Tone đen tuyền chủ đạo

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // ================= 1. SIDEBAR ĐIỀU HƯỚNG =================
        SideBar {
            id: sideBar
            Layout.fillHeight: true
            Layout.preferredWidth: 100 // Chiều rộng cố định 100px

            // Lắng nghe sự kiện tài xế chọt tab
            onTabClicked: (index) => {
                mainStack.currentIndex = index
                console.log("Đã chuyển sang Tab: " + index)
            }
        }

        // ================= 2. KHU VỰC MÀN HÌNH CHÍNH =================
        StackLayout {
            id: mainStack
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Đồng bộ trang hiện tại của Stack với trang đang chọn trên Sidebar
            currentIndex: sideBar.currentIndex

            // Tab 0: Màn hình phát nhạc (Đĩa than)
            PlayerView {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            // Tab 1: Danh sách bài hát (Library)
            MediaLibraryView {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            // Tab 2: Màn hình Cài đặt
            SettingsView {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    // Đã đổi app_id thành AutoPlayer cho đúng chuẩn CMake của mày
    readonly property var memeList: [
        "qrc:/qt/qml/app_id/assets/doge.png",
        "qrc:/qt/qml/app_id/assets/doge2.png"
    ]

    // CON CHÓ CỐ ĐỊNH (Tối ưu RAM/CPU 100%)
    Image {
        id: clickMeme
        width: 80
        height: 80
        visible: false
        z: 9999
        fillMode: Image.PreserveAspectFit

        // Chạy song song 2 animation: Bay lên + Mờ dần
        ParallelAnimation {
            id: memeAnim

            // 1. Hiệu ứng bay nhẹ lên 20px
            NumberAnimation {
                target: clickMeme
                property: "y"
                to: clickMeme.y - 20
                duration: 800
                easing.type: Easing.OutCubic
            }

            // 2. Hiệu ứng mờ dần
            NumberAnimation {
                target: clickMeme
                property: "opacity"
                from: 1.0
                to: 0.0
                duration: 800
                easing.type: Easing.OutCubic
            }

            // Chạy xong thì ẩn đi
            onFinished: clickMeme.visible = false
        }
    }

    // MOUSEAREA BẮT CLICK
    MouseArea {
        anchors.fill: parent
        z: 9998
        propagateComposedEvents: true

        onPressed: (mouse) => {
            // Tắt animation cũ nếu đang chạy dở
            memeAnim.stop();

            // Đặt lại vị trí xuất phát & đổi ảnh ngẫu nhiên
            clickMeme.x = mouse.x - 40;
            clickMeme.y = mouse.y - 40; // Tọa độ gốc ngay điểm bấm
            clickMeme.source = rootWindow.memeList[Math.floor(Math.random() * rootWindow.memeList.length)];

            // Hiện lại và kích hoạt animation
            clickMeme.opacity = 1.0;
            clickMeme.visible = true;
            memeAnim.start();

            mouse.accepted = false;
        }
    }
}