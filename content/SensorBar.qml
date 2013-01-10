import QtQuick 2.0
import QtMultimedia 5.0
import "../settings.js" as Settings
Item {
    //anchors.centerIn: parent
    //anchors.horizontalCenter: parent.horizontalCenter
    height: Settings.footerHeight
    //color: "black"
    Row{
        anchors.centerIn: parent
        spacing: 20
        Sensor{
            id: left
            grColor: "red"
            offset: 141
            value: _trackingSensor.leftSensor
            soundSource: "sound/Todesschrei.mp3"
        }
        Sensor{
            id: bottom
            grColor: "green"
            offset: 142
            value: _trackingSensor.bottomSensor
            soundSource: "sound/Todesschrei.mp3"
        }
        Sensor{
            id: right
            grColor: "blue"
            offset: 123
            value: _trackingSensor.rightSensor
            soundSource: "sound/Todesschrei.mp3"
        }
    }

}
