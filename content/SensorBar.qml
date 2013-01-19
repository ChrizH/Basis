import QtQuick 2.0
import QtMultimedia 5.0
import TrackingSensor 1.0
Item {
    height: 130
    Row{
        anchors.centerIn: parent
        spacing: 20
        Rectangle{
            id: left
            color:"red"
            width: 30
            height: (_gameEngine.trackingSensor.sensorX.value-280)*2
        }
        Rectangle{
            id: right
            color: "green"
            width: 30
            height: (_gameEngine.trackingSensor.sensorY.value-300)*2
        }
    }

}
