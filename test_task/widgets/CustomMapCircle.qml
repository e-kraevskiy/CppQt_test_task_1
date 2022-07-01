import QtQuick 2.0
import QtLocation 5.3



MapCircle {
    id: root

    property int index: 0
    radius: map.markerSize
    color: "red"
    opacity: 0.8
    border.width: 3

    Component.onCompleted: {
        index = map.myMarkers.length
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
            }
        }
        onPressAndHold: {
            target = root
            root.color = "yellow"
            map.gesture.enabled = false
            mouse.accepted = false
        }
        onReleased: {
            if (mouse.button == Qt.RightButton)
                return
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
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: index.toString()
        }
    }
}


