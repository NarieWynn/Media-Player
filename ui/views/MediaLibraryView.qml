import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components" // Import thư mục chứa TrackDelegate

Item {
    id: root

    // View này sẽ bám full màn hình khu vực hiển thị (trừ cái Sidebar ra)
    anchors.fill: parent

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
                text: "128 Tracks"
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

            // Biến nội bộ để theo dõi bài nào đang được chọn/phát
            property int currentPlayingIndex: 0

            // Dữ liệu giả lập (Sau này C++ Backend sẽ ném cái mô hình dữ liệu thật vào đây)
            model: ListModel {
                ListElement { title: "Starboy"; artist: "The Weeknd ft. Daft Punk"; duration: "3:50" }
                ListElement { title: "Blinding Lights"; artist: "The Weeknd"; duration: "3:20" }
                ListElement { title: "Nightcall"; artist: "Kavinsky"; duration: "4:19" }
                ListElement { title: "Get Lucky"; artist: "Daft Punk ft. Pharrell Williams"; duration: "6:09" }
                ListElement { title: "Lose Yourself to Dance"; artist: "Daft Punk"; duration: "5:53" }
                ListElement { title: "Instant Crush"; artist: "Daft Punk"; duration: "5:38" }
                ListElement { title: "Giorgio by Moroder"; artist: "Daft Punk"; duration: "9:04" }
            }

            // Gọi cái TrackDelegate mày vừa viết hồi nãy ra xài
            delegate: TrackDelegate {
                width: mediaList.width
                title: model.title
                artist: model.artist
                duration: model.duration

                // Nếu index của bài này trùng với index đang phát thì nó sẽ sáng lên
                isActive: index === mediaList.currentPlayingIndex

                onClicked: {
                    mediaList.currentPlayingIndex = index
                    console.log("Request play track index: " + index)
                    // Chỗ này sau sẽ gọi C++ Backend: backend.playTrack(index)
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