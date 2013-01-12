.pragma library // shared game state

var trackingEnabled = true;

var states = {
    "RUNNING" : 0,
    "MENU" : 1,
    "PAUSE": 2
};

var gameState = states.MENU;
function seTrackingEnabled(value){trackingEnabled = value;}
function getTrackingEnabled(){return trackingEnabled;}
function getGameState() {return gameState;}
//function setGameState(Object state){gameState = state;}

var obstacleComponent = Qt.createComponent("Obstacle.qml");
var obstacles = [];
var game;
function startGame(gameCanvas){
     game = gameCanvas

    //obstacles = new Array()
    var obstacle = obstacleComponent.createObject()

}



// move the shit
function tick(){

}
