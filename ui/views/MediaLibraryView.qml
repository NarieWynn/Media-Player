import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 30

        // ================= 1. HEADER / TAB BAR =================
        RowLayout {
            Layout.fillWidth: true
            spacing: 40

            Text {
                text: "USB Audio"
                color: "#FFFFFF"
                font.pixelSize: 32
                font.bold: true
            }

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

            Item { Layout.fillWidth: true }

            Text {
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

            clip: true
            spacing: 8

            model: mediaModel

            // Gọi cái TrackDelegate ra xài
            delegate: TrackDelegate {
                width: mediaList.width
                title: model.title !== undefined ? model.title : "Unknown"
                artist: model.artist !== undefined ? model.artist : "Unknown"
                duration: model.formattedDuration !== undefined ? model.formattedDuration : "0:00"
                coverArt: model.coverArt
                isActive: index === playbackController.currentIndex

                onClicked: {
                    playbackController.playTrack(index)
                }
            }

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