import QtQuick 2.0

Rectangle {
    id: container
    width: 100
    height: 64
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
