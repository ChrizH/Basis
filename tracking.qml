import QtQuick 2.0
import Shapes 3.0
import "settings.js" as Settings
import "content"

import "content/logic.js" as Logic
Item {
    id: container
    width: 1024; height: 768
    property var gameState: Settings.gameStates.RUNNING
    // backgroundimage

    /*Obstacle{
        z:2
        id: bullet
        x:10;y:100
        //color:"black"
        visible:true
    }*/

    InfoBar{
        z:2
        id: headerBar
        anchors.top: container.top
        anchors.topMargin: 10
        width: parent.width
    }

    GameCanvas{
        id: gameCanvas
        z: 1
        //anchors.centerIn: parent
    }


    Menu{
        id: menu
        y: Settings.headerHeight
        width: parent.width/1.6
        height: parent.height - Settings.headerHeight - Settings.footerHeight
        anchors.top: headerBar.bottom
        anchors.horizontalCenter: parent.horizontalCenter
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
