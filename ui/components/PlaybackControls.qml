import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
    id: root
    spacing: 30

    property bool isPlaying: false
    property bool isShuffle: false
    property bool isRepeat: false

    signal playPauseClicked()
    signal nextClicked()
    signal prevClicked()
    signal shuffleClicked()
    signal repeatClicked()

    Button {
        Layout.alignment: Qt.AlignVCenter
        implicitWidth: 56
        implicitHeight: 56
        background: Rectangle {
            color: "transparent"
        }
        contentItem: Text {
            text: "🔀"
            color: root.isShuffle ? "#FFFFFF" : "#4A4A4A"
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: {
            root.isShuffle = !root.isShuffle
            root.shuffleClicked()
        }
    }

    Button {
        Layout.alignment: Qt.AlignVCenter
        implicitWidth: 72
        implicitHeight: 72
        background: Rectangle {
            radius: 36
            color: parent.pressed ? "#2A2A2A" : "transparent"
        }
        contentItem: Text {
            text: "⏮"
            color: "#FFFFFF"
            font.pixelSize: 32
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: root.prevClicked()
    }

    Button {
        Layout.alignment: Qt.AlignVCenter
        implicitWidth: 96
        implicitHeight: 96
        background: Rectangle {
            radius: 48
            color: parent.pressed ? "#D0D0D0" : "#FFFFFF"
        }
        contentItem: Text {
            text: root.isPlaying ? "❚❚" : "▶"
            color: "#000000"
            font.pixelSize: 36
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        scale: pressed ? 0.92 : 1.0
        Behavior on scale { NumberAnimation { duration: 100 } }

        onClicked: {
            root.playPauseClicked()
        }
    }

    Button {
        Layout.alignment: Qt.AlignVCenter
        implicitWidth: 72
        implicitHeight: 72
        background: Rectangle {
            radius: 36
            color: parent.pressed ? "#2A2A2A" : "transparent"
        }
        contentItem: Text {
            text: "⏭"
            color: "#FFFFFF"
            font.pixelSize: 32
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: root.nextClicked()
    }

    Button {
        Layout.alignment: Qt.AlignVCenter
        implicitWidth: 56
        implicitHeight: 56
        background: Rectangle {
            color: "transparent"
        }
        contentItem: Text {
            text: "🔁"
            color: root.isRepeat ? "#FFFFFF" : "#4A4A4A"
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: {
            root.isRepeat = !root.isRepeat
            root.repeatClicked()
        }
    }
}