import QtQuick 2.0

Rectangle {
    id: container
    width: 30; height: 50
    z: 10
    property bool alive: true
    //property int ballSize
    color:"white"

    MouseArea {
        anchors.fill: parent
        //anchors.margins: -ballSize
        onPositionChanged: {
            var posInView = container.mapToItem(shaderContainer, mouse.x-ballSize, mouse.y-ballSize)
            container.x = posInView.x;
            container.y = posInView.y;
        }
    }
    Text {
        anchors.centerIn: parent
        style: Text.Outline
        color: "white"
        font.pixelSize: 20
        text: "MOVE\nx: "+container.x+"|y: "+container.y
    }
}
