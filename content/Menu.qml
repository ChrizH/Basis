import QtQuick 2.0
Item {
    //height: parent.height
    //width: parent.width/2
    z: 2
    //anchors.top: parent.top
    // background image
    Image{
        source:"images/background.png"
        width: parent.width
        height: parent.height
        fillMode: Image.Tile
    }

    // MenuHeader
    Text{
        id: header
        text: "MENU"
        font.bold: true
        font.pixelSize: 18
        anchors.centerIn: parent
        anchors.top: parent.top
    }

}
