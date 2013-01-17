import QtQuick 2.0
import Shapes 3.0
import "settings.js" as Settings
import "content"

import "content/logic.js" as Logic
Item {
    id: root
    width: 1400; height: 768
    //property var gameState: Settings.gameStates.RUNNING

    property int timePlayed: 0
    property int errors: 0

    // backgroundimage
    SystemPalette { id: activePalette }

    InfoBar{
        z:2
        id: headerBar
        anchors.top: root.top
        //anchors.topMargin: 10
        width: parent.width
        height: Settings.headerHeight
    }

    GameCanvas{
        id: gameCanvas
        z: 1
        //anchors.centerIn: parent
    }


    Menu{
        id: menu
        y: Settings.headerHeight
        width: parent.width/2
        height: (parent.height - Settings.headerHeight - Settings.footerHeight)*0.75
        //anchors.top: headerBar.bottom
        anchors.centerIn:parent
        visible: false
    }

    BottomBar{
        z:2
        id: serialButtons
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        width: parent.width
        onOpenMenu:{
            menu.visible=true
            menu.enabled=true
        }
        onCloseMenu:{
            menu.visible=false
            menu.enabled=false
        }
        onStartGame:{
            Logic.startGame(gameCanvas)
        }
    }

    /*states:[
        State{
            name:"running"; when:gameState = Settings.gameStates.RUNNING
            PropertyChanges{target: bullet; visible: true}
            PropertyChanges{target: menu; visible: false}
        },
        State{
            name:"menu"; when:gameState=Settings.gameStates.MENU
            PropertyChanges{target: bullet; visible: false}
            PropertyChanges{target: menu; visible: true}

        }

    ]*/


}
