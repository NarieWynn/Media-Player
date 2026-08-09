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
            color: "transparent"
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

            // Thanh Progress Tua Video Phía Dưới
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 20

                // Khóa chiều cao cố định cho cái hộp nổi luôn cho khỏe
                height: 140

                color: "#A018181C"
                radius: 16
                border.color: "#20FFFFFF"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 10

                    // ======== CỤM 3 NÚT: PREV - PLAY/PAUSE - NEXT ========
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 40
                        Layout.alignment: Qt.AlignHCenter

                        // Nút Previous
                        Rectangle {
                            Layout.alignment: Qt.AlignVCenter
                            width: 48; height: 48; radius: 24; color: "#CCFFFFFF"

                            Image {
                                anchors.centerIn: parent
                                width: 28; height: 28
                                sourceSize.width: 128; sourceSize.height: 128
                                source: "qrc:/qt/qml/app_id/assets/prev.svg"
                                fillMode: Image.PreserveAspectFit
                                smooth: true; mipmap: true
                            }
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
                            Layout.alignment: Qt.AlignVCenter
                            width: 56; height: 56; radius: 28; color: "#CCFFFFFF"

                            Text {
                                anchors.centerIn: parent
                                text: root.isPlaying ? "❚❚" : "▶"
                                font.pixelSize: 24
                                color: "#000000"
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (root.isPlaying) root.pauseVideo();
                                    else root.playVideo();
                                    autoHideTimer.restart();
                                }
                            }
                        }

                        // Nút Next
                        Rectangle {
                            Layout.alignment: Qt.AlignVCenter
                            width: 48; height: 48; radius: 24; color: "#CCFFFFFF"

                            Image {
                                anchors.centerIn: parent
                                width: 28; height: 28
                                sourceSize.width: 128; sourceSize.height: 128
                                source: "qrc:/qt/qml/app_id/assets/next.svg"
                                fillMode: Image.PreserveAspectFit
                                smooth: true; mipmap: true
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (playbackController) playbackController.next();
                                    autoHideTimer.restart();
                                }
                            }
                        }
                    }

                    // ======== THANH SLIDER VÀ THỜI GIAN ========
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 15

                        Text {
                            text: playbackController ? playbackController.formatTime(videoPlayer.position) : "0:00"
                            color: "#FFFFFF"
                            font.pixelSize: 14
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
                            font.pixelSize: 14
                        }
                    }
                }
            }
        }
    }

    Component.onDestruction: root.stopVideo()
}