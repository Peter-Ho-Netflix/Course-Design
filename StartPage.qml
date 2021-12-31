import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import Kamisato_Ayaka 2.12

Rectangle {
    id: rectangle
    width: 449
    height: 350
    Material.theme: Material.Dark
    Material.accent: Material.Amber
    border.color: "#001013"
    color: "#001915"

    property var newObject

    Label {
        id: label
        x: 59
        y: 39
        color: "#ffffff"
        text: qsTr("欢迎！")
    }

    Button {
        id: newButton
        x: 96
        y: 115
        width: 94
        height: 37
        text: qsTr("新建")
        onClicked: {
            newGraphicWindowLoader.source="NewGraphicWindow.qml"
            newGraphicWindowLoader.item.nGWClosed.connect(loaderDestroy)
            newGraphicWindowLoader.item.letsRock.connect(newGraphicEmited)
        }
    }

    Button {
        id: openButton
        x: 96
        y: 170
        width: 94
        height: 37
        text: qsTr("打开")
        onClicked: filemanager.openFileButtonClicked()
    }

    RoundButton {
        id: closeButton
        x: 393
        width: 45
        height: 45
        text: "\u00d7"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.rightMargin: 8
        font.pointSize: 25
        onClicked: rectangle.closeButtonClicked();
    }

    Label {
        id: label1
        x: 81
        y: 235
        width: 36
        height: 18
        text: qsTr("©Peter Ho保留所有权利")
    }

    Label {
        id: label2
        y: 316
        width: 36
        height: 18
        text: qsTr("版本 1.1.0")
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        anchors.leftMargin: 23
    }

    Kamisato_Ayaka {
        id: filemanager
        onJSONStrChanged: {
            window.jsonGraphics=JSON.parse(jSONStr)
            window.jsonDir=jSONDir
        }
        onReadFinished: {
            rectangle.closeButtonClicked()
        }
    }

    Loader {
        id: newGraphicWindowLoader
        anchors.fill: parent
        anchors.rightMargin: 8
        anchors.leftMargin: 8
        anchors.bottomMargin: 8
        anchors.topMargin: 8
    }



    function loaderDestroy() {
        if(newGraphicWindowLoader.item)
        {
            newGraphicWindowLoader.item.nGWClosed.disconnect(loaderDestroy)
            newGraphicWindowLoader.item.letsRock.disconnect(newGraphicEmited)
            newGraphicWindowLoader.source=""
        }
    }

    function newGraphicEmited(w, h, bagc) {
        rectangle.newGraphics(w, h, bagc)
        loaderDestroy()
        rectangle.closeButtonClicked()
    }

    property string testJsonStr: "姜楠";
    signal closeButtonClicked()
    signal newGraphics(real w, real h, color bagc)
    signal openGraphics(string File)
}
