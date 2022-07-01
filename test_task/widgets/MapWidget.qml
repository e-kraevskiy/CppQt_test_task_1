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
//    property int lastX : -1
//    property int lastY : -1
//    property int pressX : -1
//    property int pressY : -1
    property int jitterThreshold : 30



    anchors.fill: parent
    plugin: mapPlugin
    center: QtPositioning.coordinate(54.992, 73.369) // :)
    zoomLevel: 15
//    maximumTilt: 0


    Component.onCompleted: {
        myMarkers = new Array(0);
        markers = new Array(0);
        mapItems = new Array(0);
    }

    MapPolygon {
        id: polygone
        color: 'orange'
        border.width: 5
        opacity: 0.4
        }



    MouseArea {
        id: mouseArea
        property variant lastCoordinate
        anchors.fill: parent

        onPressed : {
//            map.lastX = mouse.x
//            map.lastY = mouse.y
//            map.pressX = mouse.x
//            map.pressY = mouse.y
            lastCoordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
        }

        onClicked: {
            var coord = map.toCoordinate(Qt.point(mouse.x,mouse.y))

            polygone.addCoordinate(coord)
            addCircle(coord)
//            addMarker()
        }
    }

    function addCircle(coordinates) {
        var circle = Qt.createQmlObject('CustomMapCircle {}', map)
        circle.center = coordinates
        map.addMapItem(circle)

        //update list of markers
        var count = map.myMarkers.length
        markerCounter++
        var myArray = new Array(0)
        for (var i = 0; i < count; i++) {
            myArray.push(myMarkers[i])
        }
        myArray.push(circle)
        myMarkers = myArray
    }


    function addMarker() {
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
//        path[index] = markers[index].center
        polygone.path = path
    }

    function removeMarker(index) {

        console.log("remocing index=", index)
        var count = map.myMarkers.length
        console.log("map.markers.length", map.myMarkers.length)
        var path = new Array(0)
        var myArray = new Array(0)
        markerCounter--
        // Формируем новый массив узлов
        for (var i = 0; i < count; i++) {
            if (index === i) {continue}
            myMarkers[i].index = i
            path.push(myMarkers[i].center)
            myArray.push(myMarkers[i])
        }

        map.removeMapItem(myMarkers[index])
        console.log("myArray length", myArray.length)
        myMarkers = myArray
        // Обновляем полигон и узлы
        polygone.path = path
        // Обновляем индексы узлов
        for (var j = 0; j < myArray.length; j++) {
            myMarkers[j].index = j
        }
    }

    function removePolynom() {

    }
}



