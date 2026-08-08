import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true
    signal playVideoRequested(string filePath)

    // 0: Tab USB Audio (MP3/FLAC), 1: Tab Videos (MP4/MKV)
    property int currentTab: 0

    // Biến này để biết khi nào thì bung Video ra toàn màn hình
    property bool isVideoPlaying: false

    // ================= A. MÀN HÌNH DANH SÁCH (LIBRARY) =================
    ColumnLayout {
        id: libraryLayout
        anchors.fill: parent
        anchors.margins: 30
        spacing: 20

        // Ẩn toàn bộ danh sách đi khi đang xem Video
        visible: !root.isVideoPlaying

        // 1. HEADER CHỌN TAB
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

        // 2. DANH SÁCH (TỰ ĐỘNG BẮT MP3 HAY MP4 THEO TAB)
        ListView {
            id: mediaList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 0
            model: mediaModel
            // ĐÃ XÓA DÒNG `visible` NGU HỌC ĐỂ NÓ HIỆN Ở CẢ 2 TAB!

            delegate: TrackDelegate {
                id: delegateRoot

                // Cốt lõi ở đây: Tab 1 thì lọc Video, Tab 0 thì lọc Audio
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
                    if (model.isVideo) {
                        console.log(">>> Gọi phát Video MP4:", model.filePath)

                        if (playbackController && playbackController.isPlaying) {
                            playbackController.togglePlayPause()
                        }

                        // Mở màn hình Video lên và truyền file vào phát
                        root.isVideoPlaying = true
                        videoPlayerView.playVideo(model.filePath)

                    } else {
                        if (playbackController) {
                            playbackController.playTrack(index)
                        }
                    }
                }
            }
        }
    }

    // ================= B. MÀN HÌNH XEM VIDEO (PLAYER) =================
    Item {
        anchors.fill: parent
        visible: root.isVideoPlaying // Bị giấu đi, chỉ hiện khi chọt vào Video
        z: 99 // Nổi lềnh bềnh đè lên danh sách

        VideoPlayerView {
            id: videoPlayerView
            anchors.fill: parent
        }

        // Nút THOÁT ra khỏi Video về lại danh sách
        Rectangle {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 20
            width: 48
            height: 48
            radius: 24
            color: "#80000000" // Đen mờ cho ngầu

            Text {
                anchors.centerIn: parent
                text: "X"
                color: "#FFFFFF"
                font.pixelSize: 24
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    videoPlayerView.stopVideo() // Tắt mẹ hình & tiếng
                    root.isVideoPlaying = false // Đóng khung Video, hiện lại danh sách
                }
            }
        }
    }
}