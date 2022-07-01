import QtQuick 2.0
import QtLocation 5.3



MapCircle {
    id: root

    property int index: 0
    radius: 30
    color: "red"
    opacity: 0.8
    border.width: 3

    Component.onCompleted: {
        index = map.myMarkers.length
        console.log("index=", index)
    }

    MouseArea {
        anchors.fill: parent
        preventStealing: true
        drag.target: target
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        property var target: null

        onClicked: {
            if (mouse.button == Qt.RightButton) {
                map.removeMarker(index)
                console.log("right click")
            }
        }
        onPressAndHold: {
            target = root
            root.color = "yellow"
            console.log("onPressAndHold")
            map.gesture.enabled = false
            mouse.accepted = false
        }
        onReleased: {
            if (mouse.button == Qt.RightButton)
                return
            console.log("onReleased")
            target = null
            map.moveMarker(index)
            root.color = "red"
            map.gesture.enabled = true
            mouse.accepted = false
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


    //        center =
    //        circle = Qt.createQmlObject('import QtLocation 5.3; MapCircle {}', map)
    //        circle.center = coordinates
    //            circle.center = positionSource.position.coordinate
    //        circle.radius = 10.0
    //        circle.color = 'green'
    //        circle.border.width = 3
    //        map.addMa/pItem(circle)
}


