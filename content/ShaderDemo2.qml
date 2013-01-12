import QtQuick 2.0
import CustomComponents 1.0
Rectangle {
    id: shaderContainer

    property real ballSize: 50
    enabled: _gameEngine.gameOn
    //width: 640
    //height: 360

    Image {
        id: backgroundImage
        source: "images/background2.png"
        anchors.fill: parent
    }

    Timer{
        id: timer
        interval: 100
        timerOn: _gameEngine.gameOn
        onTimeout:{
            if(shaderEffect.checkDistance(shaderEffect.obstacle1,1)||shaderEffect.checkDistance(shaderEffect.obstacle2,2))
                ballItem1.alive=false
            else
                ballItem1.alive=true
            //ifshaderEffect.checkDistance(shaderEffect.obstacle2,2)
        }
    }


    Slider {
        id: slider
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        width: parent.width
        minimum: 0.1
        value: 0.55
        maximum: 1.0
        text: "<<<  Adjust Shining  >>>"
    }

    Ball {
        id: ballItem1
        x: shaderContainer.width * 0.3; y: 100
    }

    Ball {
        id: ballItem2
        x: shaderContainer.width * 0.7; y: 100
    }




    ShaderEffect {
        property variant source: ShaderEffectSource { sourceItem: backgroundImage }
        property real animY
        property real animX
        property alias shining: slider.value
        property alias ballSize: shaderContainer.ballSize
        property variant obstacle1: Qt.point(animX, animY)
        property variant obstacle2: Qt.point(shaderContainer.width-animX, shaderContainer.height-animY+120)
        property variant ball1: Qt.point(ballItem1.x, (shaderContainer.height - ballItem1.y))
        property variant ball2: Qt.point(ballItem2.x, (shaderContainer.height - ballItem2.y))
        property bool alive: ballItem1.alive

        //property int startX:
        //property int startY:
        id: shaderEffect
        anchors.fill: backgroundImage

        SequentialAnimation on animY {
            loops: Animation.Infinite
            NumberAnimation { to: shaderContainer.height/2; duration: 1000; easing.type: Easing.OutQuad }
            NumberAnimation { to: 120; duration: 3000; easing.type: Easing.OutBounce }
        }
        SequentialAnimation on animX {
            loops: Animation.Infinite
            NumberAnimation { to: shaderContainer.width/2-ballSize; duration: 3000; easing.type: Easing.InOutElastic }
            NumberAnimation { to: 120; duration: 3000; easing.type: Easing.InOutSine
            }
        }
        function checkDistance(obstacle,nr){
            // bigball animation has its own coordinate sysem -> left bottom 0,0
            var dist = Math.sqrt(Math.pow(Math.abs(ballItem1.x-obstacle.x),2)+Math.pow(Math.abs(shaderContainer.height-obstacle.y-ballItem1.y),2))
            var hit = false
            if(dist < shaderContainer.ballSize*1.3){
                hit = true
            }

            console.debug("Nr: "+nr)
            console.debug("Distance: "+dist)
            console.debug("Hit: "+hit)
            console.debug("BallItem1.y: "+ballItem1.y)
            console.debug("BallBig.y: "+obstacle.y)
            console.debug("\n")

            return hit
        }

        fragmentShader: //{
            //_gameEngine.gameOn==true ? "
             "  varying highp vec2 qt_TexCoord0;
                uniform lowp sampler2D source;
                uniform lowp float qt_Opacity;
                uniform highp vec2 obstacle1;
                uniform highp vec2 obstacle2;
                uniform highp vec2 ball1;
                uniform highp vec2 ball2;
                uniform lowp float ballSize;
                uniform lowp float shining;
                uniform lowp bool alive;
                void main() {
                    lowp vec4 pixelColor = vec4(0.0, 0.0, 0.0, 0.0);
                    lowp vec4 obs1Color = vec4(1.0, 0.0, 0.8, 1.0);
                    lowp vec4 obs2Color = vec4(1.0, 1.0, 0.0, 1.0);
                    lowp vec4 color2 = vec4(1.0, 0.5, 1.0, 1.0);

                    // obstacles
                    highp vec2 obs1Dist = obstacle1 - gl_FragCoord.xy;
                    highp float val = 12000.0 / (obs1Dist.x * obs1Dist.x + obs1Dist.y * obs1Dist.y);
                    pixelColor += obs1Color * val;

                    highp vec2 obs2Dist = obstacle2 - gl_FragCoord.xy;
                    val = 8000.0 / (obs2Dist.x * obs2Dist.x + obs2Dist.y * obs2Dist.y);
                    pixelColor += obs2Color * val;

                    // player balls
                    if(!alive){     // change color if player hit obstacle1
                        color2 = vec4(1.0,0.0,0.0,1.0);
                    }

                    highp vec2 dist = ball1 - gl_FragCoord.xy;
                    val = (ballSize*ballSize) / (dist.x * dist.x + dist.y * dist.y);
                    pixelColor += color2 * val;

                    dist = ball2 - gl_FragCoord.xy;
                    val = (ballSize*ballSize) / (dist.x * dist.x + dist.y * dist.y);
                    pixelColor += color2 * val;

                    highp float a = smoothstep(1.0 - shining, 1.0, pixelColor.a);
                    gl_FragColor = vec4(pixelColor.rgb * a, 0.0);
                }"
            //}
    }
}
