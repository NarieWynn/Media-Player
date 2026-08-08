import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    width: ListView.view ? ListView.view.width : 400
    height: 84

    property string title: "Unknown Title"
    property string artist: "Unknown Artist"
    property string duration: "0:00"
    property string coverArt: ""
    property bool isActive: false


    signal clicked()

    Rectangle {
        id: bgRect
        anchors.fill: parent
        anchors.margins: 4
        radius: 12

        color: mouseArea.pressed ? "#2A2A2A" : (root.isActive ? "#1A1A1A" : "transparent")

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 15

            Rectangle {
                width: 4
                height: parent.height - 20
                radius: 2
                color: root.isActive ? "#FFFFFF" : "transparent"
            }

            Rectangle {
                Layout.preferredWidth: 60
                Layout.preferredHeight: 60
                radius: 8
                color: "#252525"
                clip: true

                Image {
                    anchors.fill: parent
                    source: root.coverArt
                    fillMode: Image.PreserveAspectCrop
                    visible: root.coverArt !== "" && root.coverArt !== "Unknown Cover Art"
                }

                Text {
                    anchors.centerIn: parent
                    text: "♫"
                    color: "#5A5A5A"
                    font.pixelSize: 24
                    visible: root.coverArt === "" || root.coverArt === "Unknown Cover Art"
                }

                Rectangle {
                    anchors.fill: parent
                    color: "#80000000" // Màn mờ mỏng màu đen
                    visible: root.isActive

                    Text {
                        anchors.centerIn: parent
                        text: "▶"
                        color: "#FFFFFF"
                        font.pixelSize: 22
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: root.title
                    color: root.isActive ? "#FFFFFF" : "#D0D0D0"
                    font.pixelSize: 22
                    font.bold: root.isActive
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Text {
                    text: root.artist
                    color: "#7A7A7A"
                    font.pixelSize: 16
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }

            Text {
                text: root.duration
                color: "#7A7A7A"
                font.pixelSize: 18
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Layout.rightMargin: 15
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: root.clicked()
        }

        scale: mouseArea.pressed ? 0.98 : 1.0
        Behavior on scale { NumberAnimation { duration: 100 } }
    }
}