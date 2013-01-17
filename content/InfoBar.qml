import QtQuick 2.0

Item {

    Image{
        source:"images/bar.png"
        width: parent.width
        height: parent.height
        fillMode: Image.Tile
    }

    Row{
            id: sensors
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Text{
                text: "X: "+(_gameEngine.trackingSensor.sensorX.value.toString())
                font.bold: true
                color:"white"
            }
            Text{
                text: "Y: "+(_gameEngine.trackingSensor.sensorY.value.toString())
                font.bold: true
                color:"white"
            }
            Text{
                text: "Z: "+(_gameEngine.trackingSensor.sensorZ.value.toString())
                font.bold: true
                color:"white"
            }


        }
        Row{
            anchors.centerIn: parent
            spacing: 10
            Text{
                text: "Game On: "+(_gameEngine.gameOn == true ? "true":"false")
                font.bold: true
                color:"white"
            }
            Text{
                text: "Controller: "+(_gameEngine.trackingEnable == true ? "Sensor":"Mouse")
                font.bold: true
                color:"white"
            }
            Text{
                text: "Time: "+root.timePlayed.toString()
                font.bold: true
                color:"white"
            }
            Text{
                text: "Errors: "+root.errors.toString()
                font.bold: true
                color:"white"
            }
        }

       Row{
            id: connection
            anchors.right: parent.right
            anchors.rightMargin: 10
            spacing: 10
            anchors.verticalCenter: parent.verticalCenter
            Text{
                text: "Comport: "+(_gameEngine.trackingSensor.comportAvailable == true ? "true":"false")
                font.bold: true
                color:"white"
            }

            Text{
                text: "Connection open: "+(_gameEngine.trackingSensor.connectionAvailable==true?"true":"false")
                font.bold: true
                color:"white"
            }
        }
    }

