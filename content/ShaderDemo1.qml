import QtQuick 2.0
import CustomComponents 1.0
import "logic.js" as Logic
import "../settings.js" as Settings
Rectangle {
    id: shaderContainer

    property real ballSize: Settings.playerSize
    property real obstacleSize: Settings.obstacleSize
    property real goodySize: Settings.goodySize
    enabled: _gameEngine.gameOn

    Image {
        id: backgroundImage
        source: "images/background-space2.jpg"
        anchors.fill: parent
        fillMode: Image.Stretch
    }

    // main timer - for updating
    Timer{
        id: timer
        interval: 25
        timerOn: _gameEngine.gameOn
        property int loopCounter: 0
        property int collDetect:0
        property int goodyCath:0
        onTimeout:{

            // check goody collision
            if((timePlayed-goodyCath)>1)
            if(shaderEffect.checkDistance(shaderEffect.goody1,goodySize)){
                goodyCath=root.timePlayed;
                if(ballSize<200)
                ballSize=ballSize*1.5
            }

            // check obstacle collision
            if((timePlayed-collDetect)>1)
                if(shaderEffect.checkDistance(shaderEffect.obstacle1,obstacleSize)
                        ||shaderEffect.checkDistance(shaderEffect.obstacle2,obstacleSize))
                {
                    collDetect=root.timePlayed
                    ballItem1.collision=true
                    root.errors=root.errors+1
                    ballSize=ballSize/2
                }
                else
                    ballItem1.collision=false

            // count time
            if(loopCounter==40){
                root.timePlayed++
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
            running: _gameEngine.gameOn
            NumberAnimation { to: shaderContainer.height/2; duration: 5000; easing.type: Easing.OutQuad }
            NumberAnimation { to: 120; duration: 5000; easing.type: Easing.OutBounce }
        }
        SequentialAnimation on animX1 {
            loops: Animation.Infinite
            running: _gameEngine.gameOn
            NumberAnimation { to: shaderContainer.width/2-ballSize; duration:5000; easing.type: Easing.InOutExpo }
            NumberAnimation { to: 120; duration: 5000; easing.type: Easing.InElastic
            }
        }
        // goody movement
        SequentialAnimation on animY2{
            loops: Animation.Infinite
            running: _gameEngine.gameOn
            NumberAnimation { to: shaderContainer.height-goodySize-Settings.headerHeight + Math.sin(root.timePlayed); duration: 5000; easing.type: Easing.InElastic }
            //PauseAnimation {duration: 500}
            NumberAnimation { to: 120; duration: 5000; easing.type: Easing.SineCurve }

        }
        SequentialAnimation on animX2 {
            loops: Animation.Infinite
            running: _gameEngine.gameOn
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

            /*console.debug("Nr: "+nr)
            console.debug("Distance: "+dist)
            console.debug("Hit: "+hit)
            console.debug("BallItem1.y: "+ballItem1.y)
            console.debug("BallBig.y: "+obstacle.y)
            console.debug("\n")
            */
            return hit
        }


        fragmentShader:
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
                }"

    }
}
