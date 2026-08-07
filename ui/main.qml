import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "components" // Kéo đồ trong thư mục components ra
import "views"      // Kéo đồ trong thư mục views ra

Window {
    id: root
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
}