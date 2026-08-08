import QtQuick
import QtQuick.Controls

Slider {
    id: control
    implicitWidth: 250
    implicitHeight: 48

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 250
        implicitHeight: 8
        width: control.availableWidth
        height: implicitHeight
        radius: 4
        color: "#2A2A2A"
        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: "#FFFFFF"
            radius: 4
        }
    }

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 32
        implicitHeight: 32
        radius: 16
        antialiasing: true
        color: control.pressed ? "#D0D0D0" : "#FFFFFF"
        border.color: "#000000"
        border.width: 2

        scale: control.pressed ? 0.9 : 1.0
        Behavior on scale {
            NumberAnimation { duration: 100 }
        }
    }
}