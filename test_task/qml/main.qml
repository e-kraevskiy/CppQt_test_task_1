import QtQuick 2.15
import QtQuick.Window 2.14
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.1
import QtLocation 5.6
import QtPositioning 5.6

import widgets 1.0

Window {
    id: mainWindow
    minimumWidth: 1280
    minimumHeight: 720
    width: 1280
    height: 720
//    width: Screen.desktopAvailableWidth
//    height: Screen.desktopAvailableHeight
    visible: true
    title: qsTr("Polygon editor on the map")

    property MapCircle circle



    Plugin {
        id: mapPlugin
        name: "osm"
    }


    MapWidget {
        anchors.fill: parent
        id: map
    }

    SettingsWidget {
        id: settingsWidget
        anchors.margins: 20
        anchors.right: parent.right
        anchors.top: parent.top

    }

    Button {
        id: resetButton
        width: 100
        height: 50

        anchors.margins: 20
        anchors.left: parent.left
        anchors.top: parent.top
        text: "Сбросить"

        background: Rectangle {
            radius: 5
            color: "lightgray"
            opacity: 0.8
            border.color: "black"
            border.width: 2
        }

        onClicked: {
            map.resetPolygon()
        }
    }



    Shortcut {
        sequences: ["Ctrl+Q"]
        onActivated: Qt.quit()
    }

}
