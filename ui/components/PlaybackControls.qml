import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
    id: root
    spacing: 30

    // Các trạng thái để View cha (PlayerView) truyền vào
    property bool isPlaying: false
    property bool isShuffle: false
    property bool isRepeat: false

    // Khai báo các tín hiệu (signals) để báo cho C++ Backend hoặc View cha biết mà xử lý
    signal playPauseClicked()
    signal nextClicked()
    signal prevClicked()
    signal shuffleClicked()
    signal repeatClicked()

    // 1. Nút Shuffle (Ngẫu nhiên)
    Button {
        implicitWidth: 56
        implicitHeight: 56
        background: Rectangle {
            color: "transparent"
        }
        contentItem: Text {
            text: "🔀"
            // Bật thì trắng sáng, tắt thì xám chìm đi
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

    // 2. Nút Previous (Bài trước)
    Button {
        implicitWidth: 72
        implicitHeight: 72
        background: Rectangle {
            radius: 36
            // Bấm vào thì nháy nền xám đậm
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

    // 3. Nút Play / Pause (TRUNG TÂM - QUAN TRỌNG NHẤT)
    Button {
        implicitWidth: 96
        implicitHeight: 96
        background: Rectangle {
            radius: 48
            // Nền trắng chuẩn Vortex, bấm vào hơi ngả xám
            color: parent.pressed ? "#D0D0D0" : "#FFFFFF"
        }
        contentItem: Text {
            text: root.isPlaying ? "❚❚" : "▶"
            // Icon đen nổi bần bật trên nền trắng
            color: "#000000"
            font.pixelSize: 36
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        // Thêm scale nhẹ khi ấn cho nó có cảm giác vật lý (Haptic UI)
        scale: pressed ? 0.92 : 1.0
        Behavior on scale { NumberAnimation { duration: 100 } }

        onClicked: {
            root.playPauseClicked()
        }
    }

    // 4. Nút Next (Bài tiếp theo)
    Button {
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

    // 5. Nút Repeat (Lặp lại)
    Button {
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