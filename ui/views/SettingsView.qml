import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components" // Lôi CustomSlider ra xài cho phần Âm lượng

Item {
    id: root
    anchors.fill: parent

    Flickable {
        anchors.fill: parent
        anchors.margins: 40
        contentHeight: contentLayout.height
        clip: true // Chặn không cho cuộn văng ra khỏi mép

        // Ẩn thanh cuộn nếu không cần thiết
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

            // ================= SECTION 1: HỆ THỐNG & AN TOÀN =================
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 20

                Text {
                    text: "SYSTEM & SAFETY"
                    color: "#5A5A5A"
                    font.pixelSize: 16
                    font.bold: true
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#2A2A2A"
                }

                // Công tắc: Cho phép xem Video khi xe di chuyển
                RowLayout {
                    Layout.fillWidth: true

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        Text { text: "Allow Video While Driving"; color: "#FFFFFF"; font.pixelSize: 22 }
                        Text { text: "Warning: May distract the driver"; color: "#7A7A7A"; font.pixelSize: 14 }
                    }

                    Switch {
                        id: videoSwitch
                        checked: true // Mặc định bật cho em mày xem :v

                        // Custom lại cái Switch cho bự và ra chất Monochrome
                        indicator: Rectangle {
                            implicitWidth: 64
                            implicitHeight: 32
                            radius: 16
                            // Bật thì nền trắng, tắt thì nền xám
                            color: videoSwitch.checked ? "#FFFFFF" : "#2A2A2A"
                            border.color: videoSwitch.checked ? "#FFFFFF" : "#4A4A4A"

                            Rectangle {
                                // Cục tròn tròn chạy qua chạy lại
                                x: videoSwitch.checked ? parent.width - width - 4 : 4
                                y: 4
                                width: 24
                                height: 24
                                radius: 12
                                // Bật thì cục tròn màu đen (nổi trên nền trắng), tắt thì xám đậm
                                color: videoSwitch.checked ? "#000000" : "#7A7A7A"
                                Behavior on x { NumberAnimation { duration: 150 } } // Animation mượt
                            }
                        }
                    }
                }
            }

            Item { Layout.preferredHeight: 10 } // Spacer

            // ================= SECTION 2: ÂM THANH =================
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 20

                Text {
                    text: "AUDIO & EQUALIZER"
                    color: "#5A5A5A"
                    font.pixelSize: 16
                    font.bold: true
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#2A2A2A"
                }

                // Slider chỉnh âm lượng (Dùng lại CustomSlider)
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 20

                    Text { text: "System Volume"; color: "#FFFFFF"; font.pixelSize: 22; Layout.preferredWidth: 200 }

                    Text { text: "🔈"; color: "#7A7A7A"; font.pixelSize: 24 }

                    CustomSlider {
                        Layout.fillWidth: true
                        value: 0.6 // 60%
                    }

                    Text { text: "🔊"; color: "#FFFFFF"; font.pixelSize: 24 }
                }

                Item { Layout.preferredHeight: 10 }

                // Công tắc: Bass Boost
                RowLayout {
                    Layout.fillWidth: true

                    Text { text: "Bass Boost"; color: "#FFFFFF"; font.pixelSize: 22; Layout.fillWidth: true }

                    Switch {
                        id: bassSwitch
                        checked: false

                        indicator: Rectangle {
                            implicitWidth: 64
                            implicitHeight: 32
                            radius: 16
                            color: bassSwitch.checked ? "#FFFFFF" : "#2A2A2A"

                            Rectangle {
                                x: bassSwitch.checked ? parent.width - width - 4 : 4
                                y: 4
                                width: 24
                                height: 24
                                radius: 12
                                color: bassSwitch.checked ? "#000000" : "#7A7A7A"
                                Behavior on x { NumberAnimation { duration: 150 } }
                            }
                        }
                    }
                }
            }
        }
    }
}