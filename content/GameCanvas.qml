import QtQuick 2.0

Item {
    width: 100
    height: 62
    property int squareSize: 64
    property int rows: 6
    property int cols: 4
    property Item canvas: grid
    property int score: 0
    property int coins: 100
    property int lives: 3



   /* function freshState() {
        lives = 3
        coins = 100
        score = 0
        waveNumber = 0
        waveProgress = 0
        gameOver = false
        gameRunning = false
        towerMenu.shown = false
        helpButton.comeBack();
    }
    Timer {
        interval: 16
        running: true
        repeat: true
        onTriggered: Logic.tick()
    }

*/


}
