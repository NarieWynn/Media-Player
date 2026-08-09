import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    width: 100
    color: "#0A0A0C"

    Rectangle {
        width: 1
        height: parent.height
        anchors.right: parent.right
        color: "#2A2A2A"
    }

    property int currentIndex: 0
    signal tabClicked(int index)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        anchors.topMargin: 30
        anchors.bottomMargin: 30
        spacing: 0
        Item {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 60
            Layout.preferredHeight: 60

            Rectangle {
                anchors.centerIn: parent
                width: 48
                height: 48
                radius: 24
                color: "#FFFFFF"

                Image {
                    anchors.centerIn: parent
                    width: 28; height: 28
                    sourceSize.width: 128; sourceSize.height: 128
                    source: "qrc:/qt/qml/app_id/assets/doge.png"
                    fillMode: Image.PreserveAspectFit
                    smooth: true; mipmap: true
                }
            }
        }

        Item { Layout.preferredHeight: 10 }

        Repeater {
            model: [
                { icon: "♫", label: "Player" },
                { icon: "☰", label: "Library" },
                //{ icon: "⚙", label: "Settings" }
            ]

            delegate: Rectangle {
                required property int index
                required property var modelData

                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 70
                Layout.fillHeight: true
                radius: 16

                color: root.currentIndex === index ? "#202020" : (mouseArea.pressed ? "#151515" : "transparent")

                Rectangle {
                    width: 4
                    height: 30
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 2
                    color: "#FFFFFF"
                    visible: root.currentIndex === index
                }

                Text {
                    anchors.centerIn: parent
                    text: modelData.icon
                    color: root.currentIndex === index ? "#FFFFFF" : "#5A5A5A"
                    font.pixelSize: 32
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: {
                        root.currentIndex = parent.index
                        root.tabClicked(parent.index)
                    }
                }

                scale: mouseArea.pressed ? 0.9 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }
            }
        }

        Item { Layout.preferredHeight: 10 }
    }
}