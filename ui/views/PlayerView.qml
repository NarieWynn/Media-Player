import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

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

    property bool isPlaying: playbackController ? playbackController.isPlaying : false

    property var currentTrack: null

    function updateCurrentTrack() {
        if (mediaModel && playbackController && playbackController.currentIndex >= 0) {
            currentTrack = mediaModel.getTrackData(playbackController.currentIndex);
        } else {
            currentTrack = null;
        }
    }

    Connections {
        target: playbackController
        function onCurrentIndexChanged() {
            root.updateCurrentTrack();
        }
    }

    Component.onCompleted: updateCurrentTrack()

    RowLayout {
        anchors.fill: parent
        anchors.margins: 50
        spacing: 60

        // ================= KHUNG ĐĨA THAN + THUMBNAIL PHỐNG TO =================
        Item {
            id: vinylContainer
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 320
            Layout.preferredHeight: 320

            Image {
                id: vinylDisc
                anchors.fill: parent
                source: "qrc:/qt/qml/app_id/assets/vinyl.png"
                fillMode: Image.PreserveAspectFit

                Image {
                    id: albumArtImage
                    width: parent.width * 0.48
                    height: width
                    anchors.centerIn: parent

                    source: (root.currentTrack && root.currentTrack.coverArt && root.currentTrack.coverArt !== "")
                        ? root.currentTrack.coverArt
                        : "qrc:/qt/qml/app_id/assets/default_cover.png"

                    fillMode: Image.PreserveAspectFit
                }
            }

            NumberAnimation on rotation {
                from: 0; to: 360
                duration: 12000
                loops: Animation.Infinite
                running: true
                paused: !root.isPlaying
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 10

            Item { Layout.fillHeight: true }

            Text {
                text: root.currentTrack ? root.currentTrack.title : "Unknown Title"
                color: "#FFFFFF"
                font.pixelSize: 48
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                text: root.currentTrack ? root.currentTrack.artist : "Unknown Artist"
                color: "#7A7A7A"
                font.pixelSize: 24
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

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

            Item { Layout.preferredHeight: 30 }

            RowLayout {
                Layout.fillWidth: true
                spacing: 15

                Text {
                    text: root.formatTime(mediaEngine && mediaEngine.player() ? mediaEngine.player().position : 0)
                    color: "#7A7A7A"
                    font.pixelSize: 16
                }

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

                Text {
                    text: root.formatTime(mediaEngine && mediaEngine.player() ? mediaEngine.player().duration : 0)
                    color: "#7A7A7A"
                    font.pixelSize: 16
                }
            }

            Item { Layout.preferredHeight: 20 }

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

            Item { Layout.fillHeight: true }
        }
    }
}