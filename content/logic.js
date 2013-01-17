//.pragma library // shared game state

//var trackingEnabled = true;

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

var blockSize = 50
var component;
var maxColumn = 10;
var maxRow = 15;
var maxIndex = maxColumn * maxRow;
var board = new Array(maxIndex);
var created;

//Index function used instead of a 2D array
function index(column, row) {
    return column + (row * maxColumn);
}


function startGame(){
    //Delete blocks from previous game
        for (var i = 0; i < maxIndex; i++) {
            if (board[i] != null)
                board[i].destroy();
        }

        //Calculate board size
        maxColumn = Math.floor(gameCanvas.width / blockSize);
        maxRow = Math.floor(gameCanvas.height / blockSize);
        maxIndex = maxRow * maxColumn;

        //Initialize Board
        board = new Array(maxIndex);
        for (var column = 0; column < maxColumn; column++) {
            for (var row = 0; row < maxRow; row++) {
                board[index(column, row)] = null;
                //if(column%2==0&&row%3==0)
                createBlock(column, row);
            }
        }

        created=true;
        console.debug("create game: "+created)

}


function createBlock(column, row) {
    if (component == null)
        component = Qt.createComponent("Obstacle.qml");

    // Note that if Block.qml was not a local file, component.status would be
    // Loading and we should wait for the component's statusChanged() signal to
    // know when the file is downloaded and ready before calling createObject().
    if (component.status == Component.Ready) {
        var dynamicObject = component.createObject(gameCanvas,{"id": "obstacles"});
        if (dynamicObject == null) {
            console.log("error creating block");
            console.log(component.errorString());
            return false;
        }
        dynamicObject.x = column * blockSize;
        dynamicObject.y = row * blockSize;
        dynamicObject.width = blockSize;
        dynamicObject.height = blockSize;
        board[index(column, row)] = dynamicObject;
    } else {
        console.log("error loading block component");
        console.log(component.errorString());
        return false;
    }
    return true;
}



// move the shit
function tick(){
    // move all blocks
    console.debug("created: "+created)
    if(created)
       for (var column = 0; column < maxColumn; column++) {
           for (var row = 0; row < maxRow; row++) {
              if(board[index(column,row)]!==undefined){
                  console.debug("board[index("+column+","+row+").x: "+board[index(column,row)].x+"]")
                  board[index(column,row)].x=board[index(column,row)].x-1;
              }
           }
       }
}
