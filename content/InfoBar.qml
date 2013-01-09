import QtQuick 2.0

Item {
    height: childrenRect.height
    //width: 100
    //height: 62

    Row{

            anchors.left: parent.left
            anchors.leftMargin: 10
            spacing: 10
            Text{
                id: comport
                text: "Comport: "+(_trackingSensor.comportAvailable == true ? "true":"false")
                font.bold: true
            }
        }
       Row{
            id: connection
            anchors.right: parent.right
            spacing: 10
            Text{
                text: "Connection open: "+(_trackingSensor.connectionAvailable==true?"true":"false")
                font.bold: true
            }
        }
    }

