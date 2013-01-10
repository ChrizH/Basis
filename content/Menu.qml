import QtQuick 2.0
import "../settings.js" as Settings
import "logic.js" as Logic
Item {
    id: container
    z: 2
    // background image
    Image{
        source:"images/background.png"
        width: parent.width
        height: parent.height
        fillMode: Image.Tile
    }

    // MenuHeader
    Text{
        id: header
        y: Settings.headerHeight
        text: "3D Tracking\nMENU"
        font.bold: true
        font.pixelSize: 18
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Column{
        id: optionContainer
        y: Settings.headerHeight + 100
        spacing: Settings.menuButtonSpacing
        anchors.horizontalCenter: parent.horizontalCenter

        Row{
            spacing: Settings.menuButtonSpacing
            Text{
                text: "3D Tracking: "
            }

            Button{
                id: trackEnableButton
                label: "Off"
                onClicked:{
                    container.state == "trackingOn" ?
                                    container.state ="trackingOff" : container.state="trackingOn"
                    if(container.state == "trackingOn")
                        _trackingSensor.setTrackingEnable(true)
                    else
                        _trackingSensor.setTrackingEnable(false)
                }
            }

            /*Switch{
                id:controlSwitch
                on: false
            }
            Text{
                text: (controlSwitch.on == true ? "On" : "Off")
            }*/
        }

        // options for 3DTracking = off
            Column{
                spacing: Settings.menuButtonSpacing

                id: trackingOffOptions
                Text{
                     text: "Game Controlling with Keyboard"
                }
                Text{
                     text: "Use the arrow-keys for steering.. "
                }


            }

        // options for 3DTracking = off
            Column{
                id: trackingOnOptions
                spacing: Settings.menuButtonSpacing
                visible: false
                Text{
                    text: "Game Controlling with the 3D Sensor"
                }
                Text{
                    text: "Connect the sensor with your device and play!"
                }

                Row{
                    Text{
                        text:"Check if connection is available"
                    }

                    Button{
                        label: "Press"
                        onClicked: _trackingSensor.setupConnection()
                    }
                }

                Row{
                    Text{
                        text: "Open the connection"
                    }

                    Button{
                        label: "Press"
                        onClicked: _trackingSensor.openConnection()
                    }
                }

                Row{
                    Text{
                        text: "Closing connection"
                    }

                    Button{
                        label: "Press"
                        onClicked: _trackingSensor.closeConnection()
                    }
                }
           }

            move: Transition {
                  NumberAnimation { properties: "x,y"; duration: 500 }
            }



    }

    states:[
        State{
            name: "trackingOn"
            PropertyChanges{target: trackingOffOptions; visible:false}
            PropertyChanges{target: trackingOnOptions; visible:true}
            PropertyChanges{target: trackEnableButton; label: "On"}
        },
        State{
            name: "trackingOff"
            PropertyChanges{target: trackingOnOptions; visible:false}
            PropertyChanges{target: trackingOffOptions; visible:true}
            PropertyChanges{target: trackEnableButton; label: "Off"}
        }

    ]


}
