import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root

    // View này sẽ bám full màn hình khu vực hiển thị (trừ cái Sidebar ra)
    Layout.fillWidth: true
    Layout.fillHeight: true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40 // Margin to ra cho không gian nó thoáng, sang trọng
        spacing: 30

        // ================= 1. HEADER / TAB BAR =================
        RowLayout {
            Layout.fillWidth: true
            spacing: 40

            // Giả lập Tab Đang chọn (Sáng)
            Text {
                text: "USB Audio"
                color: "#FFFFFF"
                font.pixelSize: 32
                font.bold: true
            }

            // Giả lập Tab Chưa chọn (Xám mờ)
            Text {
                text: "Videos"
                color: "#5A5A5A"
                font.pixelSize: 32
                font.bold: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: console.log("Chuyển sang tab Video (Làm sau)")
                }
            }

            Item { Layout.fillWidth: true } // Spacer đẩy cái Track Count sang sát mép phải

            Text {
                // Đếm số lượng bài hát thực tế từ C++ MediaModel
                text: mediaModel ? mediaModel.rowCount() + " Tracks" : "0 Tracks"
                color: "#5A5A5A"
                font.pixelSize: 18
            }
        }

        // ================= 2. DANH SÁCH BÀI HÁT =================
        ListView {
            id: mediaList
            Layout.fillWidth: true
            Layout.fillHeight: true

            // CỰC KỲ QUAN TRỌNG: clip = true để lúc cuộn, text không bị tràn đâm xuyên lên cái Header
            clip: true
            spacing: 8

            // KẾT NỐI VỚI C++ BACKEND: Ăn thẳng data từ biến global mediaModel mày đã đăng ký ở main.cpp
            model: mediaModel

            // Gọi cái TrackDelegate ra xài
            delegate: TrackDelegate {
                width: mediaList.width

                // Gắn dữ liệu từ các roles của C++ vào (title, artist, formattedDuration)
                title: model.title !== undefined ? model.title : "Unknown"
                artist: model.artist !== undefined ? model.artist : "Unknown"
                duration: model.formattedDuration !== undefined ? model.formattedDuration : "0:00"

                // KẾT NỐI VỚI C++ BACKEND: Highlight bài đang phát nhờ vào playbackController
                isActive: index === playbackController.currentIndex

                onClicked: {
                    // Bắn tín hiệu chọt bài hát thẳng xuống C++
                    playbackController.playTrack(index)
                }
            }

            // Scrollbar (Thanh cuộn dọc) - Ẩn hiện thông minh, style xám đen
            ScrollBar.vertical: ScrollBar {
                active: true
                policy: ScrollBar.AsNeeded
                contentItem: Rectangle {
                    implicitWidth: 6
                    radius: 3
                    color: "#4A4A4A"
                }
            }
        }
    }
}