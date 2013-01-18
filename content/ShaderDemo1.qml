import QtQuick 2.0
//import CustomComponents 1.0
import "../settings.js" as Settings
Rectangle {
    id: shader1Container

    property real ballSize: Settings.playerSize
    property real obstacle1Size: Settings.obstacleSize
    property real obstacle2Size: Settings.obstacleSize
    property real goodySize: Settings.goodySize
    property int errors: 0
    property int points: 0
    property bool active:false
    property bool gameOver: false

    Image {
        id: backgroundImage
        source: "images/background-space.jpg"
        anchors.fill: parent
        fillMode: Image.Stretch
    }

    // Info Text
    Text{
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 15
        text:"DEMO1\nPoints: "+points.toString()+"\n"+
             "Time: "+((timer.timePlayed)/4).toString()+
             "\nLive: "+(Math.round(100-Settings.playerMinSize/ballSize*100)).toString()+
             "\nActive: "+active.toString()
        font.pixelSize: 27
        color: "white"
        font.bold: true
    }

    Text{
        z:1000
        id: gameOverText
        text:"Game Over"
        anchors.centerIn: parent
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
    }

    function gameOver(){
        active=false
        gameOverText.visible=true
    }

    // main timer - for updating
    Timer{
        id: timer
        interval: 25
        //timerOn: active
        running:active
        repeat:true
        property int loopCounter: 0
        property int collDetect:0
        property int obs1LastHit:0
        property int obs2LastHit:0
        property int goodyCath:0
        property int timePlayed:0
        property int helpTime:0     // counts time in 500ms values
        onTriggered:{

            // check goody collision
            if((timePlayed-goodyCath)>1)
            if(shaderEffect.checkDistance(shaderEffect.goody1,goodySize)){
                goodyCath=timePlayed;
                if(ballSize<100)
                    ballSize=ballSize*1.15
                points=points+1
            }

            // check bullet fire
            if((timePlayed-obs1LastHit)>2)
                if(shaderEffect.checkDistance2(shaderEffect.obstacle1,ballItem2,obstacle1Size,ballSize/2))
                {
                    obs1LastHit=timePlayed
                    points = points+1
                    obstacle1Size*0.9
                }
            if((timePlayed-obs2LastHit)>2)
                if(shaderEffect.checkDistance2(shaderEffect.obstacle2,ballItem2,obstacle2Size,ballSize/2))
                {
                    obs2LastHit=timePlayed
                    points=points+1
                    obstacle2Size*0.9
                }


            // check obstacle collision
            if((timePlayed-collDetect)>4)
                if(shaderEffect.checkDistance(shaderEffect.obstacle1,obstacleSize)
                        ||shaderEffect.checkDistance(shaderEffect.obstacle2,obstacleSize))
                {
                    collDetect=timePlayed
                    ballItem1.collision=true
                    errors=errors+1
                    ballSize=ballSize*0.75
                    // check game over - ball < originalsize/factor
                    if(ballSize<Settings.playerMinSize)
                        gameOver()
                }
                else
                    ballItem1.collision=false

            /*if(loopCounter == 20){       // 500ms
                helpTimee++
            }*/

            // count time
            if(loopCounter==10){           // counts in 500ms
                timePlayed++
                loopCounter=0
            }else
                loopCounter=loopCounter+1

            if((timePlayed/4)%5==0)            // obstacles  grow every 10s..
            {
                obstacle1Size=obstacle1Size*2
                obstacle2Size=obstacle2Size*2
            }


            // upadete movement in sensormode
            if(_gameEngine.trackingEnable){
                 ballItem1.controlWithSensor()
                 ballItem2.shoot();
            }
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
        x: 4; y: shader1Container.height/2-ballSize*2

        function controlWithSensor(){

            // dy(bottom sensor) - go up and down - direct position
            // dx(left sensor) - shoot ball if max val
            //var dX = _gameEngine.trackingSensor.sensorX.value//-offsetX
            //var rangeX = _gameEngine.trackingSensor.sensorX.maxValue-_gameEngine.trackingSensor.sensorX.minValue
            var dY = _gameEngine.trackingSensor.sensorY.value//-offsetY
            var rangeY = _gameEngine.trackingSensor.sensorY.maxValue-_gameEngine.trackingSensor.sensorY.minValue

            //var dZ = _gameEngine.trackingSensor.sensorZ.value// == offset ? 0 : _gameEngine.trackingSensor.// - offsetZ

            // map range value to 0 - height
            var mapYFactor = shader1Container.height/rangeY;
            //var mapXFactor = shader1Container.width/rangeX;
            if(dY>=0)
                ballItem1.y = dY*mapYFactor;
        }

        Behavior on y{
            NumberAnimation{duration:200}
        }

    }

    // Bullet
    Ball {
        id: ballItem2
        x: ballItem1.x; y: ballItem1.y
        //width:2*ballSize; height:2*ballSize;
        property bool shooting: false
        property int bulletSpeed: 100
        property int minSpeed: 1000

        function shoot(){
            var dX = _gameEngine.trackingSensor.sensorX.value
            var rangeX = _gameEngine.trackingSensor.sensorX.maxValue-_gameEngine.trackingSensor.sensorX.minValue - 1
            var factor = minSpeed/rangeX
            if(dX>0){
                shooting=true
                // set bullet speed
                bulletSpeed=minSpeed-rangeX*factor
            }
            else
                shooting=false
        }

        SequentialAnimation on x{
            loops: Animation.Infinite
            running: ballItem2.shooting
            NumberAnimation { to: shader1Container.width; duration: ballItem2.bulletSpeed; easing.type: Easing.Linear }
            NumberAnimation { to: 0; duration: 1; easing.type: Easing.Linear }
        }
      }


    ShaderEffect {

        property variant source: ShaderEffectSource { sourceItem: backgroundImage }
        property real animY1
        property real animX1
        property real animY2
        property real animX2
        property real movementX
        property alias shining: slider.value
        property alias ballSize: shader1Container.ballSize
        property alias goodySize: shader1Container.goodySize
        property alias obstacle1Size: shader1Container.obstacle1Size
        property alias obstacle2Size: shader1Container.obstacle2Size
        property variant obstacle1: Qt.point(animX1, animY1)
        property variant obstacle2: Qt.point(shader1Container.width-animX1, shader1Container.height-animY1+120)
        property variant obstacle3: Qt.point(shader1Container.width-animX1, shader1Container.height-animY1+120)
        property variant obstacle4: Qt.point(shader1Container.width-animX1, shader1Container.height-animY1+120)
        property variant goody1: Qt.point(animX2, animY2)
        property variant ball1: Qt.point(ballItem1.x+ballSize/2, (shader1Container.height - ballItem1.y+ballSize/2))
        property variant ball2: Qt.point(ballItem2.x, (shader1Container.height - ballItem2.y))
        property bool collision: ballItem1.collision
        property bool shooting: ballItem2.shooting
        //property int startX:
        //property int startY:
        id: shaderEffect
        anchors.fill: backgroundImage
        // obstacle movement
        SequentialAnimation on animY1{
            loops: Animation.Infinite
            running: active
            NumberAnimation { to: shader1Container.height/2; duration: 5000; easing.type: Easing.OutQuad }
            NumberAnimation { to: 120; duration: 3000; easing.type: Easing.OutBounce }
        }
        SequentialAnimation on animX1 {
            loops: Animation.Infinite
            running: active
            NumberAnimation { to: shader1Container.width/2-ballSize; duration:5000; easing.type: Easing.InOutExpo }
            NumberAnimation { to: 0; duration: 3000; easing.type: Easing.InElastic}
            NumberAnimation { to: shader1Container.width/4; duration:1000; easing.type: Easing.InBack }

        }
        // goody movement
        SequentialAnimation on animY2{
            loops: Animation.Infinite
            running:active
            NumberAnimation { to: shader1Container.height-goodySize-Settings.headerHeight; duration: 5000; easing.type: Easing.InElastic }
            //PauseAnimation {duration: 500}
            NumberAnimation { to: 120; duration: 5000; easing.type: Easing.SineCurve }

        }
        SequentialAnimation on animX2 {
            loops: Animation.Infinite
            running: active
            NumberAnimation { to: shader1Container.width-goodySize; duration: 3000; easing.type: Easing.Linear }
            NumberAnimation { to: goodySize; duration: 3000; easing.type: Easing.Linear
            }
        }

        function checkDistance2(pos1,pos2,checkSize1,checkSize2){
            var dist = Math.sqrt(Math.pow(Math.abs(pos1.x-pos2.x),2)+Math.pow(Math.abs(shader1Container.height-pos2.y-pos1.y),2))
            var hit = false
            if(dist < (checkSize1+checkSize2)*0.75){
                hit = true
            }
            return hit
        }

        function checkDistance(pos,checkSize){  // pos from other object + size
            // bigball animation has its own coordinate sysem -> left bottom 0,0
            var dist = Math.sqrt(Math.pow(Math.abs(ballItem1.x-pos.x),2)+Math.pow(Math.abs(shader1Container.height-pos.y-ballItem1.y),2))
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


        fragmentShader:active==true?
            " varying highp vec2 qt_TexCoord0;
                uniform lowp sampler2D source;
                uniform lowp float qt_Opacity;
                uniform highp vec2 obstacle1;
                uniform highp vec2 obstacle2;
                uniform highp vec2 goody1;
                uniform highp vec2 ball1;
                uniform highp vec2 ball2;
                uniform lowp bool shooting;
                uniform lowp float ballSize;
                uniform lowp float obstacle1Size;
                uniform lowp float obstacle2Size;
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
                    highp float val = obstacle1Size*obstacle1Size / (dist.x * dist.x + dist.y * dist.y);
                    pixelColor += obs1Color * val;

                    dist = obstacle2 - gl_FragCoord.xy;
                    val = obstacle2Size*obstacle2Size / (dist.x * dist.x + dist.y * dist.y);
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
                    if(shooting){
                        dist = ball2 - gl_FragCoord.xy;
                        val = (ballSize/2*ballSize/2) / (dist.x * dist.x + dist.y * dist.y);
                        pixelColor += playerColor * val;
                    }

                    highp float a = smoothstep(1.0 - shining, 1.0, pixelColor.a);
                    gl_FragColor = vec4(pixelColor.rgb * a, 0.0);
                }":""

    }
}
