import QtQuick 2.0
import QtMultimedia 5.0

Item {
    height: childrenRect.height+20
    //color:"gray"
    Image{
        source:"images/bar.png"
        width: parent.width
        height: parent.height
        fillMode: Image.Tile
    }

    Row{
        anchors.centerIn: parent
        anchors.margins: 10
        spacing: 20
        Button{
            label: "Setup Connection"
            onClicked: _trackingSensor.setupConnection()
        }
        Button{
            label: "Open Connection"
            onClicked: _trackingSensor.openConnection()
        }
        Button{
            label: "Close Connection"
            onClicked: _trackingSensor.closeConnection()
        }
        Button{
            label: "Test Audio"
            //onClicked:{
            //    audio.play()
            //}
            Text{
            //    text: (audio.hasAudio==true?":)":":(")
            }
        }
        Button{
            label: "Open Menu"
            //onClicked:
        }

    }

    /*Audio{      // for audio reconfigure QT with gstreamer support
            id: audio
            source:"sound/Todesschrei.mp3"
            volume: 1.0
           // autoPlay:true
    }*/
}
