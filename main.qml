import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import Kamisato_Ayaka 2.12
import Yoimiya 2.12
import Raiden_Shogun 2.15

Window {
    id: window
    width: 640
    height: 524
    visible: true
    color: "#001915"

    property alias toolBarWidth: toolBar.width
    property string jsonDir
    property var defaultJSONGraphics: {"name": "神里绫华", "type": "canvas", "width": 420, "height": 340, "color": "#FFFFFF", "subnodes": []}
    property var jsonGraphics: {
        if(Application.arguments.length>1)
        {
            file_manager.readJSON(Application.arguments[Application.arguments.length-1])
            return JSON.parse(file_manager.jSONStr)
        }
        else
            return defaultJSONGraphics
    }

    title: qsTr("神里绫华")
    Material.theme: Material.Dark
    Material.accent: Material.Amber
    property string mouseMode: ""
    property string propertiesJson
    property variant recentOptionRecord //历史记录JSON数据
    //格式：[]
    property variant fillStyleDef: color_rect.color
    property variant strokeStyleDef: color_rect.border.color
    property var currentItemArray: [] //当前item的选中指令


    PropertiesWindow {
        id: pWindow
    }

    Pane {
        id: layerpane
        x: 474
        y: 245
        width: 143
        height: 215
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        padding: 8
        anchors.bottomMargin: 65
        anchors.rightMargin: 23

        MouseArea {
            id: mArea
            anchors.fill: parent
            anchors.margins: -8
            onClicked: treeview.currentItem=-1
        }
        TreeView{
            id: treeview
            anchors.right: parent.right
            anchors.rightMargin: 0
            model: jsonGraphics.subnodes
            anchors{
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            //当选项变更时，击杀妮蔻，并击杀瑶
            onCurrentItemChanged: {
                currentItemArray=[]
                mona=-1
                var 神里绫华=getCheckArray(currentItem, [], model)
                if(神里绫华!==undefined)
                    currentItemArray.push(神里绫华)
                console.log(神里绫华)
            }
            property int mona: -1
            function getCheckArray(x, xArr, mod, depth=0)
            {
                if(mona===x)
                    return xArr
                else
                {
                    var md
                    for(md in mod)
                    {
                        xArr[depth]=md
                        if(mod[md].hasOwnProperty("subnodes"))
                        {
                            var xResult=getCheckArray(x, xArr, mod[md].subnodes, depth+1)
                            if(xResult!==undefined)
                                return xResult
                        }
                        ++mona
                        if(mona===x)
                            return xArr.splice(0, depth+1)
                        console.log("mona", mona)
                    }
                }
            }
        }
    }

    Pane {
        id: propertypane
        x: 474
        width: 143
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 65
        anchors.bottomMargin: 297
        anchors.rightMargin: 23
//显示图形属性
        ScrollView {
            id: scrollView
            x: 0
            width: 119
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: -6
            anchors.bottomMargin: 0
            anchors.rightMargin: 0
            property var rootModel: jsonGraphics

            Label {
                id: graphictype
                x: 0
                y: 0
                text: scrollView.rootModel.type
            }

            TextField {
                id: nametext
                x: 0
                y: 22
                width: 119
                height: 36
                placeholderText: qsTr("名称")
                text: scrollView.rootModel.name
                //文字变更时立即将名称变化反馈给图形，并根据信号进行其他动作
                onEditingFinished: console.log("神里绫华")
            }
            ListView {
                y: graphictype.height+nametext.height+3
                model: canvasModel
            }
            Component {
                id: coordinateComponent
                Column {
                    height: parent.height
                    id: coor_item
                    SpinBox {
                        id: coor_x
                    }
                    Label {
                        id: coor_l
                        text: ", "
                    }

                    SpinBox {
                        id: coor_y
                    }
                }
            }
            Component {
                id: coordlinateList
                Column {
                    id: coor_listColumn
                    ListView {
                        id: coor_listView
                    }
                    Row {
                        id: coor_listButton
                        Button {
                            id: coor_addButton
                            text: qsTr("添加")
                        }
                        Button {
                            id: coor_deleteButton
                            text: qsTr("删除")
                        }
                    }
                }
            }
            Component {
                id: myFillColor
                Row {
                    height: 20
                    Label {
                        height: 20
                        anchors.verticalCenter: parent.anchors.verticalCenter
                        text: qsTr("填充")
                    }

                    MouseArea {
                        id: fillColorSelect
                        width: height
                        height: 20
                        Rectangle {
                            id: fillColor_rect
                            anchors.fill: parent
                            color: scrollView.rootModel.color
                        }
                        onClicked: {
                            color_manager.colorSelectorDisplay()
                            scrollView.rootModel.color=color_manager.color
                        }
                    }
                }
            }
            Component {
                id: myBorderColor
                Row {
                    height: 20
                    Label {
                        height: 20
                        anchors.verticalCenter: parent.anchors.verticalCenter
                        text: qsTr("边线")
                    }
                MouseArea {
                    width: height
                    id: borderColorSelect
                    Rectangle {
                        id: borderColor_rect
                        anchors.fill: parent
                        color: scrollView.rootModel.strokeColor
                    }
                }
                }
            }
            Component {
                id: intNum
                SpinBox {
                    id: intNum_box
                }
            }
            ObjectModel {
                id: canvasModel
                Loader {
                        sourceComponent: myFillColor
                }
            }
            ObjectModel {
                id: lineModel
                Loader {
                    sourceComponent: myBorderColor
                }
            }
        }
    }

    Pane {
        id: drawarea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        clip: true
        padding: 0
        anchors.rightMargin: 188
        anchors.bottomMargin: 65
        anchors.topMargin: 65
        anchors.leftMargin: 23
        Drag.active: drawarea_motion.drag.active
        //画图对象
        MouseArea {
            id: drawarea_motion
            width: jsonGraphics.width
            height: jsonGraphics.height
            Canvas {
                id: drawarea_canvas
                anchors.fill: parent
                property var ctx
                property var graModel: jsonGraphics.subnodes
                property string drawrequest: ""
                property var graBuffer: ({}) //图形缓存
                property bool drawMode: false
                onPaint: {
                    ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    ctx.fillStyle=jsonGraphics.color
                    ctx.fillRect(0, 0, width, height)
                    //加载model中的图形，注意只加载非canvas的叶子图形，按照图层从上往下加载，即图层下方的图形显示在最上层
                    var md
                    for(md in graModel)
                    {
                        if(graModel[md].visible)
                        {
                            console.log("位于", md, "点")
                            drawModel(graModel[md])
                        }
                    }

                    console.log("击杀烟绯")
                    //加载当前正在绘制的图形
                    console.log(drawrequest, " in canvas")
                    switch(drawrequest)
                    {
                    case "line":
                        drawLine(graBuffer.x1, graBuffer.y1, graBuffer.x2, graBuffer.y2)
                        console.log("绘制直线")
                        break
                    case "ellipse":
                        drawEllipse(graBuffer.x1, graBuffer.y1, graBuffer.x2, graBuffer.y2)
                        console.log("绘制椭圆")
                        break
                    case "polygon":
                        drawPolygonwhileDrawing()
                        break
                    case "curve":
                        drawCurve(graBuffer.x1, graBuffer.y1, graBuffer.x2, graBuffer.y2, graBuffer.x3, graBuffer.y3, graBuffer.x4, graBuffer.y4)
                        break
                    }
                    //TODO: 选中图形绘制
                    var it
                    for(it in currentItemArray)
                    {

                    }
                }
                //用递归方法，绘制图形，并击杀神里绫华，注意，此方法极其容易击杀妮蔻
                function drawModel(myModel)
                {
                    console.log("击杀神里绫华")
                    ctx.lineWidth=2
                    ctx.beginPath()
                    ctx.strokeStyle=myModel.strokeColor
                    switch(myModel.type)
                    {
                    case "line":
                        ctx.fillStyle="transparent"
                        ctx.moveTo(myModel.x1, myModel.y1)
                        ctx.lineTo(myModel.x2, myModel.y2)
                        console.log("直线模板画线", myModel.x1, myModel.y1, myModel.x2, myModel.y2, ctx.strokeStyle)
                        break
                    case "ellipse":
                        ctx.fillStyle=myModel.color
                        ctx.ellipse(myModel.x1, myModel.y1, myModel.x2-myModel.x1, myModel.y2-myModel.y1, 0, 0, Math.PI*2)
                        console.log("椭圆模板画线")
                        ctx.fill()
                        ctx.stroke()
                        break
                    case "polygon":
                        ctx.fillStyle=myModel.color
                        drawPolygon(myModel)
                        console.log("多边形模板画线")
                        break
                    case "curve":
                        ctx.fillStyle="transparent"
                        ctx.moveTo(myModel.x1, myModel.y1)
                        ctx.bezierCurveTo(myModel.x2, myModel.y2, myModel.x3, myModel.y3, myModel.x4, myModel.y4)
                        console.log("曲线绘制模板", myModel.x1, myModel.y1, myModel.x2, myModel.y2, myModel.x3, myModel.y3, myModel.x4, myModel.y4)
                        break
                    case "group":
                        var ig
                        for(ig in myModel.subnodes)
                            drawModel(myModel.subnodes[ig])
                    }
                    ctx.fill()
                    ctx.stroke()
                    ctx.closePath()
                }

                function drawLine(x1, y1, x2, y2)
                {
                    ctx.beginPath()
                    ctx.lineWidth=2
                    ctx.strokeStyle=strokeStyleDef
                    ctx.moveTo(x1, y1)
                    ctx.lineTo(x2, y2)
                    ctx.stroke()
                    ctx.closePath()
                }
                function drawLinebyCoor(c1, c2)
                {
                    drawLine(c1[0], c1[1], c2[0], c2[1])
                }

                function drawEllipse(x1, y1, x2, y2)
                {
                    ctx.beginPath()
                    ctx.lineWidth=2
                    ctx.strokeStyle=strokeStyleDef
                    ctx.fillStyle=fillStyleDef
                    ctx.ellipse(x1, y1, x2-x1, y2-y1, 0, 0, Math.PI*2)
                    ctx.fill()
                    ctx.stroke()
                    ctx.closePath()
                }
                function beginPolygon(x, y)
                {
                    drawMode=true
                    graBuffer.nodes=[[x, y]]
                }
                function nextPolygon(x, y)
                {
                    graBuffer.nodes.push([x, y])
                }
                function drawCurve(x1, y1, x2, y2, x3, y3, x4, y4)
                {
                    ctx.beginPath()
                    ctx.lineWidth=2
                    ctx.strokeStyle=strokeStyleDef
                    ctx.moveTo(x1, y1)
                    ctx.bezierCurveTo(x2, y2, x3, y3, x4, y4)
                    ctx.stroke()
                    ctx.closePath()
                }
                function completeGraphics()
                {
                    graBuffer.name="神里绫华"
                    graBuffer.type=drawrequest
                    console.log("插入", graBuffer.type)
                    graBuffer.color=fillStyleDef.toString()
                    graBuffer.strokeColor=strokeStyleDef.toString()
                    graBuffer.visible=true
                    jsonGraphics.subnodes.push(graBuffer)
                    console.log(graModel)
                    graBuffer={}
                    jsonGraphicsChanged()
                }


                function completePolygon()
                {
                    drawMode=false
                    console.log("击杀上官婉儿")
                    completeGraphics()
                }
                function drawPolygon(graphicModel)
                {
                    console.log("绘制多边形", graphicModel.nodes)
                    var mr
                    ctx.strokeStyle=graphicModel.strokeColor
                    ctx.moveTo(graphicModel.nodes[0][0], graphicModel.nodes[0][1])
                    for(mr=0;mr<graphicModel.nodes.length-1;mr++)
                    {
                        ctx.lineTo(graphicModel.nodes[mr+1][0], graphicModel.nodes[mr+1][1])
                        console.log("绘制直线", graphicModel.nodes[mr], graphicModel.nodes[mr+1])
                    }
                    ctx.lineTo(graphicModel.nodes[0][0], graphicModel.nodes[0][1])
                }

                function drawPolygonwhileDrawing()
                {
                    console.log("绘制多边形", graBuffer.nodes, drawMode?"未完成":"已完成")
                    var mr
                    ctx.lineWidth=2
                    ctx.beginPath()
                    ctx.strokeStyle=strokeStyleDef
                    ctx.moveTo(graBuffer.nodes[0][0], graBuffer.nodes[0][1])
                    for(mr=0;mr<graBuffer.nodes.length-1;mr++)
                    {
                        ctx.lineTo(graBuffer.nodes[mr+1][0], graBuffer.nodes[mr+1][1])
                        console.log("绘制直线", graBuffer.nodes[mr], graBuffer.nodes[mr+1])
                    }
                    if(!drawMode)
                    {
                        //ctx.moveTo(graBuffer.nodes[graBuffer.nodes.length-1][0], graBuffer.nodes[graBuffer.nodes.length-1][1])
                        ctx.lineTo(graBuffer.nodes[0][0], graBuffer.nodes[0][1])
                        ctx.fillStyle=fillStyleDef
                        ctx.closePath()
                        ctx.stroke()
                        ctx.fill()
                    }
                    else
                        ctx.stroke()
                }
                //加载选中特效
//                Loader {
//                    id: selectLoader
//                }

//                Component {
//                    id: recSelect
//                    Item {
//                        anchors.fill: parent

//                    }
//                }
//                Component {
//                    id: recRotate
//                    Item {
//                        anchors.fill: parent
//                        Rectangle {
//                            id: centerPoint
//                            height: 5
//                            width: 5
//                            color: "white"
//                            border.color: "black"

//                        }
//                    }
//                }
                //定义基准点，后续版本可能根据选中特效自定义基准点
            }
            property int basePointX: basePoint.x
            property int basePointY: basePoint.y
            MouseArea {
                id: basePoint
                x: drawarea_motion.width/2
                y: drawarea_motion.height/2
                height: 5
                width: height
                visible: mouseMode=="rotate"||mouseMode=="scale"
                drag.target: this
                Rectangle {
                    id: basePoint_rect
                    anchors.fill: parent
                    color: "white"
                    border.color: "black"
                    border.width: 1
                }
            }

            property int myX
            property int myY
            property bool isMouseMoveEnable: false
            onPressed: {
                myX=mouseX
                myY=mouseY
                drawarea_canvas.drawrequest=mouseMode
                isMouseMoveEnable=true
                console.log("击杀妮蔻")
                colorPane.visible=false
                console.log("mouseMode: ", mouseMode)
                if(mouseMode==="polygon")
                {
                    if(drawarea_canvas.drawMode)
                        drawarea_canvas.nextPolygon(mouseX, mouseY)
                    else
                        drawarea_canvas.beginPolygon(mouseX, mouseY)
                    console.log("击杀胡桃")
                    drawarea_canvas.requestPaint()
                }
                if(mouseMode==="translate"||mouseMode==="scale"||mouseMode==="rotate")
                {
                    var mChangeModel=jsonGraphics
                    for(var m in currentItemArray)
                    {
                        mChangeModel=mChangeModel.subnodes[currentItemArray[m]]
                    }
                    图形变换缓存=JSON.parse(JSON.stringify(mChangeModel))
                    if(mouseMode=="rotate"||mouseMode=="scale")
                    {
                        moveGraphicsXY(图形变换缓存, -basePointX, -basePointY, 图形变换缓存)
                    }
                }
            }
            onPositionChanged: {
                if(isMouseMoveEnable){
                    if(mouseMode=="line"||mouseMode=="ellipse"||(mouseMode=="curve"&&!drawarea_canvas.drawMode))
                    {
                        drawarea_canvas.graBuffer.x1=myX
                        drawarea_canvas.graBuffer.x2=mouseX
                        drawarea_canvas.graBuffer.y1=myY
                        drawarea_canvas.graBuffer.y2=mouseY
                    }
                    else if(mouseMode=="curve")
                    {
                        drawarea_canvas.graBuffer.x4=myX
                        drawarea_canvas.graBuffer.x3=mouseX
                        drawarea_canvas.graBuffer.y4=myY
                        drawarea_canvas.graBuffer.y3=mouseY
                    }
                    else if(mouseMode=="translate"||mouseMode=="scale"||mouseMode==="rotate")
                    {
                        //利用对象引用更改模型，从而实现model的编辑
                        var mChangeModel=jsonGraphics
                        for(var m in currentItemArray)
                        {
                            mChangeModel=mChangeModel.subnodes[currentItemArray[m]]
                        }

                        if(mouseMode=="translate")
                            moveGraphics(mChangeModel)
                        else if(mouseMode=="scale")
                            scaleGraphics(mChangeModel)
                    }

                    drawarea_canvas.requestPaint()
                    console.log("击杀公孙离")
                    if(mouseMode==="polygon")
                    {
                        if(drawarea_canvas.drawMode)
                            drawarea_canvas.nextPolygon(mouseX, mouseY)
                        else
                            drawarea_canvas.beginPolygon(mouseX, mouseY)
                        console.log("击杀胡桃")
                        drawarea_canvas.requestPaint()
                    }
                }
            }
            onReleased: {
                isMouseMoveEnable=false
                console.log("击杀悠米")
                console.log(mouseMode)
                infoLabel.text=""
                if(mouseMode=="line" || mouseMode=="ellipse"||(mouseMode=="curve"&&drawarea_canvas.drawMode))
                {
                    drawarea_canvas.completeGraphics()
                    drawarea_canvas.drawMode=false
                }
                else if(mouseMode=="curve")
                    drawarea_canvas.drawMode=true
            }
            onDoubleClicked: {
                if(mouseMode=="polygon")
                {
                    drawarea_canvas.graBuffer.nodes.pop()
                    drawarea_canvas.completePolygon()
                    drawarea_canvas.requestPaint()
                }
            }
            function moveGraphics(mChangeModel)
            {
                moveGraphicsXY(mChangeModel, mouseX-myX, mouseY-myY)
                infoLabel.text="平移"+mouseX-myX+", "+mouseY-myY
            }
            property var 图形变换缓存
            function moveGraphicsXY(mChangeModel, mx, my, 图形缓存=图形变换缓存)
            {
                if(mChangeModel.type==="line"||mChangeModel.type==="ellipse"||mChangeModel.type==="curve")
                {
                    mChangeModel.x1=图形缓存.x1+(mx)
                    mChangeModel.x2=图形缓存.x2+(mx)
                    mChangeModel.y1=图形缓存.y1+(my)
                    mChangeModel.y2=图形缓存.y2+(my)
                    if(mChangeModel.type==="curve")
                    {
                        mChangeModel.x3=图形缓存.x3+(mx)
                        mChangeModel.x4=图形缓存.x4+(mx)
                        mChangeModel.y3=图形缓存.y3+(my)
                        mChangeModel.y4=图形缓存.y4+(my)
                    }
                }
                else if(mChangeModel.type==="polygon")
                {
                    var 顶点数组=mChangeModel.nodes
                    var 缓存顶点数组=图形缓存.nodes
                    for(var nd in 顶点数组)
                    {
                        顶点数组[nd][0]=缓存顶点数组[nd][0]+(mx)
                        顶点数组[nd][1]=缓存顶点数组[nd][1]+(my)
                    }
                }
                else if(mChangeModel.type==="group")
                    for(var sub in mChangeModel.subnodes)
                        moveGraphicsXY(mChangeModel.subnodes[sub], mx, my, 图形缓存.subnodes[sub])
            }

            function rotateGraphics(mChangeModel)
            {

                infoLabel.text="旋转"
            }
            function rotateGraphicsXY(mChangeModel, arg, 图形缓存=图形变换缓存)
            {

            }

            function scaleGraphics(mChangeModel)
            {
                var originalX=myX-basePointX
                var originalY=myY-basePointY
                var nowX=mouseX-basePointX
                var nowY=mouseY-basePointY
                if(originalX!=0&&originalY!=0)
                {
                    scaleGraphicsXY(mChangeModel, nowX/originalX, nowY/originalY)
                    infoLabel.text="缩放"+nowX/originalX+", "+nowY/originalY
                }
                else
                    infoLabel.text="缩放不可"+ originalX===0? "x=0": "y=0"
            }
            function scaleGraphicsXY(mChangeModel, mx, my, 图形缓存=图形变换缓存)
            {
                if(mChangeModel.type==="line"||mChangeModel.type==="ellipse"||mChangeModel.type==="curve")
                {
                    mChangeModel.x1=图形缓存.x1*mx
                    mChangeModel.x2=图形缓存.x2*mx
                    mChangeModel.y1=图形缓存.y1*my
                    mChangeModel.y2=图形缓存.y2*my
                    if(mChangeModel.type==="curve")
                    {
                        mChangeModel.x3=图形缓存.x3*(mx)
                        mChangeModel.x4=图形缓存.x4*(mx)
                        mChangeModel.y3=图形缓存.y3*(my)
                        mChangeModel.y4=图形缓存.y4*(my)
                    }
                }
                else if(mChangeModel.type==="polygon")
                {
                    var 顶点数组=mChangeModel.nodes
                    var 缓存顶点数组=图形缓存.nodes
                    for(var nd in 顶点数组)
                    {
                        顶点数组[nd][0]=缓存顶点数组[nd][0]*(mx)
                        顶点数组[nd][1]=缓存顶点数组[nd][1]*(my)
                    }
                }
                else if(mChangeModel.type==="group")
                    for(var sub in mChangeModel.subnodes)
                        scaleGraphicsXY(mChangeModel.subnodes[sub], mx, my, 图形缓存.subnodes[sub])
                moveGraphicsXY(mChangeModel, basePointX, basePointY, mChangeModel)
            }

            //借助以下操作，可实现画布拖拽
            //drag.target: parent
        }
    }

    ToolBar {
        id: toolBar
        y: 21
        width: window.width-46
        height: 27
        anchors.horizontalCenter: parent.horizontalCenter

        ToolButton {
            id: filebutton
            x: 554
            y: 0
            width: 40
            height: 27
            text: qsTr("探索")
            anchors.right: parent.right
            anchors.rightMargin: 0
            onClicked: stp.visible=true
        }

        ToolButton {
            id: backwardbutton
            x: 0
            y: 0
            width: 28
            height: 28
            IconImage {
                anchors.fill: parent
                anchors.margins: 4
                source: "img/revoke.svg"
            }
        }

        ToolButton {
            id: forwardbutton
            x: 28
            y: 0
            width: 28
            height: 28
            IconImage {
                anchors.fill: parent
                anchors.margins: 4
                source: "img/revoke.svg"
                rotation: -180
            }
        }

        ToolButton {
            id: lineButton
            x: 61
            y: 0
            width: 28
            height: 28
            //text: qsTr("直线")
            IconImage {
                anchors.margins: 4
                anchors.fill: parent
                source: lineButton.checked? "img/line_selected.svg": "img/line.svg"
            }
            onClicked: {
                if(!checked){
                    checked=true
                    ellipseButton.checked=false
                    polygonButton.checked=false
                    curveButton.checked=false
                    selectButton.checked=false
                    rotateButton.checked=false
                    viewEditButton.checked=false
                    cutButton.checked=false
                    scaleButton.checked=false
                    mouseMode="line"
                }
            }
        }

        ToolButton {
            id: ellipseButton
            x: 89
            y: 0
            width: 28
            height: 28
            //text: qsTr("椭圆")
            IconImage {
                anchors.margins: 4
                anchors.fill: parent
                source: ellipseButton.checked? "img/ellipse_selected.svg": "img/ellipse.svg"
            }
            onClicked: {
                if(!checked){
                    checked=true
                    lineButton.checked=false
                    polygonButton.checked=false
                    curveButton.checked=false
                    selectButton.checked=false
                    rotateButton.checked=false
                    viewEditButton.checked=false
                    cutButton.checked=false
                    scaleButton.checked=false
                    mouseMode="ellipse"
                }
            }
        }

        ToolButton {
            id: polygonButton
            x: 117
            y: 0
            width: 28
            height: 28
            //text: qsTr("多边形")
            IconImage {
                anchors.margins: 4
                anchors.fill: parent
                source: polygonButton.checked? "img/polygon_selected.svg": "img/polygon.svg"
            }
            onClicked: {
                if(!checked){
                    checked=true
                    lineButton.checked=false
                    ellipseButton.checked=false
                    curveButton.checked=false
                    selectButton.checked=false
                    rotateButton.checked=false
                    viewEditButton.checked=false
                    cutButton.checked=false
                    scaleButton.checked=false
                    mouseMode="polygon"
                }
            }
        }

        ToolButton {
            id: curveButton
            x: 145
            y: 0
            width: 28
            height: 28
            //text: qsTr("曲线")
            IconImage {
                anchors.margins: 4
                anchors.fill: parent
                source: curveButton.checked? "img/curve_selected.svg": "img/curve.svg"
            }
            onClicked: {
                if(!checked){
                    checked=true
                    lineButton.checked=false
                    ellipseButton.checked=false
                    polygonButton.checked=false
                    selectButton.checked=false
                    rotateButton.checked=false
                    viewEditButton.checked=false
                    cutButton.checked=false
                    scaleButton.checked=false
                    mouseMode="curve"
                }
            }
        }
        //选中并移动和放缩
        ToolButton {
            id: selectButton
            x: 180
            y: 0
            width: 28
            height: 28
            //text: qsTr("选中")
            IconImage {
                anchors.margins: 4
                anchors.fill: parent
                source: selectButton.checked? "img/translate_selected.svg": "img/translate.svg"
            }
            onClicked: {
                if(!checked){
                    checked=true
                    lineButton.checked=false
                    ellipseButton.checked=false
                    polygonButton.checked=false
                    curveButton.checked=false
                    rotateButton.checked=false
                    viewEditButton.checked=false
                    cutButton.checked=false
                    scaleButton.checked=false
                    mouseMode="translate"
                }
            }
        }
        //选中并旋转
        ToolButton {
            id: rotateButton
            x: 208
            y: 0
            width: 28
            height: 28
            //text: qsTr("选中")
            IconImage {
                anchors.margins: 4
                anchors.fill: parent
                source: rotateButton.checked? "img/rotate_selected.svg": "img/rotate.svg"
            }
            onClicked: {
                if(!checked){
                    checked=true
                    lineButton.checked=false
                    ellipseButton.checked=false
                    polygonButton.checked=false
                    curveButton.checked=false
                    selectButton.checked=false
                    viewEditButton.checked=false
                    cutButton.checked=false
                    scaleButton.checked=false
                    mouseMode="rotate"
                }
            }
        }
        ToolButton {
            id: scaleButton
            x: 236
            y: 0
            width: 28
            height: 28
            //text: qsTr("选中")
            IconImage {
                anchors.margins: 4
                anchors.fill: parent
                source: scaleButton.checked? "img/scale_selected.svg": "img/scale.svg"
            }
            onClicked: {
                if(!checked){
                    checked=true
                    lineButton.checked=false
                    ellipseButton.checked=false
                    polygonButton.checked=false
                    curveButton.checked=false
                    selectButton.checked=false
                    viewEditButton.checked=false
                    cutButton.checked=false
                    rotateButton.checked=false
                    mouseMode="scale"
                }
            }
        }

        ToolButton {
            id: saveButton
            x: 500
            y: 0
            width: 48
            height: 27
            text: qsTr("保存")
            onClicked: saveCMD()
        }
        //裁剪按钮
        ToolButton {
            id: cutButton
            x: 264
            y: 0
            width: 28
            height: 28
            //text: qsTr("视图平移")
            IconImage {
                anchors.margins: 4
                anchors.fill: parent
                source: cutButton.checked? "img/cut_selected.svg": "img/cut.svg"
            }
            onClicked: {
                if(!checked){
                    checked=true
                    lineButton.checked=false
                    ellipseButton.checked=false
                    polygonButton.checked=false
                    curveButton.checked=false
                    selectButton.checked=false
                    rotateButton.checked=false
                    viewEditButton.checked=false
                    scaleButton.checked=false
                    mouseMode="cut"
                }
            }
        }
        //视图平移按钮
        ToolButton {
            id: viewEditButton
            x: 306
            y: 0
            width: 28
            height: 28
            //text: qsTr("视图平移")
            IconImage {
                anchors.margins: 4
                anchors.fill: parent
                source: viewEditButton.checked? "img/canvas_translate_selected.svg": "img/canvas_translate.svg"
            }
            onClicked: {
                if(!checked){
                    checked=true
                    lineButton.checked=false
                    ellipseButton.checked=false
                    polygonButton.checked=false
                    curveButton.checked=false
                    selectButton.checked=false
                    rotateButton.checked=false
                    cutButton.checked=false
                    scaleButton.checked=false
                    mouseMode="canvasTranslate"
                }
            }
        }
        //颜色定义按钮
        ToolButton {
            id: colorDefineButton
            x: 336
            y: 0
            width: 28
            height: 28
            Rectangle {
                id: color_rect
                color: "white"
                border.color: "black"
                border.width: 3
                anchors.margins: 4
                anchors.fill: parent
            }
            onClicked: colorPane.visible=!colorPane.visible
        }

        Pane {
            id: colorPane
            visible: false
            x: 264
            y: 30
            width:112
            height: 35
            padding: 0
            Row {
                anchors.fill: parent
                anchors.centerIn: parent
                Button {
                    anchors.verticalCenter: parent
                    width: 56
                    height: 35
                    id: fillColorButton
                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        x: 3
                        text: qsTr("填充")
                    }
                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        x: 30
                        color:color_rect.color
                        height: 20
                        width: height
                    }
                    //长按时，自动设置无颜色
                    onPressAndHold: {
                        color_rect.color="transparent"
                    }
                    onClicked: {
                        color_manager.colorSelectorDisplay()
                        color_rect.color=color_manager.color
                    }
                }
                Button {
                    anchors.verticalCenter: parent
                    width: 56
                    height: 35
                    id: strokeColorButton
                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        x: 3
                        text: qsTr("边线")
                    }
                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        x: 30
                        border.color: color_rect.border.color
                        color: "transparent"
                        border.width: 3
                        height: 20
                        width: height
                    }
                    onPressAndHold: {
                        color_rect.border.color="transparent"
                    }
                    onClicked: {
                        color_manager.colorSelectorDisplay()
                        color_rect.border.color=color_manager.color
                    }
                }
            }
        }

        ToolButton {
            id: exportButton
            x: 458
            y: 0
            width: 43
            height: 27
            text: qsTr("导出")
            onClicked: {
                var filestr=file_expoter.getFileName()
                console.log(filestr)
                if(filestr!=="")
                    console.log(drawarea_canvas.save(filestr))
            }
        }

        ToolButton {
            id: toolButton
            x: 422
            y: 0
            width: 36
            height: 27
            text: qsTr("选项")
            onClicked: {
                pWindow.show();
            }
        }
    }

    Pane {
        id: pane
        y: 479
        height: 25
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 23
        anchors.leftMargin: 23
        anchors.bottomMargin: 20

        Label {
            id: statusLabel
            x: 0
            y: -8
            text: mouseMode
        }

        Label {
            id: mouseAreaLabel
            x: 70
            y: -8
            text: drawarea_motion.mouseX+", "+drawarea_motion.mouseY
        }

        Label {
            id: infoLabel
            x: 127
            y: -8
            text: ""
        }

        Label {
            id: basicPointLabel
            x: 363
            y: -7
            visible: basePoint.visible
            text: qsTr("基准点")+basePoint.x+", "+basePoint.y
            anchors.right: parent.right
            anchors.rightMargin: 176
        }
    }

    StartPage {
        id: stp
        visible: false
        anchors.fill: parent
        onCloseButtonClicked: stp.visible=false
        onNewGraphics: {
            drawarea_motion.width=w
            drawarea_motion.height=h
            fillStyleDef=bagc
            console.log(bagc)
            jsonGraphics={"name": "神里绫华", "type": "canvas", "width": w, "height": h, "color": String(bagc), "subnodes": []}
            drawarea_canvas.requestPaint()
        }
    }

    onMouseModeChanged: {
        switch(mouseMode) {
        case "line":
            console.log("直线绘制模式")
            break
        case "ellipse":
            console.log("椭圆绘制模式")
            break
        case "polygon":
            console.log("多边形绘制模式")
            break
        case "curve":
            console.log("曲线绘制模式")
            break
        case "translate":
            console.log("选择和平移缩放模式")
            break
        case "rotate":
            console.log("旋转模式")
            break
        case "scale":
            console.log("缩放模式")
            break
        case "cut":
            console.log("裁剪模式")
            break
        }
        drawarea_motion.drag.target=mouseMode=="canvasTranslate"?drawarea_motion.parent:null
    }

//当发生改变时，自动同步对象model到图形，并设置属性页
    onJsonGraphicsChanged: {
        drawarea_canvas.requestPaint()
        console.log("阿瑠")
    }
    onCurrentItemArrayChanged: {
        神里绫华=-1
        for(var a in currentItemArray)
            toTreeViewIndex(a)
        //treeview.currentItem=神里绫华
        console.log(神里绫华)
    }

    property int 神里绫华: -1

    function toTreeViewIndex(itemArray, model=jsonGraphics.subnodes, myIndex=[]) {
        for(var m in model)
            if(model[m].hasOwnProperty("subnodes")){
                myIndex.push(m)
                toTreeViewIndex(itemArray, model[m].subnodes, myIndex)
            }
        ++神里绫华
        if(myIndex===itemArray)
            return 神里绫华
    }

    Kamisato_Ayaka {
        id: file_manager
    }

    Yoimiya {
        id: color_manager
    }
    Raiden_Shogun {
        id: file_expoter
    }

    function saveCMD(){
        file_manager.jSONStr=JSON.stringify(jsonGraphics, null, 4)
        file_manager.saveFileButtonClicked()
    }
}


