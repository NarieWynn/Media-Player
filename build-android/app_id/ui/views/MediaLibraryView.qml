import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true

    // Bắn tín hiệu này ra ngoài (cho main.qml) để nó tự nhảy sang tab PlayerView
    signal switchToPlayerRequested()

    // 0: Tab USB Audio (MP3/FLAC), 1: Tab Videos (MP4/MKV)
    property int currentTab: 0

    ColumnLayout {
        id: libraryLayout
        anchors.fill: parent
        anchors.margins: 30
        spacing: 20

        // 1. HEADER CHỌN TAB LỌC DANH SÁCH
        RowLayout {
            spacing: 30

            Text {
                text: "USB Audio"
                color: root.currentTab === 0 ? "#FFFFFF" : "#5A5A5A"
                font.pixelSize: 32
                font.bold: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.currentTab = 0
                }
            }

            Text {
                text: "Videos"
                color: root.currentTab === 1 ? "#FFFFFF" : "#5A5A5A"
                font.pixelSize: 32
                font.bold: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.currentTab = 1
                }
            }

            Item { Layout.fillWidth: true }

            Text {
                text: mediaModel ? mediaModel.rowCount() + " Items" : "0 Items"
                color: "#5A5A5A"
                font.pixelSize: 18
            }
        }

        // 2. DANH SÁCH BÀI HÁT / VIDEO
        ListView {
            id: mediaList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 0
            model: mediaModel

            delegate: TrackDelegate {
                id: delegateRoot

                // Lọc hiển thị: Đang ở tab nào thì hiện loại file đó
                property bool isMatchTab: (root.currentTab === 1) ? model.isVideo : !model.isVideo

                width: ListView.view ? ListView.view.width : 400
                visible: delegateRoot.isMatchTab
                height: delegateRoot.isMatchTab ? 84 : 0

                title: model.title
                artist: model.artist
                duration: model.formattedDuration
                coverArt: model.coverArt
                isActive: index === playbackController.currentIndex

                onClicked: {
                    // DÙ LÀ MP3 HAY MP4 THÌ CŨNG CHỈ CẦN 2 BƯỚC NÀY:

                    // 1. Quăng index cho Backend C++, nó đã được dạy để tự biết phải làm gì (phát hay câm)
                    if (playbackController) {
                        playbackController.playTrack(index)
                    }

                    // 2. Bắn tín hiệu để thằng cha (main.qml) chuyển màn hình sang PlayerView
                    root.switchToPlayerRequested()
                }
            }
        }
    }
}