import QtQuick 2.0
import QtMultimedia 5.0
import "../settings.js" as Settings
import "logic.js" as Logic
Item {
    id: container
    height: Settings.footerHeight

    signal openMenu()
    signal closeMenu()
    signal startGame()
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
            label: "Quit"
            onClicked: {
                Qt.quit()
            }
        }

        Button{
            id:menuButton
            label: "Open Menu"
            onClicked:{
                if(parent.state=="open")
                   container.closeMenu()
                else
                    container.openMenu()
                parent.state == "open" ? parent.state = "close" : parent.state ="open"

            }

        }

        Button{
            id: startGame
            label: "Start Game"
            onClicked: {
                _gameEngine.setGameOn(!_gameEngine.gameOn)
            }
        }

        state:"open"
        states:[
            State{
                name:"open"
                PropertyChanges{target: menuButton; label: "Close Menu"}
            },
            State{
                name:"close";
                PropertyChanges{target: menuButton; label: "Open Menu"}
            }

        ]

    }

    /*Audio{      // for audio reconfigure QT with gstreamer support
            id: audio
            source:"sound/Todesschrei.mp3"
            volume: 1.0
           // autoPlay:true
    }*/
}
