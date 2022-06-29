import QtQuick 2.0;
import QtLocation 5.6

MapQuickItem {
    id: marker
    property alias lastMouseX: markerMouseArea.lastX
    property alias lastMouseY: markerMouseArea.lastY

//! [mqi-anchor]
    anchorPoint.x: image.width/4
    anchorPoint.y: image.height

    sourceItem: Rectangle {
        id: image
//! [mqi-anchor]
        width: 25
        height: width
        radius: width/2
        color: "cyan"
        opacity: markerMouseArea.pressed ? 0.6 : 1.0
        MouseArea  {
            id: markerMouseArea
            property int pressX : -1
            property int pressY : -1
            property int jitterThreshold : 10
            property int lastX: -1
            property int lastY: -1
            anchors.fill: parent
            hoverEnabled : false
            drag.target: marker
            preventStealing: true

            onPressed : {
//                map.pressX = mouse.x
//                map.pressY = mouse.y
//                map.currentMarker = -1
//                for (var i = 0; i< map.markers.length; i++){
//                    if (marker == map.markers[i]){
//                        map.currentMarker = i
//                        break
//                    }
//                }
                console.log("onPressed")
                map.gesture.enabled = false
            }

            onPressAndHold:{
                if (Math.abs(map.pressX - mouse.x ) < map.jitterThreshold
                        && Math.abs(map.pressY - mouse.y ) < map.jitterThreshold) {
//                    var p = map.fromCoordinate(marker.coordinate)
//                    lastX = p.x
//                    lastY = p.y
//                    map.showMarkerMenu(marker.coordinate)
                    console.log("onPressAndHold")
                }
            }
            onReleased: {
                map.gesture.enabled = true
            }
        }

        Text{
            id: number
            y: image.height/10
            width: image.width
            color: "white"
            font.bold: true
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            Component.onCompleted: {
                text = map.markerCounter
            }
        }
    }

    Component.onCompleted: {
        coordinate = map.toCoordinate(Qt.point(markerMouseArea.mouseX,
                                               markerMouseArea.mouseY));
    }
}
