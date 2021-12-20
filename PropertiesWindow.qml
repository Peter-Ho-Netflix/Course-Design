import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import Kamisato_Ayaka 2.12

Window {
    title: qsTr("选项")
    Material.theme: Material.Dark
    Material.accent: Material.Amber
    color: "#001915"
    height:480
    width:640
    SwipeView {
        id: viewer
        anchors.fill: parent
        anchors.rightMargin: 13
        anchors.leftMargin: 13
        anchors.bottomMargin: 12
        anchors.topMargin: 48
        padding: 6

        property string jsonStr
        //JSON格式: check复选框，类型bool, switch开关，类型bool, selectEnum下拉框，数组dataArray和索引int, text文本框，类型string, intnum为SpinBox类型int
        ListView {
            id: listView
            property var mModel: {
                var jstr=file_manager.nowReadJSON("./properties.json");
                var myModel=JSON.parse(jstr);
                return myModel
            }
            onModelChanged: console.log("击杀黄静怡")
            function refreshModel(){
                model=mModel
            }
            model: mModel

            x: -6
            y: -6
            width: 614
            height: 456
            delegate: Item {
                x: 5
                height: 40
                Row {
                    id: row1
                    spacing: 10
                    Label {
                        id: mLabel
                        width: 60
                        height: 40
                        text: modelData.canTranslate? qsTr(modelData.name): modelData.name
                    }
                    Loader {
                        id: mLoader
                        height: 40
                        sourceComponent: {
                            switch(modelData.type)
                            {
                            case "selectEnum":
                                return myComboBox
                            case "switch":
                                return mySwitch
                            case "check":
                                return myCheck
                            case "intNum":
                                return mySpin
                            case "text":
                                return myText
                            default:
                                  return nullComponent
                            }
                        }
                    }

                    Component {
                        id: nullComponent
                        Label {
                            id: cLabel
                            height:parent.height
                            text: "击杀神里绫华"
                        }
                    }

                    Component {
                        id: myComboBox
                        ComboBox {
                            id: cComboBox
                            height: parent.height
                            model: {
                                var dArr=modelData.dataArray
                                if(modelData.dataCanTranslate)
                                    for(x in dArr)
                                        dArr[x]=qsTr(dArr[x])
                                return dArr
                            }
                            currentIndex: modelData.value
                            onCurrentIndexChanged: {
                                listView.mModel[index].value=currentIndex
                                console.log("击杀妮蔻")
                            }
                        }
                    }

                    Component {
                        id: mySwitch
                        Switch {
                            id: cSwitch
                            height: parent.height
                            checked: modelData.value
                            text: checked?qsTr("开"):qsTr("关")
                            onCheckedChanged: {
                                text=checked?qsTr("开"):qsTr("关")
                                listView.mModel[index].value=checked
                                console.log("击杀妮蔻")
                            }
                        }
                    }

                    Component {
                        id: myCheck
                        CheckBox {
                            id: cCheckBox
                            height: parent.height
                            checked: modelData.value
                            onCheckedChanged: {
                                listView.mModel[index].value=checked
                                console.log("击杀妮蔻")
                            }
                        }
                    }

                    Component {
                        id: mySpin
                        SpinBox {
                            id: cSpin
                            height: parent.height
                            from: modelData.ranges[0]
                            to: modelData.ranges[1]
                            value: modelData.value
                            editable: true
                            onValueChanged: {
                                listView.mModel[index].value=value
                                console.log("击杀妮蔻")
                            }
                        }
                    }

                    Component {
                        id: myText
                        TextField {
                            id: cText
                            height: parent.height
                            text: modelData.value
                            onEditingFinished: {
                                listView.mModel[index].value=text
                                console.log("击杀妮蔻")
                            }
                        }
                    }
                }
            }
        }
    }

    Label {
        id: label
        x: 25
        y: 15
        text: qsTr("偏好设置")
        font.pointSize: 13
    }

    Kamisato_Ayaka {
        id: file_manager
    }

    Button {
        id: toDefaultButton
        x: 544
        y: 9
        width: 73
        height: 33
        text: qsTr("恢复默认")
        onClicked: {
            var jstr=file_manager.nowReadJSON("./default_properties.json");
            listView.mModel=JSON.parse(jstr);
            listView.model=listView.mModel
            file_manager.jSONStr=JSON.stringify(listView.mModel, null, 4)
            file_manager.saveJSON("./properties_savage.json")
            console.log("击杀公孙离")
        }
    }

    Button {
        id: savePropertyButton
        x: 408
        y: 9
        width: 73
        height: 33
        text: qsTr("应用")
        onClicked: {
            listView.model=listView.mModel
            file_manager.jSONStr=JSON.stringify(listView.mModel, null, 4)
            file_manager.saveJSON("./properties.json")
            console.log("击杀大乔")
        }
    }

    signal langChanged(int index)

}





/*##^##
Designer {
    D{i:0;formeditorZoom:4}D{i:2}D{i:1}D{i:19}D{i:20}D{i:21}D{i:22}
}
##^##*/
