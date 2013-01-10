QT       += quick
QT       += multimedia
HEADERS   = ellipseitem.h \
    sensor.h \
    serial.h \
    trackingSensor.h
RESOURCES = ex-signals.qrc
SOURCES   = main.cpp ellipseitem.cpp \
    sensor.cpp \
    serial.cpp \
    trackingSensor.cpp

# These next three lines makes the QML files show up in a section of their
# own in Qt Creator.
qml.files += $$files(*.qml)
qml.path = "."
INSTALLS += qml
QT+=serialport

OTHER_FILES += \
    content/Button.qml \
    content/InfoBar.qml \
    content/SerialButtonBar.qml \
    content/Sensor.qml \
    content/SensorBar.qml \
    content/Bullet.qml \
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
    content/Menu.qml
