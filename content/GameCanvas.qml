import QtQuick 2.0
import "../settings.js" as Settings
import "logic.js" as Logic
import CustomComponents 1.0
Item {
    id: gameContainer
    width: parent.width
    height: parent.height - (Settings.footerHeight + Settings.headerHeight)
    y: Settings.headerHeight

    Image{
        source:"images/background2.png"
        anchors.fill:parent
        fillMode: Image.Stretch
    }

    ShaderDemo1{
        id: demo1
        z:100
        width: parent.width
        height: parent.height
        y:1000
        //visible:false
    }

    ShaderDemo2{
        id:demo2
       z:200
       y:1000
        //anchors.centerIn: parent
        width: parent.width
        height: parent.height
        //visible:false
    }

    ShaderDemo3{
        id:demo3
       z:300
       y:1000
        //anchors.centerIn: parent
        width: parent.width
        height: parent.height
        //visible:false
    }


    function newGame(){
        if(gameContainer.state=="demo1")
            demo1.newGame()
        else if(gameContainer.state=="demo2")
            demo2.newGame()
        else if(gameContainer.state=="demo3")
            demo3.newGame()
        else
            console.debug("gamestate error")
    }

    function holdGame(){
        if(gameContainer.state=="demo1")
            demo1.active=false
        else if(gameContainer.state=="demo2")
            demo2.active=false
        else if(gameContainer.state=="demo3")
            demo3.active=false
        else
            console.debug("gamestate error")
    }

    function reactivateGame(){
        if(state=="demo1")
            demo1.active=true
        else if(gameContainer.state=="demo2")
            demo2.active=true
        else if(gameContainer.state=="demo3")
            demo3.active=true
        else
            console.debug("gamestate error")
    }



    states:[
        State{
            name:"demo1"
            PropertyChanges{target: demo1; y:0}
            PropertyChanges{target: demo2; y:1000}
            PropertyChanges{target: demo3; y:1000}
        },
        State{
            name:"demo2"
            PropertyChanges{target: demo1; y:1000}
            PropertyChanges{target: demo2; y:0}
            PropertyChanges{target: demo3; y:1000}
        },
        State{
            name:"demo3"
            PropertyChanges{target: demo1; y:1000}
            PropertyChanges{target: demo2; y:1000}
            PropertyChanges{target: demo3; y:0}
        }

    ]


    transitions: [
       Transition {
           PropertyAnimation { target: demo1
                               properties: "y"; duration: 500 }
           PropertyAnimation { target: demo2
                               properties: "y"; duration: 500 }
           PropertyAnimation { target: demo3
                               properties: "y"; duration: 500 }
       } ]



}
