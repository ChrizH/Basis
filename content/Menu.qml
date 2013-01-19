import QtQuick 2.0
import "../settings.js" as Settings
import "logic.js" as Logic
Item {
    id: container
    z: 1000
    anchors.horizontalCenter: parent.horizontalCenter
    signal playDemo1()
    signal playDemo2()
    signal playDemo3()

    // MenuHeader
    Frame{
        id: mainFrame
        width: parent.width
        height: parent.height

        Text{
            id: header
            y: Settings.headerHeight
            text: "MENU"
            font.bold: true
            font.pixelSize: 26
            anchors.horizontalCenter: parent.horizontalCenter
        }
        /*Row{
            width: parent.width*0.9
            height: parent.height - header.height - Settings.menuButtonSpacing -Settings.headerHeight*1.5
            anchors.top: header.bottom
            anchors.topMargin: Settings.menuButtonSpacing
            anchors.horizontalCenter: mainFrame.horizontalCenter
            spacing: 20*/

            Frame{
                width: parent.width*0.45
                anchors.top: header.bottom
                anchors.topMargin: Settings.menuButtonSpacing*2
                anchors.left: mainFrame.left
                anchors.leftMargin: Settings.menuButtonSpacing*2
                anchors.bottom: mainFrame.bottom
                anchors.bottomMargin: Settings.menuButtonSpacing*2
                //height: children.height
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#ffffff" }
                    GradientStop { position: 1.0; color: "#eeeeee" }
                }
                Column{
                    y:Settings.menuButtonSpacing
                    anchors.topMargin: 10
                    spacing: Settings.menuButtonSpacing
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text{
                        text: "Choose a Demo"
                        font.bold: true
                        font.pixelSize: 26
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Row{
                        spacing: Settings.menuButtonSpacing
                        Text{
                            text:"Shoot em up!"
                        }

                        Button{
                            label:"Demo1"
                            anchors.verticalCenter: parent.verticalCenter
                            onClicked:{
                                container.playDemo1()
                                d2activ.visible=false
                                d1activ.visible=true
                                d3activ.visible=false
                            }
                        }
                        Image{
                            id: d1activ
                            visible: false

                            source: "images/Check-icon.png"
                            width: 30; height: 30
                            fillMode: Image.Stretch
                        }
                    }

                    Row{
                        spacing: Settings.menuButtonSpacing
                        Text{
                            text:"Catch the white\nBe carefull - the big!"
                        }
                        Button{
                            label:"Demo2"
                            anchors.verticalCenter: parent.verticalCenter
                            onClicked:{
                                container.playDemo2()
                                d2activ.visible=true
                                d1activ.visible=false
                                d3activ.visible=false
                            }
                        }
                        Image{
                            id: d2activ
                            anchors.verticalCenter: parent.verticalCenter
                            visible: false
                            source: "images/Check-icon.png"
                            width: 30; height: 30
                            fillMode: Image.Stretch
                        }
                    }

                    Row{
                        spacing: Settings.menuButtonSpacing
                        Text{
                            text:"Check the dark side of the force!"
                        }

                        Button{
                            label:"Demo3"
                            anchors.verticalCenter: parent.verticalCenter
                            onClicked:{
                                container.playDemo3()
                                d1activ.visible=false
                                d2activ.visible=false
                                d3activ.visible=true
                            }
                        }
                        Image{
                            id: d3activ
                            visible: false

                            source: "images/Check-icon.png"
                            width: 30; height: 30
                            fillMode: Image.Stretch
                        }
                    }
                }
            }


            Frame{
                width: parent.width*0.45
                anchors.top: header.bottom
                anchors.topMargin: Settings.menuButtonSpacing*2
                anchors.right: mainFrame.right
                anchors.rightMargin: Settings.menuButtonSpacing*2
                anchors.bottom: mainFrame.bottom
                anchors.bottomMargin: Settings.menuButtonSpacing*2
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#ffffff" }
                    GradientStop { position: 1.0; color: "#eeeeee" }
                }

                Column{
                    y:Settings.menuButtonSpacing
                    id: optionContainer
                    anchors.topMargin: 10
                    spacing: Settings.menuButtonSpacing
                    anchors.horizontalCenter: parent.horizontalCenter

                    Row{
                        spacing: Settings.menuButtonSpacing
                        Text{
                            text: "Touchless Sensor"
                            font.bold: true
                            font.pixelSize: 26
                        }

                        Button{
                            id: trackEnableButton
                            label: "Off"
                            anchors.verticalCenter: parent.verticalCenter
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
                                 text: "NOT IMPLEMENTED!!"
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
                                text: "Connect the sensor to the device."+
                                      "\n"+
                                      "\nConfigure each sensor and the touchless gameplay can begin!"+
                                      "\nLeft Sensor: x-Axis"+
                                      "\nRight Sensor: y-Axis"
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

                                Button{
                                    visible: _gameEngine.trackingSensor.connectionAvailable
                                    label: _gameEngine.trackingSensor.calibrating==false?"Start Calibrating":"Stop Calibrating"
                                    onClicked:{
                                        _gameEngine.trackingSensor.setCalibrating(!_gameEngine.trackingSensor.calibrating);
                                        calValues.visible = !calValues.visible
                                        if(!_gameEngine.trackingSensor.calibrating){
                                            _gameEngine.trackingSensor.sensorX.assignCalibration();
                                            _gameEngine.trackingSensor.sensorY.assignCalibration();
                                            _gameEngine.trackingSensor.sensorZ.assignCalibration();
                                            _gameEngine.trackingSensor.showCalResults();
                                        }
                                    }

                            }
                            // show cal values
                            Frame{
                                id: calValues
                                visible: false
                                height: 150
                                SensorBar{
                                    anchors.centerIn: parent
                                }
                            }

                       }




                    move: Transition {
                          NumberAnimation { properties: "x,y"; duration: 500 }
                    }

                   }
            }
        //}
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
