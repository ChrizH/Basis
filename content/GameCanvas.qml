import QtQuick 2.0
import "../settings.js" as Settings
import "logic.js" as Logic
import CustomComponents 1.0
Item {
    id: gameContainer
    width: parent.width
    height: parent.height - Settings.footerHeight - Settings.headerHeight
    y: Settings.headerHeight
    property int squareSize: 64
    property int rows: 6
    property int cols: 4
    //property Item canvas: grid
    property int score: 0
    property int coins: 100
    property int lives: 3




    /*ShaderEffectSource{
        id: shaderSource
        sourceItem:backgroundImage
    }*/



    /*Image{
        id: backgroundImage
        source:"images/background-puzzle.png"
        width: parent.width
        height: parent.height
        fillMode: Image.Tile


    Obstacle{
        id: obstacle
        x:300
        y: 200
        //shaderShining: slider.value
        enable:true
        parentImage:backgroundImage
        shaderSource: shaderSource
    }

    Timer{
         id: timer
         interval: 100

         onTimeout: {
             moveObstacles()
             //console.debug("hallo")
         //content/face-smile.png}
              }
     }

    function moveObstacles(){
        player.x=player.x+1
    }

    /*ShaderDemo2{
        anchors.centerIn: parent
    }*/


    ShaderDemo2{
        z:1
        //anchors.centerIn: parent
        width: parent.width
        height: parent.height
    }

    /*Slider {
        z:10
        id: slider
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        width: parent.width
        minimum: 0.1
        value: 0.55
        maximum: 1.0
        text: "<<<  Adjust Shining  >>>"
    }*/

    /*Timer{
        interval: 16
        running: true
        repeat: true
        onTriggered: Logic.tick()
    }*/

    /*SensorBar{
        z:2
        id: sensors
        width: container.width
        anchors.centerIn: container
    }

    Player{
        x:30
        y:100
        id: player
    }/*

    Row{
        x: 400
        y: 400
        id: obstacles
        Repeater{
            model: 3
            Obstacle{

            }
        }
    }

   // function createObstacles(){
    //    var
   // }

   /* function freshState() {
        lives = 3
        coins = 100
        score = 0
        waveNumber = 0
        waveProgress = 0
        gameOver = false
        gameRunning = false
        towerMenu.shown = false
        helpButton.comeBack();
    }
    Timer {
        interval: 16
        running: true
        repeat: true
        onTriggered: Logic.tick()
    }

*/


}
