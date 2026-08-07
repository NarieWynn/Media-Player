import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    width: 100
    color: "#0A0A0C" // Nền đen hun hút

    // Viền phải mờ mờ tạo cảm giác phân cách không gian với màn hình chính
    Rectangle {
        width: 1
        height: parent.height
        anchors.right: parent.right
        color: "#2A2A2A"
    }

    // Biến lưu trạng thái tab đang chọn (0: Player, 1: Library, 2: Settings)
    property int currentIndex: 0
    signal tabClicked(int index)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        anchors.topMargin: 30
        anchors.bottomMargin: 30
        spacing: 40

        // Logo app / Nút Home (Trắng bóc, icon đen)
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

                Text {
                    anchors.centerIn: parent
                    text: "V" // Chữ V (Vortex)
                    color: "#000000"
                    font.pixelSize: 24
                    font.bold: true
                }
            }
        }

        Item { Layout.fillHeight: true } // Spacer đẩy menu ra giữa

        // Vòng lặp tạo 3 nút điều hướng
        Repeater {
            model: [
                { icon: "♫", label: "Player" },
                { icon: "☰", label: "Library" },
                { icon: "⚙", label: "Settings" }
            ]

            delegate: Rectangle {
                // Tối ưu chuẩn Qt6: Khai báo tường minh index và modelData
                required property int index
                required property var modelData

                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 70
                Layout.preferredHeight: 70
                radius: 16

                // Trạng thái: Đang chọn thì xám nhạt, bình thường trong suốt, bấm vào xám đậm
                color: root.currentIndex === index ? "#202020" : (mouseArea.pressed ? "#151515" : "transparent")

                // Indicator line: Vạch chỉ thị bên trái cho tab đang chọn
                Rectangle {
                    width: 4
                    height: 30
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 2
                    color: "#FFFFFF"
                    visible: root.currentIndex === index
                }

                // Icon của tab
                Text {
                    anchors.centerIn: parent
                    text: modelData.icon
                    // Đang ở tab nào thì icon trắng sáng, tab khác bị làm mờ (xám)
                    color: root.currentIndex === index ? "#FFFFFF" : "#5A5A5A"
                    font.pixelSize: 32
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: {
                        root.currentIndex = parent.index // Trỏ đúng vào index của delegate
                        root.tabClicked(parent.index)
                    }
                }

                // Hiệu ứng scale vật lý khi ấn
                scale: mouseArea.pressed ? 0.9 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }
            }
        }

        Item { Layout.fillHeight: true } // Spacer đẩy phần còn lại xuống đáy
    }
}