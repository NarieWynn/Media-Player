import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components" // Import để lôi CustomSlider và PlaybackControls ra xài

Item {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true

    function formatTime(ms) {
        if (!ms || ms <= 0) return "0:00";
        var totalSeconds = Math.floor(ms / 1000);
        var minutes = Math.floor(totalSeconds / 60);
        var seconds = totalSeconds % 60;
        return minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
    }

    // KẾT NỐI VỚI C++: Lấy trạng thái Play/Pause từ Backend
    property bool isPlaying: playbackController ? playbackController.isPlaying : false

    // Tạo property lưu thông tin bài hát hiện tại để code bên dưới cho gọn
    property var currentTrack: null

    // Hàm nhỏ để tự động móc thông tin bài hát từ Model ra mỗi khi index đổi
    function updateCurrentTrack() {
        if (mediaModel && playbackController && playbackController.currentIndex >= 0) {
            currentTrack = mediaModel.getTrackData(playbackController.currentIndex);
        } else {
            currentTrack = null;
        }
    }

    // Lắng nghe sự kiện đổi bài từ Backend
    Connections {
        target: playbackController
        function onCurrentIndexChanged() {
            root.updateCurrentTrack();
        }
    }

    // Gọi lần đầu khi load View
    Component.onCompleted: updateCurrentTrack()

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

            // Tên bài hát (Lấy từ C++)
            Text {
                text: root.currentTrack ? root.currentTrack.title : "Unknown Title"
                color: "#FFFFFF"
                font.pixelSize: 48
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            // Tên ca sĩ (Lấy từ C++)
            Text {
                text: root.currentTrack ? root.currentTrack.artist : "Unknown Artist"
                color: "#7A7A7A"
                font.pixelSize: 24
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            // Nhãn định dạng âm thanh (Tạm thời fix cứng là MP3 vì scanner nãy chỉ bắt .mp3)
            Rectangle {
                Layout.topMargin: 5
                Layout.preferredWidth: 90
                Layout.preferredHeight: 26
                radius: 13
                color: "#1A1A1A"
                border.color: "#333333"

                Text {
                    anchors.centerIn: parent
                    text: "MP3"
                    color: "#D0D0D0"
                    font.pixelSize: 12
                    font.bold: true
                }
            }

            Item { Layout.preferredHeight: 30 } // Khoảng cách giữa Info và Slider

            // Thanh Progress Slider
            RowLayout {
                Layout.fillWidth: true
                spacing: 15

                // 1. Thời gian đang chạy (Phần này nhảy số liên tục theo MediaPlayer position)
                Text {
                    text: root.formatTime(mediaEngine && mediaEngine.player() ? mediaEngine.player().position : 0)
                    color: "#7A7A7A"
                    font.pixelSize: 16
                }

                // 2. Thanh kéo tua nhạc
                CustomSlider {
                    Layout.fillWidth: true
                    value: (mediaEngine && mediaEngine.player() && mediaEngine.player().duration > 0)
                        ? (mediaEngine.player().position / mediaEngine.player().duration)
                        : 0

                    onMoved: {
                        if (mediaEngine && mediaEngine.player() && mediaEngine.player().duration > 0) {
                            var targetPos = value * mediaEngine.player().duration;
                            mediaEngine.player().seek(targetPos);
                        }
                    }
                }

                // 3. Tổng thời lượng bài hát (Lấy thẳng từ C++ MediaPlayer)
                Text {
                    text: root.formatTime(mediaEngine && mediaEngine.player() ? mediaEngine.player().duration : 0)
                    color: "#7A7A7A"
                    font.pixelSize: 16
                }
            }

            Item { Layout.preferredHeight: 20 }

            // Bộ nút điều khiển (Đã móc vào C++)
            PlaybackControls {
                Layout.alignment: Qt.AlignHCenter
                isPlaying: root.isPlaying

                onPlayPauseClicked: {
                    if (playbackController) {
                        playbackController.togglePlayPause()
                    }
                }
                onNextClicked: if (playbackController) playbackController.next()
                onPrevClicked: if (playbackController) playbackController.previous()
            }

            Item { Layout.fillHeight: true } // Đẩy cụm control lên giữa
        }
    }
}