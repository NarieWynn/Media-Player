import QtQuick
import QtQuick.Controls

Slider {
    id: control

    // Tăng kích thước bao ngoài (hit-box) để ngón tay dễ chạm trúng khi xe rung lắc
    implicitWidth: 250
    implicitHeight: 48

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 250
        implicitHeight: 8 // Track dày 8px để nhìn rõ độ sâu
        width: control.availableWidth
        height: implicitHeight
        radius: 4
        color: "#2A2A2A" // Xám tối, tệp vào nền đen nhưng vẫn đủ tách biệt

        // Phần track đã chạy qua (Fill)
        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: "#FFFFFF" // Trắng tinh khiết chuẩn Vortex
            radius: 4
        }
    }

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2

        // Cục Handle bự 32x32, dễ túm kéo
        implicitWidth: 32
        implicitHeight: 32
        radius: 16
        antialiasing: true // Chống răng cưa cho viền bo tròn sắc nét hơn

        // Nhấn vào thì hơi ngả xám để có Haptic/Visual feedback
        color: control.pressed ? "#D0D0D0" : "#FFFFFF"

        // Viền đen để tạo cảm giác nổi khối nhẹ trên nền track trắng
        border.color: "#000000"
        border.width: 2

        // Hiệu ứng scale nhẹ khi bấm vào
        scale: control.pressed ? 0.9 : 1.0
        Behavior on scale {
            NumberAnimation { duration: 100 }
        }
    }
}