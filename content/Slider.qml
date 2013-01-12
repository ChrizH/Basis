import QtQuick 2.0

Item {
    id: slider
    width: 200
    height: 48
    z:10
    property real value: 0
    property real maximum: 1
    property real minimum: 0
    property int xMax: width - handle.width - 4
    property alias text: sliderText.text

    onValueChanged: updatePos();
    onXMaxChanged: updatePos();
    onMinimumChanged: updatePos();

    function updatePos() {
        if (maximum > minimum) {
            var pos = 2 + (value - minimum) * slider.xMax / (maximum - minimum);
            pos = Math.min(pos, width - handle.width - 2);
            pos = Math.max(pos, 2);
            handle.x = pos;
        } else {
            handle.x = 2;
        }
    }

    Rectangle {
        anchors.fill: parent
        border.width: 1
        border.color: "white"
        opacity: 0.2
        gradient: Gradient {
            GradientStop { position: 0.0; color: "lightgray" }
            GradientStop { position: 1.0; color: "gray" }
        }
    }

    Rectangle {
        id: filler
        anchors.left: parent.left
        anchors.right: handle.horizontalCenter
        y: 2;
        height: slider.height-4
        border.width: 1
        border.color: "white"
        gradient: Gradient {
            GradientStop { position: 0.0; color: "yellow" }
            GradientStop { position: 1.0; color: "gray" }
        }
    }

    Image {
        id: handle
        source: "images/handle.png"
        anchors.verticalCenter: parent.verticalCenter
        MouseArea {
            anchors.fill: parent
            drag.target: parent
            drag.axis: Drag.XAxis
            drag.minimumX: 2
            drag.maximumX: slider.xMax+2
            onPositionChanged: {
                value = (maximum - minimum) * (handle.x-2) / slider.xMax + minimum;
            }
        }
    }

    Text {
        id: sliderText
        anchors.centerIn: parent
        font.pixelSize: 34
        style: Text.Outline
        styleColor: "white"
        color: "black"
    }
}
