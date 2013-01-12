import QtQuick 2.0
import QtMultimedia 5.0
import "logic.js" as Logic
import TrackingSensor 1.0
Item {
    //anchors.centerIn: parent
    //anchors.horizontalCenter: parent.horizontalCenter
    height: 300
    //color: "black"
    Row{
        anchors.centerIn: parent
        spacing: 20
        Sensor{
            id: left
            grColor: "red"
            offset: 141
            value: (_gameEngine.trackingEnable == true ? _gameEngine.trackingSensor.leftSensor : 190)
            soundSource: "sound/Todesschrei.mp3"
        }
        Sensor{
            id: bottom
            grColor: "green"
            offset: 142
            value: _gameEngine.trackingEnable == true ? _gameEngine.trackingSensor.bottomSensor : 160
            soundSource: "sound/Todesschrei.mp3"
        }
        Sensor{
            id: right
            grColor: "blue"
            offset: 123
            value: _gameEngine.trackingEnable == true ? _gameEngine.trackingSensor.rightSensor : 220
            soundSource: "sound/Todesschrei.mp3"
        }
    }

}
