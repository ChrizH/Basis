import QtQuick 2.0
import "../settings.js" as Settings
import "logic.js" as Logic
Item {
    id: container
    z: 2

    // MenuHeader
    Frame{
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        Text{
            id: header
            y: Settings.headerHeight
            text: "3D Tracking\nMENU"
            font.bold: true
            font.pixelSize: 26
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Frame{
            width: parent.width*0.75
            height: parent.height*0.5
            anchors.centerIn: parent

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#ffffff" }
                GradientStop { position: 1.0; color: "#eeeeee" }
            }

            Column{
                id: optionContainer
                //width: parent.width
                //y: Settings.headerHeight + 100
                anchors.topMargin: 10
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
                                _gameEngine.setTrackingEnable(true)
                            else
                                _gameEngine.setTrackingEnable(false)
                        }
                    }
                }

                // options for 3DTracking = off
                Column{
                        spacing: Settings.menuButtonSpacing

                        id: trackingOffOptions
                        Text{
                             text: "Game Controlling with Mouse"
                        }
                        Text{
                             text: "Drag and drop the ball.. "
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
                            spacing: Settings.menuButtonSpacing*2
                            Button{
                                label: "Check ComPort"
                                onClicked: _gameEngine.trackingSensor.setupConnection()
                            }
                            Image{
                                visible: _gameEngine.trackingSensor.comportAvailable==true?true:false
                                source: "images/Check-icon.png"
                                width: 30; height: 30
                                fillMode: Image.Stretch
                            }
                        }

                        Row{
                            spacing: Settings.menuButtonSpacing*2
                            Button{
                                visible: _gameEngine.trackingSensor.comportAvailable
                                label: _gameEngine.trackingSensor.connectionAvailable==false?"Open Connection":"close Connection";
                                onClicked:{
                                    if(!_gameEngine.trackingSensor.connectionAvailable)
                                        _gameEngine.trackingSensor.openConnection()
                                    else
                                        _gameEngine.trackingSensor.closeConnection()
                                }
                            }
                            Image{
                                visible: _gameEngine.trackingSensor.connectionAvailable==true?true:false;
                                source: "images/Check-icon.png"
                                width: 30; height: 30
                                fillMode: Image.Stretch
                            }
                        }

                        //Row{
                          //  spacing: Settings.menuButtonSpacing
                            Button{
                                visible: _gameEngine.trackingSensor.connectionAvailable
                                label: _gameEngine.trackingSensor.calibrating==false?"Start Calibrating":"Stop Calibrating"
                                onClicked:{
                                    _gameEngine.trackingSensor.setCalibrating(!_gameEngine.trackingSensor.calibrating);

                                    if(!_gameEngine.trackingSensor.calibrating){
                                        _gameEngine.trackingSensor.sensorX.assignCalibration();
                                        _gameEngine.trackingSensor.sensorY.assignCalibration();
                                        _gameEngine.trackingSensor.sensorZ.assignCalibration();
                                        _gameEngine.trackingSensor.showCalResults();
                                    }
                                }
                           // }
                           /* Button{
                                label: "Stop Calibrating"
                                onClicked: {_gameEngine.trackingSensor.setCalibrating(false);

                                }
                            }*/
                        }

                   }




                move: Transition {
                      NumberAnimation { properties: "x,y"; duration: 500 }
                }

               }
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
