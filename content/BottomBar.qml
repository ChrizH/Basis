import QtQuick 2.0
import QtMultimedia 5.0
import "../settings.js" as Settings
import "logic.js" as Logic
Item {
    id: container
    height: Settings.footerHeight

    signal openMenu()
    signal closeMenu()
    signal continue_()
    signal quit();
    signal newGame()
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
                _gameEngine.setCloseApp(true);
            }
        }

        Button{
            id:menuButton
            label: "Open Menu"
            onClicked:{

                if(parent.state=="open"){
                   container.closeMenu()
                }
                else{
                    container.openMenu()
                    //_gameEngine.setGameOn(false)
                }
                parent.state == "open" ? parent.state = "close" : parent.state ="open"
            }
        }

        /*Button{
            id: continueButton
            label: _gameEngine.gameOn == true ? "Pause":"Continue"
            onClicked: {
                _gameEngine.setGameOn(!_gameEngine.gameOn)
                if(container.state=="open"){
                    container.closeMenu()
                    container.state="close"
                }
            }
        }*/Button{
            id: newGame
            label:"New Game"
            onClicked:{
                //Logic.startGame()
                container.newGame()
            }
        }

        state:"close"
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
}
