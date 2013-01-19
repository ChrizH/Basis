QT       += quick
QT       += multimedia
QT      += opengl
HEADERS   = \
    sensor.h \
    serial.h \
    trackingSensor.h \
    game.h \
    timer.h \
    moveable.h
RESOURCES = ex-signals.qrc
SOURCES   = main.cpp \
    sensor.cpp \
    serial.cpp \
    trackingSensor.cpp \
    game.cpp \
    timer.cpp \
    moveable.cpp

# These next three lines makes the QML files show up in a section of their
# own in Qt Creator.
qml.files += $$files(*.qml)
qml.path = "."
INSTALLS += qml
QT+=serialport

#QML_IMPORT_PATH = ~/opt/qt5_new/qt5/Box2D_v2.2.1

OTHER_FILES += \
    content/Button.qml \
    content/InfoBar.qml \
    content/SensorBar.qml \
    content/images/background.png \
    content/images/background-puzzle.png \
    content/images/bar.png \
    content/images/blue.png \
    content/images/but-game-new.png \
    content/images/but-menu.png \
    content/images/green.png \
    content/images/red.png \
    content/images/yellow.png \
    content/GameCanvas.qml \
    settings.js \
    content/Menu.qml \
    content/BottomBar.qml \
    content/Obstacle.qml \
    content/Slider.qml \
    content/Ball.qml \
    content/ShaderDemo2.qml \
    content/SmallSlider.qml \
    content/Frame.qml \
    content/SensorVisu.qml \
    content/ShaderDemo1.qml \
    content/logic.js \
    content/ShaderDemo3.qml
