import QtQuick 2.0
import CustomComponents 1.0
//import Box2D 2.2
Rectangle {
    id: mainView

    property real ballSize: 50

    width: parent.width
    height: parent.height

    Image {
        id: backgroundImage
        source: "images/background.png"
        anchors.fill: parent
        fillMode: Image.Stretch
    }

    Timer{
        id: timer
        interval: 100

        onTimeout:{
            shadereffect.checkDistance()
        }
    }

    Text {
        id: textLabel
        text: "Metaballs!"
        style: Text.Outline
        color: "white"
        anchors.centerIn: parent
        font.pixelSize: 48
        z: 10
    }

    Slider {
        z:10
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
        x: mainView.width * 0.3; y: 100

    }

    Ball {
        id: ballItem2
        x: mainView.width * 0.7; y: 100
    }


    ShaderEffect {
        property variant source: ShaderEffectSource { sourceItem: backgroundImage }
        blending:false
        anchors.fill: backgroundImage
        id: shadereffect
        SequentialAnimation on anim {
            loops: Animation.Infinite
            NumberAnimation { to: 300; duration: 1000; easing.type: Easing.OutCurve}//Easing.OutQuad }
            NumberAnimation { to: 80; duration: 3000; easing.type: Easing.OutBounce }
        }

        function checkDistance(){
            // bigball animation has its own coordinate sysem -> left bottom 0,0
            var dist = Math.sqrt(Math.pow(Math.abs(ballItem1.x-ballBig.x),2)+Math.pow(Math.abs(mainView.height-ballBig.y-ballItem1.y),2))

            console.debug("Distance: "+dist)
            console.debug("BallItem1.y: "+ballItem1.y)
            console.debug("BallBig.y: "+ballBig.y)
            console.debug("\n")

            if(dist < mainView.ballSize){

                ballItem1.alive=false
                ballItem1.visible=false
            }
        }

        property real anim
        property alias shining: slider.value
        property alias ballSize: mainView.ballSize
        property variant ballBig: Qt.point(mainView.width/2, anim)
        property variant ball1: Qt.point(ballItem1.x, (mainView.height - ballItem1.y))
        property variant ball2: Qt.point(ballItem2.x, (mainView.height - ballItem2.y))
        property bool alive: ballItem1.alive
        fragmentShader: "
        varying highp vec2 qt_TexCoord0;
        uniform lowp sampler2D source;
        uniform lowp float qt_Opacity;
        uniform highp vec2 ballBig;
        uniform highp vec2 ball1;
        uniform highp vec2 ball2;
        uniform lowp float ballSize;
        uniform lowp float shining;
        uniform lowp bool alive;

        void main() {
            lowp vec4 pixelColor = vec4(0.0, 0.0, 0.0, 0.0);
            lowp vec4 color = vec4(1.0, 0.5, 0.0, 1.0);     // bigball color
            lowp vec4 color2 = vec4(0.0, 0.75, 0.0, 1.0);    // small ball

            highp vec2 dist = ballBig - gl_FragCoord.xy;
            highp float val = 8000.0 / (dist.x * dist.x + dist.y * dist.y);
            pixelColor += color * val;

            if(alive){
                dist = ball1 - gl_FragCoord.xy;
                val = (ballSize*ballSize) / (dist.x * dist.x + dist.y * dist.y);
                pixelColor += color2 * val;
            }
            dist = ball2 - gl_FragCoord.xy;
            val = (ballSize*ballSize) / (dist.x * dist.x + dist.y * dist.y);
            pixelColor += color2 * val;

            highp float a = smoothstep(1.0 - shining, 1.0, pixelColor.a);
            gl_FragColor = vec4(pixelColor.rgb * a, 1.0);
        }
            "
    }
}
