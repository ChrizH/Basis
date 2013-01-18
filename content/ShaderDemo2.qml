import QtQuick 2.0
//import CustomComponents 1.0
import "../settings.js" as Settings
Rectangle {
    id: shaderContainer

    property real ballSize: Settings.playerSize
    property real obstacleSize: Settings.obstacleSize
    property real goodySize: Settings.goodySize
    property int points: 0
    property int errors:0
    property bool gameOver: false
    //enabled: _gameEngine.gameOn
    property bool active:false;
    Image {
        id: backgroundImage
        source: "images/background-space2.jpg"
        anchors.fill: parent
        fillMode: Image.Stretch
    }
    // Info Text

    Text{
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 15
        text:"DEMO2\nPoints: "+points.toString()+"\n"+
                      "Time: "+timer.timePlayed.toString()+
             "\nLive: "+(Math.round(100-Settings.playerMinSize/ballSize*100)).toString()+
                    "\nActive: "+active.toString()+
             "\nGame Over: "+gameOver.toString()+
             "\nBallSize: "+ballSize
        font.pixelSize: 27
        color: "white"
        font.bold: true
    }
    states:[
        State{
            name:"game"
            PropertyChanges {
                target: gameOverText
                visible: false
            }
        },
        State{
            name:"gameOver"
            PropertyChanges {
                target: gameOverText
                visible: true
            }
        }
    ]

    Text{
        z:1000
        id: gameOverText
        text:"Game Over"
        anchors.centerIn: root.Center
        font.pixelSize: 38
        color: "white"
        font.bold: true
        visible:false
    }

    function newGame(){
        timer.timePlayed= 0
        errors= 0
        points=0
        timer.loopCounter= 0
        timer.collDetect=0
        timer.goodyCath=0
        ballSize = Settings.playerSize
        ballItem1.x=50
        ballItem1.y=50
        active=true
        gameOverText.visible=false
        shaderContainer.state="game"
    }

    function gameOver(){
        active=false
        shaderContainer.state="gameOver"
        gameOver=true
    }


    // main timer - for updating
    Timer{
        id: timer
        interval: 25
        running: active
        repeat:true

        property int loopCounter: 0
        property int collDetect:0
        property int goodyCath:0
        property int timePlayed:0

        onTriggered:{

            // check game over - ball < originalsize/factor
            if(ballSize<20)
                gameOver()

            // check goody collision
            if((timePlayed-goodyCath)>1)
            if(shaderEffect.checkDistance(shaderEffect.goody1,goodySize)){
                goodyCath=timePlayed;
                if(ballSize<200)
                    ballSize=ballSize*1.5
                points=points+1
            }

            // check obstacle collision
            if((timePlayed-collDetect)>1)
                if(shaderEffect.checkDistance(shaderEffect.obstacle1,obstacleSize)
                        ||shaderEffect.checkDistance(shaderEffect.obstacle2,obstacleSize))
                {
                    collDetect=timePlayed
                    ballItem1.collision=true
                    errors=errors+1
                    ballSize=ballSize/2
                }
                else
                    ballItem1.collision=false

            // count time
            if(loopCounter==40){
                timePlayed++
                loopCounter=0
            }else
                loopCounter=loopCounter+1

            // move obstacles
            //Logic.tick()

            // upadete movement in sensormode
            if(_gameEngine.trackingEnable)
                 ballItem1.controlWithSensor()
        }
    }


    Slider {
        id: slider
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        width: parent.width
        minimum: -2.0
        value: 0.55
        maximum: 2.0
        text: "<<<  Adjust Shining  >>>"
        visible: !_gameEngine.trackingEnable
    }

    Ball {
        id: ballItem1
        x: ballSize; y: shaderContainer.height/2-ballSize

        function controlWithSensor(){
            var stop = -100
            var offset = 30
            var offsetX = 122
            var offsetY = 122
            var offsetZ = 111.0

            var dX = _gameEngine.trackingSensor.sensorX.value//-offsetX
            var rangeX = _gameEngine.trackingSensor.sensorX.maxValue-_gameEngine.trackingSensor.sensorX.minValue
            var dY = _gameEngine.trackingSensor.sensorY.value//-offsetY
            var rangeY = _gameEngine.trackingSensor.sensorY.maxValue-_gameEngine.trackingSensor.sensorY.minValue

            //var dZ = _gameEngine.trackingSensor.sensorZ.value// == offset ? 0 : _gameEngine.trackingSensor.// - offsetZ

            // alternate shining
            // shining values 0 - 1
            // slider.value = dZ/offset

            // check if right or left       (dx < middle - right |  dx > middle - left)
            if(dX >= 0){
                if(dX < rangeX/2)
                    dX = (rangeX/2-dX)*(-1)                // left; else right
                else dX = dX-rangeX/2

                if(ballItem1.x + ballSize/2+dX < shaderContainer.width && ballItem1.x +ballSize/2 + dX > 0)    // correctur: center not in ball middle
                    ballItem1.x = ballItem1.x + dX
            }

            // check if up or down
            if(dY >=0){
                if(dY < rangeY/2)
                    dY = (rangeY/2-dY)*(-1)                // down; else up
                else dY = dY-rangeY/2
                // error with bottom collision
                if(ballItem1.y-ballSize/2 + dY < shaderContainer.height && ballItem1.y +ballSize/2+ dY > 0)                   // correctur: center not in ball middle
                    ballItem1.y = ballItem1.y + dY
            }
        }
    }

    Ball {
        id: ballItem2
        x: shaderContainer.width * 0.7; y: 100
        //width:2*ballSize; height:2*ballSize;
      }


    ShaderEffect {

        property variant source: ShaderEffectSource { sourceItem: backgroundImage }
        property real animY1
        property real animX1
        property real animY2
        property real animX2
        property real movementX
        property alias shining: slider.value
        property alias ballSize: shaderContainer.ballSize
        property alias goodySize: shaderContainer.goodySize
        property alias obstacleSize: shaderContainer.obstacleSize
        property variant obstacle1: Qt.point(animX1, animY1)
        property variant obstacle2: Qt.point(shaderContainer.width-animX1, shaderContainer.height-animY1+120)
        property variant obstacle3: Qt.point(shaderContainer.width-animX1, shaderContainer.height-animY1+120)
        property variant obstacle4: Qt.point(shaderContainer.width-animX1, shaderContainer.height-animY1+120)
        property variant goody1: Qt.point(animX2, animY2)
        property variant ball1: Qt.point(ballItem1.x+ballSize/2, (shaderContainer.height - ballItem1.y+ballSize/2))
        property variant ball2: Qt.point(ballItem2.x, (shaderContainer.height - ballItem2.y))
        property bool collision: ballItem1.collision

        //property int startX:
        //property int startY:
        id: shaderEffect
        anchors.fill: backgroundImage
        // obstacle movement
        SequentialAnimation on animY1{
            loops: Animation.Infinite
            running: active
            NumberAnimation { to: shaderContainer.height/2; duration: 5000; easing.type: Easing.OutQuad }
            NumberAnimation { to: 120; duration: 5000; easing.type: Easing.OutBounce }
        }
        SequentialAnimation on animX1 {
            loops: Animation.Infinite
            running: active
            NumberAnimation { to: shaderContainer.width/2-ballSize; duration:5000; easing.type: Easing.InOutExpo }
            NumberAnimation { to: 120; duration: 5000; easing.type: Easing.InElastic
            }
        }
        // goody movement
        SequentialAnimation on animY2{
            loops: Animation.Infinite
            running: active
            NumberAnimation { to: shaderContainer.height-goodySize-Settings.headerHeight; duration: 5000; easing.type: Easing.InElastic }
            //PauseAnimation {duration: 500}
            NumberAnimation { to: 120; duration: 5000; easing.type: Easing.SineCurve }

        }
        SequentialAnimation on animX2 {
            loops: Animation.Infinite
            running: active
            NumberAnimation { to: shaderContainer.width-goodySize; duration: 3000; easing.type: Easing.Linear }
            NumberAnimation { to: goodySize; duration: 3000; easing.type: Easing.Linear
            }
        }

        NumberAnimation on movementX{

        }

        function checkDistance(pos,checkSize){  // pos from other object + size
            // bigball animation has its own coordinate sysem -> left bottom 0,0
            var dist = Math.sqrt(Math.pow(Math.abs(ballItem1.x-pos.x),2)+Math.pow(Math.abs(shaderContainer.height-pos.y-ballItem1.y),2))
            var hit = false
            if(dist < (checkSize+ballSize)*0.75){
                hit = true
            }

            return hit
        }


        fragmentShader:active==true?
            " varying highp vec2 qt_TexCoord0;
                uniform lowp sampler2D source;
                uniform lowp float qt_Opacity;
                uniform highp vec2 obstacle1;
                uniform highp vec2 obstacle2;
                uniform highp vec2 goody1;
                uniform highp vec2 ball1;
                uniform highp vec2 ball2;
                uniform lowp float ballSize;
                uniform lowp float obstacleSize;
                uniform lowp float goodySize;
                uniform lowp float shining;
                uniform lowp bool collision;
                void main() {                        

                    lowp vec4 pixelColor = vec4(0.0, 0.0, 0.0, 0.0);
                    lowp vec4 obs1Color = vec4(0.0, 0.6, 0.8, 1.0);
                    lowp vec4 obs2Color = vec4(.2, 0.2, 0.8, 1.0);
                    lowp vec4 goodyColor = vec4(1.0, 1.0, 1.0, 1.0);

                    lowp vec4 playerColor = vec4(0.0, 0.8, 0.2, 1.0);

                    // obstacles
                    highp vec2 dist = obstacle1 - gl_FragCoord.xy;
                    highp float val = obstacleSize*obstacleSize / (dist.x * dist.x + dist.y * dist.y);
                    pixelColor += obs1Color * val;

                    dist = obstacle2 - gl_FragCoord.xy;
                    val = obstacleSize*obstacleSize / (dist.x * dist.x + dist.y * dist.y);
                    pixelColor += obs2Color * val;

                    // goodies
                    dist = goody1 - gl_FragCoord.xy;
                    val = goodySize*goodySize / (dist.x * dist.x + dist.y * dist.y);
                    pixelColor += goodyColor * val;

                    // player
                    if(collision){     // change color if player hit obstacle1
                        playerColor = vec4(1.0,0.0,0.0,1.0);
                    }
                    dist = ball1 - gl_FragCoord.xy;
                    val = (ballSize*ballSize) / (dist.x * dist.x + dist.y * dist.y);
                    pixelColor += playerColor * val;

                    // static ball
                    /*dist = ball2 - gl_FragCoord.xy;
                    val = (ballSize*ballSize) / (dist.x * dist.x + dist.y * dist.y);
                    pixelColor += playerColor * val;*/

                    highp float a = smoothstep(1.0 - shining, 1.0, pixelColor.a);
                    gl_FragColor = vec4(pixelColor.rgb * a, 0.0);
                }":""

    }
}
