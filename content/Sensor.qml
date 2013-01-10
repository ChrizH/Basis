import QtQuick 2.0
import QtMultimedia 5.0
Rectangle {
    width: 60
    property int value
    property int offset
    property string grColor
    property string soundSource

    height: 50 + value//+ (value<0 ? 0 : (value - offset)*2)
    gradient: Gradient {
        GradientStop {
            position: 0.00;
            color: grColor
        }
        GradientStop {
            position: 1.00;
            color: "#ffffff";
        }
    }

   /* Audio{
        id: audio
        source:soundSource
        volume: 1.0
        autoPlay:true
    }
    MouseArea{
        id: playArea
        anchors.fill: parent
        onPressed: {audio.play()}
    }*/
}
