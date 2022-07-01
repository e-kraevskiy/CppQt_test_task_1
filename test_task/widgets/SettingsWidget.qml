import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

Item {
    width: parent.width/4
    height: parent.height/5
    Rectangle {
        anchors.fill: parent
        color: "lightgray"
        border.color: "black"
        border.width: 2
        radius: 5

        ColumnLayout {
            anchors.fill: parent
            spacing: 5

            RowLayout{
                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width*0.4
                    Text {
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: qsTr("Размер узлов")
                    }
                }

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Slider {
                        anchors.fill: parent
                        from: 20
                        to: 80
                        value: map.markerSize
                        onValueChanged: {
                            map.markerSize = value
                        }
                    }
                }

            }
            RowLayout{
                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width*0.4
                    Text {
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: qsTr("Прозрачность\nполигона")
                    }
                }
                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Slider {
                        anchors.fill: parent
                        from: 1
                        to: 0
                        value: map.polygonOpacity
                        onValueChanged: {
                            map.polygonOpacity = value
                        }
                    }
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
                CheckBox {
                    anchors.fill: parent
                    text: qsTr("Отображать вспомогательные узлы")
                    checked: map.edgeMarkersVisible
                    onCheckedChanged: {
                        map.edgeMarkersVisible = checked
                    }
                }
            }
        }
    }
}
