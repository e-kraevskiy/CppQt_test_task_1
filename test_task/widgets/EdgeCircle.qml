import QtQuick 2.0
import QtLocation 5.3


MapCircle {
    id: root

    property int index: 0
    radius: 20
    color: "green"
//    opacity: 0
    border.width: 3

    Component.onCompleted: {
        index = map.edgeMarkers.length
//        console.log("edge index=", index)
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: parent
        preventStealing: true
        drag.target: target
        property var target: null

        onEntered: {
            root.color = "orange"
            root.opacity = 0.8;
        }

        onExited: {
            root.color = "green"
//            root.opacity = 0
        }

        onClicked: {
            console.log("Добавялем новый узел")
            var coord = map.toCoordinate(Qt.point(mouse.x,mouse.y))
            map.insertMarker(index)
        }
    }
    Item {
        anchors.fill: parent
        Text{
            id: numberText
            anchors.fill: parent
            color: "black"
            font.bold: true
            font.pixelSize: 10
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: index.toString()
        }
    }
}


