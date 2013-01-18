import QtQuick 2.0
import Shapes 3.0
import "settings.js" as Settings
import "content"

import "content/logic.js" as Logic
Item {
    id: root
    width: 1400; height: 768
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
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width*0.6
        height: (parent.height - Settings.headerHeight - Settings.footerHeight)*0.8
        visible: true

        onPlayDemo1:{
            gameCanvas.state="demo1"
        }
        onPlayDemo2:{
            gameCanvas.state="demo2"
        }
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
            gameCanvas.holdGame()
        }
        onCloseMenu:{
            menu.visible=false
            menu.enabled=false
            // set game back to activ
            gameCanvas.reactivateGame()
        }
        onNewGame:{
            gameCanvas.newGame()
        }

    }


}
