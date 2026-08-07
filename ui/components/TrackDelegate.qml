import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    // Width tự động bám theo chiều rộng của ListView chứa nó
    width: ListView.view ? ListView.view.width : 400
    height: 84 // Chiều cao to chà bá theo chuẩn HMI

    // Các thuộc tính nhận từ Model (C++ hoặc ListModel)
    property string title: "Unknown Title"
    property string artist: "Unknown Artist"
    property string duration: "0:00"
    property bool isActive: false // True nếu bài này đang được phát

    // Phát tín hiệu khi tài xế chọt vào bài này
    signal clicked()

    Rectangle {
        id: bgRect
        anchors.fill: parent
        anchors.margins: 4 // Cách nhau một tí cho có không gian thở
        radius: 12

        // Màu nền: Đang phát thì xám đậm (#1A1A1A), bấm vào thì sáng hơn, bình thường thì trong suốt
        color: mouseArea.pressed ? "#2A2A2A" : (root.isActive ? "#1A1A1A" : "transparent")

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 15

            // 1. Vạch chỉ thị bài đang phát (Indicator)
            Rectangle {
                width: 4
                height: parent.height - 20
                radius: 2
                color: root.isActive ? "#FFFFFF" : "transparent"
            }

            // 2. Hình cover thu nhỏ (hoặc Icon mặc định)
            Rectangle {
                Layout.preferredWidth: 60
                Layout.preferredHeight: 60
                radius: 8
                color: "#252525"

                Text {
                    anchors.centerIn: parent
                    text: root.isActive ? "▶" : "♫" // Nếu đang phát đổi icon
                    color: root.isActive ? "#FFFFFF" : "#5A5A5A"
                    font.pixelSize: 24
                }
            }

            // 3. Thông tin bài hát (Title & Artist)
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: root.title
                    color: root.isActive ? "#FFFFFF" : "#D0D0D0"
                    font.pixelSize: 22
                    font.bold: root.isActive // Đang phát thì in đậm lên
                    elide: Text.ElideRight // Nếu dài quá thì hiện "..."
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

            // 4. Thời lượng bài hát (Nằm tít bên phải)
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

        // Hiệu ứng scale nhún nhẹ khi chạm
        scale: mouseArea.pressed ? 0.98 : 1.0
        Behavior on scale { NumberAnimation { duration: 100 } }
    }
}