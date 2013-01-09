import QtQuick 2.0
import Shapes 3.0
import "content"

Item {
    id: container
    width: 1280; height: 768


    Image{
        source:"content/images/background-puzzle.png"
        width: parent.width
        height: parent.height
        fillMode: Image.Tile
    }



    Bullet{
        x:10;y:10
        color:"black"
    }

    InfoBar{
        anchors.top:container.Top
        anchors.topMargin: 10
        width: parent.width
    }

    SensorBar{
        id: sensors
        width: container.width
        anchors.centerIn: container
    }

    /*Text {
        id: leftSensor
        x: 50; y: 255; width: 200; height: 100
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 20
        text: _trackingSensor.leftSensor.toString()
    }
    Text {
        id: bottomSensor
        anchors.left: leftSensor.right
        anchors.leftMargin: 20
        y: 255; width: 200; height: 100
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 20
        text: _trackingSensor.bottomSensor.toString()
    }
    Text {
        id: rightSensor
        anchors.left: bottomSensor.right
        anchors.leftMargin: 20
        y: 255; width: 200; height: 100
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 20
        text: _trackingSensor.rightSensor.toString()
    }*/

    SerialButtonBar{
        anchors.horizontalCenter: parent.Center
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        width: parent.width
    }
}
