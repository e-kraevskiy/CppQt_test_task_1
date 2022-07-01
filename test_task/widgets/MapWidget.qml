import QtQuick 2.15
import QtQuick.Window 2.14
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.1
import QtLocation 5.6
import QtPositioning 5.6

import widgets 1.0

Map {
    id: map

    property variant myMarkers
    property variant edgeMarkers

    property real polygonOpacity: 0.4
    property int markerSize: 30
    property bool edgeMarkersVisible: false

    anchors.fill: parent
    plugin: mapPlugin
    center: QtPositioning.coordinate(54.992, 73.369)
    zoomLevel: 15


    Component.onCompleted: {
        myMarkers = new Array(0);
        edgeMarkers = new Array(0);
    }

    MapPolygon {
        id: polygone
        color: 'orange'
        border.width: 5
        opacity: polygonOpacity
        }


    MouseArea {
        id: mouseArea
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.fill: parent

        onClicked: {
            var coord = map.toCoordinate(Qt.point(mouse.x,mouse.y))
            polygone.addCoordinate(coord)
            addMarker(coord)
        }
    }
    // Добавить узел (круг) в конец
    function addMarker(coordinates) {
        var circle = Qt.createQmlObject('CustomMapCircle {}', map)
        circle.center = coordinates
        map.addMapItem(circle)

        myMarkers.push(circle)
        // Добавление узлов на ребрах
        if (myMarkers.length === 2) {
            addAdgeMarker(1, 0, coordinates)
        } else if (myMarkers.length === 3) {
            addAdgeMarker(myMarkers.length-1, myMarkers.length-2, coordinates)
            addAdgeMarker(myMarkers.length-1, 0, coordinates)

        } else if (myMarkers.length > 3) {
            removeAdgeMarker(edgeMarkers.length-1)
            addAdgeMarker(myMarkers.length-1, myMarkers.length-2, coordinates)
            addAdgeMarker(myMarkers.length-1, 0, coordinates)

        }
    }
    // Вставить маркер не в конец
    function insertMarker(index) {
        var circle = Qt.createQmlObject('CustomMapCircle {}', map)

        var coordinates = edgeMarkers[index].center
        circle.center = coordinates
        circle.index = index + 1
        map.addMapItem(circle)
        // Перезаписываем полигон и массив узлов
        var count = map.myMarkers.length
        var path = new Array(0)
        var myArray = new Array(0)
        for (var i = 0; i < count; i++) {
            // Вставляем узел
            if (i === index+1) {
                myArray.push(circle)
                path.push(circle.center)
            }
            // Инкрементируем индексы после добавленного
            if (i > index) {
                myMarkers[i].index += 1
            }
            path.push(myMarkers[i].center)
            myArray.push(myMarkers[i])
        }
        // если добавляем последний узел
        if (index === count-1) {
            myArray.push(circle)
            path.push(circle.center)
        }
        polygone.path = path
        myMarkers = myArray
        moveEdgeMarker(index+1, coordinates)
        insertEdgeMarker(index)
    }
    // Передвинуть узел
    function moveMarker(index) {
        var path = polygone.path;
        path[index] = myMarkers[index].center
        polygone.path = path
        // Двигаем маркеры на ребрах
        if (myMarkers.length === 1) return
        if (myMarkers.length === 2) {
            moveEdgeMarker(0, edgeMarkers[0].center)
        } else if (myMarkers.length > 2) {
            if (index === 0) {
                moveEdgeMarker(index, edgeMarkers[index].center)
                moveEdgeMarker(myMarkers.length-1, edgeMarkers[myMarkers.length-1].center)
            } else {
                moveEdgeMarker(index, edgeMarkers[index].center)
                moveEdgeMarker(index-1, edgeMarkers[index-1].center)
            }
        }
    }
    // Удалить узел по индексу
    function removeMarker(index) {
        var count = map.myMarkers.length
        var path = new Array(0)
        var myArray = new Array(0)
        // Формируем новый массив узлов
        for (var i = 0; i < count; i++) {
            if (index === i) {continue}
            myMarkers[i].index = i
            path.push(myMarkers[i].center)
            myArray.push(myMarkers[i])
        }
        map.removeMapItem(myMarkers[index])
        // Обновляем полигон и узлы
        polygone.path = path
        myMarkers = myArray
        // Обновляем индексы узлов
        for (var j = 0; j < myArray.length; j++) {
            myMarkers[j].index = j
        }
        // Узлы на ребрах - один перемещаем, второй удаляем.
        if (index === 0) {
            moveEdgeMarker(myMarkers.length-1, edgeMarkers[edgeMarkers.length-1].center)
            removeAdgeMarker(index)
        } else {
            moveEdgeMarker(index-1, edgeMarkers[index-1].center)
            removeAdgeMarker(index)
        }
    }
    // Добавить маркер на ребре в конец
    function addAdgeMarker(firstIndex, secondIndex, coord) {
        var tmpPoint = coord
        tmpPoint.latitude = (myMarkers[firstIndex].center.latitude
                             + myMarkers[secondIndex].center.latitude) / 2
        tmpPoint.longitude = (myMarkers[firstIndex].center.longitude
                             + myMarkers[secondIndex].center.longitude) / 2
        var edgeCircle = Qt.createQmlObject('EdgeCircle {}', map)
        edgeCircle.center = tmpPoint
        map.addMapItem(edgeCircle)
        edgeMarkers.push(edgeCircle)
    }
    // Вставить маркер на ребре при добавлении узла не в конец
    function insertEdgeMarker(index) {
        var marker = Qt.createQmlObject('EdgeCircle {}', map)
        var coordinates = edgeMarkers[index].center
        marker.center = coordinates
        marker.index = index + 1
        map.addMapItem(marker)
        // Перезаписываем массив узлов
        var count = map.edgeMarkers.length
        var myArray = new Array(0)
        for (var i = 0; i < count; i++) {
            // Вставляем узел
            if (i === index+1) {
                myArray.push(marker)
            }
            // Инкрементируем индексы после добавленного
            if (i > index) {
                edgeMarkers[i].index += 1
            }
            myArray.push(edgeMarkers[i])
        }
        // если добавляем последний узел
        if (index === count-1) {
            console.log("sdfjasdfjsd")
            myArray.push(marker)
        }
        moveEdgeMarker(index, coordinates)
        edgeMarkers = myArray
    }

    function removeAdgeMarker(index) {

        var count = map.edgeMarkers.length
        var myArray = new Array(0)
        // Формируем новый массив узлов
        for (var i = 0; i < count; i++) {
            if (index === i) {continue}
            edgeMarkers[i].index = i
            myArray.push(edgeMarkers[i])
        }
        map.removeMapItem(edgeMarkers[index])
        // Обновляем полигон и узлы
        edgeMarkers = myArray
        // Обновляем индексы узлов
        for (var j = 0; j < myArray.length; j++) {
            edgeMarkers[j].index = j
        }
    }
    // Сдвинуть маркер на ребре, по положению сосоедних узлов
    function moveEdgeMarker(index, coord) {
        var prev = index
        var next = index+1
        if (index === (myMarkers.length - 1)) {
            next = 0
        }
        coord.latitude = (myMarkers[prev].center.latitude
                          + myMarkers[next].center.latitude) / 2
        coord.longitude = (myMarkers[prev].center.longitude
                           + myMarkers[next].center.longitude) / 2
    }

    // Очистка всех обхъектов полигона на карте
    function resetPolygon() {
        for (var i = 0; i < myMarkers.length; i++) {
            map.removeMapItem(myMarkers[i])
        }
        for (var j = 0; j < edgeMarkers.length; j++) {
            map.removeMapItem(edgeMarkers[j])
        }
        map.myMarkers = new Array(0);
        map.edgeMarkers = new Array(0);
        polygone.path = new Array(0);
    }
}



