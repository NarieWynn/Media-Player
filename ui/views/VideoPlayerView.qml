import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import "../components"

Item {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true

    property string videoSource: ""
    readonly property bool isPlaying: videoPlayer.playbackState === MediaPlayer.PlayingState

    function formatTime(ms) {
        if (!ms || ms <= 0) return "0:00";
        var totalSeconds = Math.floor(ms / 1000);
        var minutes = Math.floor(totalSeconds / 60);
        var seconds = totalSeconds % 60;
        return minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
    }

    // ================= BỘ HÀM ĐIỀU KHIỂN ĐỂ NGOÀI GỌI VÀO =================
    // ================= BỘ HÀM ĐIỀU KHIỂN ĐỂ NGOÀI GỌI VÀO =================
    function playVideo(filePath) {
        if (filePath && filePath !== "") {
            // SỬA Ở ĐÂY: QML cộng chuỗi "file://" trực tiếp luôn, đéo cần QUrl
            videoSource = "file://" + filePath;
        }
        videoPlayer.play();
    }
    function pauseVideo() {
        videoPlayer.pause();
    }

    function stopVideo() {
        videoPlayer.stop();
    }

    // ================= MEDIAPLAYER QUẢN LÝ LUỒNG VIDEO =================
    // ================= MEDIAPLAYER QUẢN LÝ LUỒNG VIDEO =================
    MediaPlayer {
        id: videoPlayer
        videoOutput: videoOutput

        // BỔ SUNG DÒNG NÀY ĐỂ MỞ KHÓA ÂM THANH TRONG QT6:
        audioOutput: AudioOutput {}

        source: root.videoSource

        onErrorOccurred: function(error, errorString) {
            console.log("❌ Video Player Error:", errorString);
        }
    }

    // ================= KHUNG VẼ VIDEO (VIDEO OUTPUT) =================
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        radius: 16
        clip: true

        VideoOutput {
            id: videoOutput
            anchors.fill: parent
            fillMode: VideoOutput.PreserveAspectFit
        }

        // Bấm vào màn hình để Hiện/Ẩn bộ điều khiển
        MouseArea {
            anchors.fill: parent
            onClicked: {
                controlsOverlay.visible = !controlsOverlay.visible;
                if (controlsOverlay.visible) {
                    autoHideTimer.restart();
                }
            }
        }

        // ================= OVERLAY BỘ ĐIỀU KHIỂN =================
        Rectangle {
            id: controlsOverlay
            anchors.fill: parent
            color: "#80000000"
            visible: true

            Timer {
                id: autoHideTimer
                interval: 4000
                running: true
                repeat: false
                onTriggered: controlsOverlay.visible = false
            }

            // Tên File Video Phía Trên
            Text {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 20
                text: root.videoSource !== "" ? root.videoSource.split('/').pop() : "No Video Selected"
                color: "#FFFFFF"
                font.pixelSize: 20
                font.bold: true
                elide: Text.ElideRight
                width: parent.width - 40
            }

            // Nút Play / Pause Giữa Màn Hình
            Rectangle {
                width: 72
                height: 72
                radius: 36
                color: "#CCFFFFFF"
                anchors.centerIn: parent

                Text {
                    anchors.centerIn: parent
                    text: root.isPlaying ? "⏸" : "▶"
                    color: "#000000"
                    font.pixelSize: 32
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (root.isPlaying) {
                            root.pauseVideo();
                        } else {
                            // Tạm dừng nhạc MP3 nếu đang chạy
                            if (playbackController && playbackController.isPlaying) {
                                playbackController.togglePlayPause();
                            }
                            root.playVideo();
                        }
                        autoHideTimer.restart();
                    }
                }
            }

            // Thanh Progress Tua Video Phía Dưới
            ColumnLayout {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 20
                spacing: 10

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 15

                    Text {
                        text: root.formatTime(videoPlayer.position)
                        color: "#FFFFFF"
                        font.pixelSize: 16
                    }

                    CustomSlider {
                        Layout.fillWidth: true
                        value: videoPlayer.duration > 0 ? (videoPlayer.position / videoPlayer.duration) : 0

                        onMoved: {
                            if (videoPlayer.duration > 0) {
                                videoPlayer.position = value * videoPlayer.duration;
                            }
                            autoHideTimer.restart();
                        }
                    }

                    Text {
                        text: root.formatTime(videoPlayer.duration)
                        color: "#FFFFFF"
                        font.pixelSize: 16
                    }
                }
            }
        }
    }

    Component.onDestruction: root.stopVideo()
}