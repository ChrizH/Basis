import QtQuick 2.0
import Shapes 3.0
import "../settings.js" as Settings
Item {
    width: Settings.blocksize;height:Settings.blocksize
    id:container
    property real shaderShining
    property bool enable
    signal lot
    property Image parentImage
    property ShaderEffectSource shaderSource

    /*function setShaderSource(){
        var source = mapFromItem(gameContainer,shaderSource)
        shaderEffect.source=source
        //shaderEffect.source=sourceItem;
    }*/

    Image{
        id: image
        source:"images/red.png"
        width: parent.width; height:parent.height
        fillMode: Image.Stretch
    }
    ShaderEffect {
        id: shaderEffect
        property variant source:  ShaderEffectSource {sourceItem:image}
        blending: true
        anchors.fill: image
        property real anim
        //property alias shining: 0.55
        //property alias size: 50
        property variant pos: Qt.point(container.x,container.y)
        property bool enable: container.enable

        fragmentShader:"
            varying highp vec2 qt_TexCoord0;
            uniform lowp sampler2D source;
            uniform lowp float qt_Opacity;
            uniform highp vec2 pos;
            //uniform lowp float shining;
            float shining=0.55;
            //uniform lowp float size;
            float size=50.0;
            uniform lowp bool enable;

            void main(){
                lowp vec4 pixelColor = vec4(0.0, 0.0, 0.0, 0.0);
                lowp vec4 color = vec4(1.0, 0.5, 0.0, 1.0);

                highp vec2 dist = pos - gl_FragCoord.xy;
                highp float val = 8000.0 / (dist.x * dist.x + dist.y * dist.y);
                pixelColor += color * val;

                highp float a = smoothstep(1.0 - shining, 1.0, pixelColor.a);
                gl_FragColor = vec4(pixelColor.rgb * a, 1.0);

            }
        "
    }

}
