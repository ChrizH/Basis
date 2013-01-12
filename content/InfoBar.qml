import QtQuick 2.0

Item {
    height: childrenRect.height
    //width: 100
    //height: 62

    Row{
            id: sensors
            anchors.left: parent.left
            anchors.leftMargin: 10
            spacing: 10

            Text{
                text: "L: "+(_gameEngine.trackingSensor.leftSensor.toString())
                font.bold: true
            }
            Text{
                text: "R: "+(_gameEngine.trackingSensor.rightSensor.toString())
                font.bold: true
            }
            Text{
                text: "B: "+(_gameEngine.trackingSensor.bottomSensor.toString())
                font.bold: true
            }


        }
        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Game On: "+(_gameEngine.gameOn == true ? "true":"false")
        }

       Row{
            id: connection
            anchors.right: parent.right
            anchors.rightMargin: 10
            spacing: 10
            Text{
                text: "Comport: "+(_gameEngine.trackingSensor.comportAvailable == true ? "true":"false")
                font.bold: true
            }

            Text{
                text: "Connection open: "+(_gameEngine.trackingSensor.connectionAvailable==true?"true":"false")
                font.bold: true
            }
        }
    }

