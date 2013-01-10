import QtQuick 2.0
import Shapes 3.0
import "settings.js" as Settings
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
        id: headerBar
        anchors.top: container.top
        anchors.topMargin: 10
        width: parent.width
    }

    GameCanvas{
        id: gameCanvas
        z: 1
        width: parent.width
        height: parent.height/1.5
        anchors.centerIn: parent
    }
    Menu{
        y: Settings.headerHeight
        width: parent.width/1.6
        height: parent.height - Settings.headerHeight - Settings.footerHeight
        anchors.top: headerBar.bottom
    }

    SensorBar{
        id: bottomBar
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
        id: serialButtons
        anchors.horizontalCenter: parent.Center
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        width: parent.width
    }


}
