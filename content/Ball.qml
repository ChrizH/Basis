import QtQuick 2.0
import "../settings.js" as Settings
Item {
    id: container
    //width: 30; height: 50
    z: 10

    property bool collision: false



    //property int ballSize
   // color:"white"

    // controlling with mouse - if local steering

    //source: "images/blue.png"

    MouseArea {
        anchors.fill: parent
        enabled: !_gameEngine.trackingEnable
        //anchors.margins: -ballSize
        onPositionChanged: {
            var posInView = container.mapToItem(shaderContainer, mouse.x-ballSize, mouse.y-ballSize)
            container.x = posInView.x;
            container.y = posInView.y;
        }
    }
    /*Text {
        anchors.centerIn: parent
        style: Text.Outline
        color: "white"
        font.pixelSize: 20
        text: "MOVE\nx: "+container.x+"|y: "+container.y
    }*/
}
