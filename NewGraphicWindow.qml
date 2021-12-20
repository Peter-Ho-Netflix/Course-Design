import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import Yoimiya 2.12

Rectangle {
    id: newpagerec
    width: 400
    height: 400
    Material.theme: Material.Dark
    Material.accent: Material.Amber
    border.color: "#001013"
    color: "#001915"

    SpinBox {
        id: widthSelector
        x: 120
        y: 109
        width: 104
        height: 37
        editable: true
        to: 3840
        from: 1
    }

    SpinBox {
        id: heightSelector
        x: 296
        y: 109
        width: 104
        height: 37
        editable: true
        to: 2160
        from: 1
    }

    Label {
        id: label
        x: 60
        y: 122
        text: qsTr("宽")
    }

    Label {
        id: label1
        x: 245
        y: 120
        text: qsTr("高")
        anchors.verticalCenter: label.verticalCenter
        anchors.top: label.top
        anchors.bottom: label.bottom
        anchors.bottomMargin: -2
        anchors.topMargin: 2
    }

    RoundButton {
        id: closeButton
        x: 393
        width: 45
        height: 45
        text: "\u00d7"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 8
        anchors.topMargin: 8
        font.pointSize: 25
        onClicked:newpagerec.nGWClosed()
    }

    Yoimiya {
        id: colorSelector
        color: "#ffffff"
        onColorChanged: colorSelectorView.color=color
    }

    MouseArea {
        id: colorSelectorArea
        x: 142
        y: 178
        width: 36
        height: 35

        Rectangle {
            id: colorSelectorView
            color: "#ffffff"
            anchors.fill: parent
        }
        onClicked: colorSelector.colorSelectorDisplay()
    }

    Label {
        id: label2
        x: 60
        y: 187
        text: qsTr("背景色")
    }

    Button {
        id: createButton
        x: 156
        y: 323
        width: 135
        height: 48
        text: qsTr("开始绘画")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 29
        onClicked: {
            newpagerec.letsRock(widthSelector.value, heightSelector.value, colorSelectorView.color)
        }
    }

    signal nGWClosed()
    signal letsRock(int w, int h, color bagc)
}
