import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components" // Import để lôi CustomSlider và PlaybackControls ra xài

Item {
    id: root
    anchors.fill: parent

    // Các biến giả lập trạng thái (Sau này sẽ nối với C++ Backend)
    property bool isPlaying: false
    property real progress: 0.35

    RowLayout {
        anchors.fill: parent
        anchors.margins: 50 // Margin rộng rãi cho HMI
        spacing: 60

        // ================= 1. BÊN TRÁI: ĐĨA THAN / ALBUM ART =================
        Item {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 320
            Layout.preferredHeight: 320

            Rectangle {
                id: albumArt
                anchors.fill: parent
                radius: width / 2
                color: "#121212" // Xám gần đen
                border.color: "#2A2A2A"
                border.width: 3

                // Cái lỗ giữa đĩa than
                Rectangle {
                    anchors.centerIn: parent
                    width: 80
                    height: 80
                    radius: 40
                    color: "#0A0A0C" // Trùng với màu nền tổng của app
                    border.color: "#1A1A1A"
                    border.width: 2
                }

                // Hiệu ứng xoay vòng đều đều khi isPlaying = true
                NumberAnimation on rotation {
                    from: 0; to: 360
                    duration: 10000 // Quay 1 vòng mất 10s (chậm rãi, chill)
                    loops: Animation.Infinite
                    running: root.isPlaying // Phát nhạc thì quay, ngắt nhạc thì dừng
                }
            }
        }

        // ================= 2. BÊN PHẢI: INFO & CONTROLS =================
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 10

            Item { Layout.fillHeight: true } // Đẩy cụm control xuống giữa

            // Tên bài hát & Ca sĩ (Bắt buộc dùng Elide cắt chữ nếu quá dài)
            Text {
                text: "Starboy"
                color: "#FFFFFF"
                font.pixelSize: 48
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                text: "The Weeknd ft. Daft Punk"
                color: "#7A7A7A"
                font.pixelSize: 24
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            // Nhãn định dạng âm thanh (Audio Format Badge) - Nhìn cho nguy hiểm
            Rectangle {
                Layout.topMargin: 5
                Layout.preferredWidth: 90
                Layout.preferredHeight: 26
                radius: 13
                color: "#1A1A1A"
                border.color: "#333333"

                Text {
                    anchors.centerIn: parent
                    text: "FLAC"
                    color: "#D0D0D0"
                    font.pixelSize: 12
                    font.bold: true
                }
            }

            Item { Layout.preferredHeight: 30 } // Khoảng cách giữa Info và Slider

            // Thanh Progress Slider (Gọi CustomSlider ra xài)
            RowLayout {
                Layout.fillWidth: true
                spacing: 15

                Text { text: "01:24"; color: "#7A7A7A"; font.pixelSize: 16 }

                CustomSlider {
                    Layout.fillWidth: true
                    value: root.progress
                    onMoved: root.progress = value
                }

                Text { text: "03:50"; color: "#7A7A7A"; font.pixelSize: 16 }
            }

            Item { Layout.preferredHeight: 20 }

            // Bộ nút điều khiển (Gọi PlaybackControls ra xài)
            PlaybackControls {
                Layout.alignment: Qt.AlignHCenter
                isPlaying: root.isPlaying
                onPlayPauseClicked: {
                    root.isPlaying = !root.isPlaying
                    console.log("Play/Pause clicked!")
                }
                onNextClicked: console.log("Next track!")
                onPrevClicked: console.log("Prev track!")
            }

            Item { Layout.fillHeight: true } // Đẩy cụm control lên giữa
        }
    }
}