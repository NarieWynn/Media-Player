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

    function playVideo(filePath) {
        if (filePath && filePath !== "") {
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
    MediaPlayer {
        id: videoPlayer
        videoOutput: videoOutput
        audioOutput: AudioOutput {}
        source: root.videoSource

        onErrorOccurred: function(error, errorString) {
            console.log("❌ Video Player Error:", errorString);
        }

        // ĐÂY LÀ CHÌA KHÓA: Khi video chạy hết, gọi C++ để nảy bài tiếp theo!
        onMediaStatusChanged: {
            if (mediaStatus === MediaPlayer.EndOfMedia) {
                console.log(">>> Video đã kết thúc! Tự động Next bài...");
                if (playbackController) {
                    playbackController.next();
                }
            }
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

            // Tên File Video
            Text {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 20
                text: root.videoSource !== "" ? decodeURIComponent(root.videoSource.split('/').pop()) : "No Video Selected"
                color: "#FFFFFF"
                font.pixelSize: 20
                font.bold: true
                elide: Text.ElideRight
                width: parent.width - 40
            }

            // ======== CỤM 3 NÚT: PREV - PLAY/PAUSE - NEXT ========
            RowLayout {
                anchors.centerIn: parent
                spacing: 40

                // Nút Previous
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter // <-- THÊM DÒNG NÀY ĐỂ ÉP CĂN GIỮA
                    width: 56; height: 56; radius: 28; color: "#CCFFFFFF"

                    Text { anchors.centerIn: parent; text: "⏮"; font.pixelSize: 24; color: "#000000" }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (playbackController) playbackController.previous();
                            autoHideTimer.restart();
                        }
                    }
                }

                // Nút Play / Pause
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter // <-- THÊM DÒNG NÀY ĐỂ ÉP CĂN GIỮA
                    width: 72; height: 72; radius: 36; color: "#CCFFFFFF"

                    Text { anchors.centerIn: parent; text: root.isPlaying ? "⏸" : "▶"; font.pixelSize: 32; color: "#000000" }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (root.isPlaying) {
                                root.pauseVideo();
                            } else {
                                root.playVideo();
                            }
                            autoHideTimer.restart();
                        }
                    }
                }

                // Nút Next
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter // <-- THÊM DÒNG NÀY ĐỂ ÉP CĂN GIỮA
                    width: 56; height: 56; radius: 28; color: "#CCFFFFFF"

                    Text { anchors.centerIn: parent; text: "⏭"; font.pixelSize: 24; color: "#000000" }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (playbackController) playbackController.next();
                            autoHideTimer.restart();
                        }
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
                        // Tạm gọi code định dạng thời gian của backend C++ cho nhẹ QML
                        text: playbackController ? playbackController.formatTime(videoPlayer.position) : "0:00"
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
                        text: playbackController ? playbackController.formatTime(videoPlayer.duration) : "0:00"
                        color: "#FFFFFF"
                        font.pixelSize: 16
                    }
                }
            }
        }
    }

    Component.onDestruction: root.stopVideo()
}