import QtQuick 2.0
import "../settings.js" as Settings
Rectangle {
    id: container
    width: Settings.toolButtonWidth
    height: Settings.toolButtonHeight
    color:"green"
    property string label:"default"
    signal clicked()

    anchors.margins: 10
    /*Image{
        id: img

    }*/

    Image{
     //   source:"images/"
    }

    Text{
        text: label.toString()
        anchors.centerIn: parent
        font.pointSize: 10
        color: "#ffffff"
    }

    MouseArea{
        anchors.fill: parent
        onClicked:{
            container.clicked()
            parent.state == "clicked" ?
                            parent.state = "default" : parent.state = "clicked"
        }


    }

    states: [
        State {
            name: "default"
            PropertyChanges { target: container; color: "green" }
        },
        State {
            name: "clicked"
            PropertyChanges { target: container; color: "blue" }
        }
    ]

}
