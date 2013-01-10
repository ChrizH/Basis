//![0]
import QtQuick 2.0
import "../settings.js" as Settings
Item {
    id: toggleswitch
    width: Settings.toolButtonWidth; height: Settings.toolButtonHeight

    property int knobXPos1: 1
    property int knobXPos2: Settings.toolButtonWidth - knob.width

    property bool on: false

    function toggle() {
        if (toggleswitch.state == "on")
            toggleswitch.state = "off";
        else
            toggleswitch.state = "on";
    }

    function releaseSwitch() {
        if (knob.x == knobXPos1) {
            if (toggleswitch.state == "off") return;
        }
        if (knob.x == knobXPos2) {
            if (toggleswitch.state == "on") return;
        }
        toggle();
    }

    Image {
        id: background
        width: parent.width; height: parent.height
        fillMode:Image.Stretch
        source: "images/switch-background.png"
        MouseArea { anchors.fill: parent; onClicked: toggle() }
    }
//![4]

//![5]
    Image {
        id: knob
        x: 1;y:-3
        source: "images/knob.png"
        fillMode: Image.Stretch
        scale: 0.7
        MouseArea {
            anchors.fill: parent
            drag.target: knob; drag.axis: Drag.XAxis; drag.minimumX: knobXPos1; drag.maximumX: knobXPos2
            onClicked: toggle()
            onReleased: releaseSwitch()
        }
    }
//![5]

//![6]
    states: [
        State {
            name: "on"
            PropertyChanges { target: knob; x: knobXPos2 }
            PropertyChanges { target: toggleswitch; on: true }
        },
        State {
            name: "off"
            PropertyChanges { target: knob; x: knobXPos1 }
            PropertyChanges { target: toggleswitch; on: false }
        }
    ]
//![6]

//![7]
    transitions: Transition {
        NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 200 }
    }
//![7]
}
//![0]
