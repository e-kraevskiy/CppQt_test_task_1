import QtQuick 2.15
import QtQuick.Window 2.14
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.1
import QtLocation 5.6
import QtPositioning 5.6

import widgets 1.0

Map {
    id: map

    property variant markers
    property variant myMarkers
    property variant mapItems
    property int markerCounter: 0 // counter for total amount of markers. Resets to 0 when number of markers = 0
    property int currentMarker
    property int lastX : -1
    property int lastY : -1
    property int pressX : -1
    property int pressY : -1
    property int jitterThreshold : 30
    property bool followme: false
    property variant scaleLengths: [5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 1000000, 2000000]



    anchors.fill: parent
    plugin: mapPlugin
    center: QtPositioning.coordinate(60.035, 30.283) // :)
    zoomLevel: 15
    maximumTilt: 0


    Component.onCompleted: {

        markers = new Array(0);
        mapItems = new Array(0);
        circle = Qt.createQmlObject('import QtLocation 5.3; MapCircle {}', map)
        circle.center = map.center
//            circle.center = positionSource.position.coordinate
        circle.radius = 10.0
        circle.color = 'green'
        circle.border.width = 3
        map.addMapItem(circle)
    }

    MapPolygon {
        id: polygone
        color: 'orange'
        opacity: 0.4
        }


    MouseArea {
        id: mouseArea
        property variant lastCoordinate
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onPressed : {
            map.lastX = mouse.x
            map.lastY = mouse.y
            map.pressX = mouse.x
            map.pressY = mouse.y
            lastCoordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
        }

        onClicked: {
            if (mouse.button == Qt.LeftButton) {
//                    console.log("LeftButton")
//                    console.log(map.toCoordinate(Qt.point(mouse.x,mouse.y)))
                polygone.addCoordinate(map.toCoordinate(Qt.point(mouse.x,mouse.y)))
                addCircle(map.toCoordinate(Qt.point(mouse.x,mouse.y)))
                addMarker()
            }
            if (mouse.button == Qt.RightButton) {
//                    console.log("RightButton")
//                    console.log(map.toCoordinate(Qt.point(mouse.x,mouse.y)))
                polygone.removeCoordinate(map.toCoordinate(Qt.point(mouse.x,mouse.y)))
            }
        }


        onPressAndHold:  {

//            var coordinate = map.toCoordinate(Qt.point(mouse.x,mouse.y))
//            markerModel.addMarker(coordinate)
            console.log("pressed and hold map")
        }
    }
    function addCircle(coordinates) {
        var circle = Qt.createQmlObject('CustomMapCircle {}', map)
        circle.center = coordinates
        map.addMapItem(circle)

        //update list of markers
        var count = map.markers.length
        markerCounter++
        var myArray = new Array(0)
        for (var i = 0; i < count; i++) {
            myArray.push(myMarkers[i])
        }
        myArray.push(circle)
        myMarkers = myArray
    }


    function addMarker()
    {
        var count = map.markers.length
        markerCounter++
        var marker = Qt.createQmlObject ('Marker {}', map)
        map.addMapItem(marker)
        marker.z = map.z+1
        marker.coordinate = mouseArea.lastCoordinate

        //update list of markers
        var myArray = new Array(0)
        for (var i = 0; i < count; i++){
            myArray.push(markers[i])
        }
        myArray.push(marker)
        markers = myArray
    }

    function moveMarker(index) {
        var path = polygone.path;
        path[index] = myMarkers[index].center
        polygone.path = path
    }

    function removeMarker(index) {
//        map.clearMapItems()
//        polygone.path.clear()
        var count = map.markers.length
        var path = new Array(0)
        var myArray = new Array(0)
        markerCounter--
        for (var i = 0; i < count; i++) {
            if (index === i) {continue}
            path.push(myMarkers[i].center)
            myArray.push(markers[i])
        }
        map.removeMapItem(myMarkers[index])
//        path[index] = myMarkers[index].center
//        polygone.path = path
       polygone.removeCoordinate(myMarkers[index].center)
    }
}

//Component {
//    id: mapcomponent
//    MapQuickItem {
//        id: marker
//        anchorPoint.x: image.width/4
//        anchorPoint.y: image.height
//        coordinate: position

//        sourceItem: Rectangle {
//            id: image
//            width: 50
//            height: 50
//            color: "red"
//        }
//    }
//}


