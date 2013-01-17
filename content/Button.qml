import QtQuick 2.0
import "../settings.js" as Settings
Rectangle {
    id: container
    property string label:"default"
    signal clicked()

    anchors.margins: 10
    width: buttonLabel.width + 20; height: buttonLabel.height + 5
    border { width: 1; color: Qt.darker(activePalette.button) }
    antialiasing: true
    radius: 8

    // color the button with a gradient
    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: {
                if (mouseArea.pressed)
                    return activePalette.dark
                else
                    return activePalette.light
            }
        }
        GradientStop { position: 1.0; color: activePalette.button }
    }

    Text{
        id: buttonLabel
        text: label.toString()
        anchors.centerIn: parent
        font.pointSize: 10
        color:  activePalette.buttonText
    }

    MouseArea{
        id: mouseArea
        anchors.fill: parent
        onClicked:{
            container.clicked()
            //parent.state == "clicked" ?
              //              parent.state = "default" : parent.state = "clicked"
        }


    }

}
