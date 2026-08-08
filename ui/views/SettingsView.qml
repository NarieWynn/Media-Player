import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true

    Flickable {
        anchors.fill: parent
        anchors.margins: 40
        contentHeight: contentLayout.height
        clip: true
        ScrollBar.vertical: ScrollBar {
            active: true
            contentItem: Rectangle { implicitWidth: 6; radius: 3; color: "#4A4A4A" }
        }

        ColumnLayout {
            id: contentLayout
            width: parent.width
            spacing: 40

            // ================= HEADER =================
            Text {
                text: "Settings"
                color: "#FFFFFF"
                font.pixelSize: 36
                font.bold: true
            }

            // ================= SECTION 1: HỆ THỐNG & USB =================
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 20

                Text {
                    text: "SYSTEM & MEDIA"
                    color: "#5A5A5A"
                    font.pixelSize: 16
                    font.bold: true
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#2A2A2A"
                }
                RowLayout {
                    Layout.fillWidth: true

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        Text { text: "Auto Play on USB Insert"; color: "#FFFFFF"; font.pixelSize: 22 }
                        Text { text: "Automatically start playing when USB is detected"; color: "#7A7A7A"; font.pixelSize: 14 }
                    }

                    Switch {
                        id: autoPlaySwitch
                        checked: settingsController ? settingsController.autoPlayOnInsert : true
                        onCheckedChanged: {
                            if (settingsController && settingsController.autoPlayOnInsert !== checked) {
                                settingsController.setAutoPlayOnInsert(checked)
                            }
                        }

                        indicator: Rectangle {
                            implicitWidth: 64
                            implicitHeight: 32
                            radius: 16
                            color: autoPlaySwitch.checked ? "#FFFFFF" : "#2A2A2A"
                            border.color: autoPlaySwitch.checked ? "#FFFFFF" : "#4A4A4A"

                            Rectangle {
                                x: autoPlaySwitch.checked ? parent.width - width - 4 : 4
                                y: 4
                                width: 24
                                height: 24
                                radius: 12
                                color: autoPlaySwitch.checked ? "#000000" : "#7A7A7A"
                                Behavior on x { NumberAnimation { duration: 150 } }
                            }
                        }
                    }
                }

                Item { Layout.preferredHeight: 10 }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 20

                    Text { text: "USB Scan Path:"; color: "#FFFFFF"; font.pixelSize: 22; Layout.preferredWidth: 200 }

                    TextField {
                        Layout.fillWidth: true
                        text: settingsController ? settingsController.scanPath : "/media/usb"
                        color: "#FFFFFF"
                        font.pixelSize: 18
                        background: Rectangle {
                            color: "#1A1A1A"
                            radius: 8
                            border.color: "#333333"
                        }
                        onEditingFinished: {
                            if (settingsController) {
                                settingsController.setScanPath(text)
                            }
                        }
                    }
                }
            }

            Item { Layout.preferredHeight: 10 }

            // ================= SECTION 2: GIAO DIỆN & ÂM THANH =================
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 20

                Text {
                    text: "DISPLAY & AUDIO"
                    color: "#5A5A5A"
                    font.pixelSize: 16
                    font.bold: true
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#2A2A2A"
                }

                RowLayout {
                    Layout.fillWidth: true

                    Text { text: "Dark Mode (Vortex Theme)"; color: "#FFFFFF"; font.pixelSize: 22; Layout.fillWidth: true }

                    Switch {
                        id: darkModeSwitch
                        checked: settingsController ? settingsController.darkMode : true
                        onCheckedChanged: {
                            if (settingsController && settingsController.darkMode !== checked) {
                                settingsController.setDarkMode(checked)
                            }
                        }

                        indicator: Rectangle {
                            implicitWidth: 64
                            implicitHeight: 32
                            radius: 16
                            color: darkModeSwitch.checked ? "#FFFFFF" : "#2A2A2A"

                            Rectangle {
                                x: darkModeSwitch.checked ? parent.width - width - 4 : 4
                                y: 4
                                width: 24
                                height: 24
                                radius: 12
                                color: darkModeSwitch.checked ? "#000000" : "#7A7A7A"
                                Behavior on x { NumberAnimation { duration: 150 } }
                            }
                        }
                    }
                }

                Item { Layout.preferredHeight: 10 }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 20

                    Text { text: "System Volume"; color: "#FFFFFF"; font.pixelSize: 22; Layout.preferredWidth: 200 }

                    Text { text: "🔈"; color: "#7A7A7A"; font.pixelSize: 24 }

                    CustomSlider {
                        Layout.fillWidth: true
                        value: (mediaEngine && mediaEngine.player()) ? mediaEngine.player().volume : 0.5

                        onMoved: {
                            if (mediaEngine && mediaEngine.player()) {
                                mediaEngine.player().setVolume(value)
                            }
                        }
                    }

                    Text { text: "🔊"; color: "#FFFFFF"; font.pixelSize: 24 }
                }
            }
        }
    }
}