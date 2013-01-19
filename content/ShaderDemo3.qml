import QtQuick 2.0
//import CustomComponents 1.0
import "../settings.js" as Settings
Rectangle {
    id: shader3Container

    property real ballSize: Settings.playerSize
    property real obstacle1Size: Settings.obstacleSize
    property real obstacle2Size: Settings.obstacleSize
    property real goodySize: Settings.goodySize
    property int points: 0
    property int errors:0
    property bool gameOver: false
    property bool obs1Alive: true
    property bool obs2Alive: true
    property bool goodyAlive: true
    //enabled: _gameEngine.gameOn
    property bool active:false;
    Image {
        id: backgroundImage
        source: "images/background-space4.jpg"
        anchors.fill: parent
        fillMode: Image.Stretch
    }
    // Info Text

    Text{
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 15
        text:"DEMO3\nTime: "+(60-Math.round(timer.timePlayed/4)).toString()
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

    Frame{
        anchors.centerIn: shader3Container
        width: parent.width
        height: 200
        visible:false
        z:1000
        id: gameOverText
        Text{
            anchors.centerIn: gameOverText
            text:gameOver==true?"Oh my little sith-lord\nGame Over!":"The dark side of the force was with you\nYou win!"
            font.pixelSize: 60
            color: "black"
            font.bold: true
        }

    }

    function newGame(){
        timer.timePlayed= 0
        errors= 0
        points=0
        timer.loopCounter= 0
        timer.collDetect=0
        timer.goodyCath=0
        ballSize = Settings.playerSize
        obstacle1Size = Settings.obstacleSize
        obstacle2Size = Settings.obstacleSize
        obs1Alive=true
        obs2Alive=true
        goodyAlive=true
        ballItem1.x=50
        ballItem1.y=50
        active=true
        gameOverText.visible=false
        shader3Container.state="game"
        gameOver=false
    }

    function setGameOver(){
        active=false
        shader3Container.state="gameOver"
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

            // BLACK HOLE DEMO
            // Kill the others

            // check game over - too long played- Win - all obstacles killed
            if(timer.timePlayed/4>60)
            {
                shader3Container.gameOver=true
                shader3Container.setGameOver()
                return;
            }

            if(!goodyAlive&&!obs1Alive&&!obs2Alive)
                shader3Container.setGameOver()

            // kill balls
            if(goodySize<5)
                goodyAlive=false
            if(obstacle1Size<5)
                obs1Alive=false
            if(obstacle2Size<5)
                obs2Alive=false




            // check goody collision
            if(goodyAlive)
                if((timePlayed-goodyCath)>1)
                    if(shaderEffect.checkDistance(shaderEffect.goody1,goodySize)){
                        goodyCath=timePlayed;
                        goodySize=goodySize-5
                        points=points+1
                    }

            // check obstacle collision
            if(obs1Alive)
                if((timePlayed-collDetect)>1)
                    if(shaderEffect.checkDistance(shaderEffect.obstacle1,obstacle1Size))
                    {
                        collDetect=timePlayed
                        obstacle1Size=obstacle1Size-7
                        points=points+1
                    }

            if(obs2Alive)
                if((timePlayed-collDetect)>1)
                    if(shaderEffect.checkDistance(shaderEffect.obstacle2,obstacle2Size))
                    {
                        collDetect=timePlayed
                        obstacle2Size=obstacle2Size-7
                        points=points+1
                    }

            // count time
            if(loopCounter==10){        // counts in 250ms
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
        //visible: !_gameEngine.trackingEnable
    }

    Ball {
        id: ballItem1
        x: ballSize; y: shader3Container.height/2-ballSize

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

                if(ballItem1.x + ballSize/2+dX < shader3Container.width && ballItem1.x +ballSize/2 + dX > 0)    // correctur: center not in ball middle
                    ballItem1.x = ballItem1.x + dX
            }

            // check if up or down
            if(dY >=0){
                if(dY < rangeY/2)
                    dY = (rangeY/2-dY)*(-1)                // down; else up
                else dY = dY-rangeY/2
                // error with bottom collision
                if(ballItem1.y-ballSize/2 + dY < shader3Container.height && ballItem1.y +ballSize/2+ dY > 0)                   // correctur: center not in ball middle
                    ballItem1.y = ballItem1.y + dY
            }
        }
    }

    Ball {
        id: ballItem2
        x: shader3Container.width * 0.7; y: 100
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
        property alias ballSize: shader3Container.ballSize
        property alias goodySize: shader3Container.goodySize
        property alias obstacle1Size: shader3Container.obstacle1Size
        property alias obstacle2Size: shader3Container.obstacle2Size
        property variant obstacle1: Qt.point(animX1, animY1)
        property variant obstacle2: Qt.point(shader3Container.width-animX1, shader3Container.height-animY1+120)
        property variant obstacle3: Qt.point(shader3Container.width-animX1, shader3Container.height-animY1+120)
        property variant obstacle4: Qt.point(shader3Container.width-animX1, shader3Container.height-animY1+120)
        property variant goody1: Qt.point(animX2, animY2)
        property variant ball1: Qt.point(ballItem1.x+ballSize/2, (shader3Container.height - ballItem1.y+ballSize/2))
        property variant ball2: Qt.point(ballItem2.x, (shader3Container.height - ballItem2.y))
        property bool collision: ballItem1.collision
        property bool obs1Alive: shader3Container.obs1Alive
        property bool obs2Alive: shader3Container.obs2Alive
        property bool goodyAlive: shader3Container.goodyAlive
        //property int startX:
        //property int startY:
        id: shaderEffect
        anchors.fill: backgroundImage
        // obstacle movement
        SequentialAnimation on animY1{
            loops: Animation.Infinite
            running: active
            NumberAnimation { to: shader3Container.height/2; duration: 5000; easing.type: Easing.OutQuad }
            NumberAnimation { to: 120; duration: 5000; easing.type: Easing.OutBounce }
        }
        SequentialAnimation on animX1 {
            loops: Animation.Infinite
            running: active
            NumberAnimation { to: shader3Container.width/2-ballSize; duration:5000; easing.type: Easing.InOutExpo }
            NumberAnimation { to: 120; duration: 5000; easing.type: Easing.InElastic
            }
        }
        // goody movement
        SequentialAnimation on animY2{
            loops: Animation.Infinite
            running: active
            NumberAnimation { to: shader3Container.height-goodySize-Settings.headerHeight; duration: 5000; easing.type: Easing.InElastic }
            //PauseAnimation {duration: 500}
            NumberAnimation { to: 120; duration: 5000; easing.type: Easing.SineCurve }

        }
        SequentialAnimation on animX2 {
            loops: Animation.Infinite
            running: active
            NumberAnimation { to: shader3Container.width-goodySize; duration: 3000; easing.type: Easing.Linear }
            NumberAnimation { to: goodySize; duration: 3000; easing.type: Easing.Linear
            }
        }

        NumberAnimation on movementX{

        }

        function checkDistance(pos,checkSize){  // pos from other object + size
            // bigball animation has its own coordinate sysem -> left bottom 0,0
            var dist = Math.sqrt(Math.pow(Math.abs(ballItem1.x-pos.x),2)+Math.pow(Math.abs(shader3Container.height-pos.y-ballItem1.y),2))
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
                        uniform lowp float obstacle1Size;
                        uniform lowp float obstacle2Size;
                        uniform lowp float goodySize;
                        uniform lowp float shining;
                        uniform lowp bool obs1Alive;
                        uniform lowp bool obs2Alive;
                        uniform lowp bool goodyAlive;
                        void main() {

                            lowp vec4 pixelColor = vec4(0.1, 0.6, 0.8, 0.3);
                            lowp vec4 obs1Color = vec4(-0.8, 0.8, 0.1, 1.0);
                            lowp vec4 obs2Color = vec4(.8, 0.5, -0.1, 1.0);
                            lowp vec4 goodyColor = vec4(0.9, 0.95, 1.0, 1.0);

                            lowp vec4 playerColor = vec4(-0.09, -0.6, -0.9, 1.0);

                            // obstacles
                            highp vec2 dist = obstacle1 - gl_FragCoord.xy;
                            highp float val = obstacle1Size*obstacle1Size / (dist.x * dist.x + dist.y * dist.y);
                            if(obs1Alive)
                                pixelColor += obs1Color * val;

                            if(obs2Alive){
                                dist = obstacle2 - gl_FragCoord.xy;
                                val = obstacle2Size*obstacle2Size / (dist.x * dist.x + dist.y * dist.y);
                                pixelColor += obs2Color * val;
                            }

                            // goodies
                            if(goodyAlive){
                                dist = goody1 - gl_FragCoord.xy;
                                val = goodySize*goodySize / (dist.x * dist.x + dist.y * dist.y);
                                pixelColor += goodyColor * val;
                            }

                            // Player
                            dist = ball1 - gl_FragCoord.xy;
                            val = (ballSize*ballSize) / (dist.x * dist.x + dist.y * dist.y);
                            pixelColor += playerColor * val;

                            highp float a = smoothstep(1.0 - shining, 1.0, pixelColor.a);
                            gl_FragColor = vec4(pixelColor.rgb * a, 0.0);
                        }":""
    }
}
