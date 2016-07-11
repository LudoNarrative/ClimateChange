define(["Phaser", "State"], function(Phaser, State) {

/*
	Initializes the game
*/
var init = function(id) {

	//some array with config info for each scene (that includes the ASP text)
	//do rensa to it

	var gameLogicString = "var variables={'confidence':'5','optimism':'2','difficulty':'3'};var low=1;var r1=low;var e1;var e2; var gridLinesHorizontal; var gridLinesVertical; var grid; var gridIdx; var gridSize; function preload(){game.load.image('e1','http://examples.phaser.io/assets/sprites/spinObj_03.png');game.load.image('e2','http://examples.phaser.io/assets/sprites/pineapple.png');};function create(){gridSize=30; gridLinesHorizontal=Math.floor((game.width-1)/gridSize); gridLinesVertical=Math.floor((game.height-1)/gridSize); grid=initGrid(); gridIdx=0;game.stage.backgroundColor = '#4488AA'; e1=addAtRandomPoint('e1');e1.inputEnabled=true;e1.scale.setTo(0.5,0.5);e1.events.onInputDown.add(e1ClickListener,this);};function update(){};function render(){};function e1ClickListener(){console.log('hallo');e2=addAtRandomPoint('e2');r1=r1+low;};function setVariable(varName,value){variables[varName]=value;State.set(varName, value);State.refreshNarrative();};function getVariable(varName){return variables[varName];};function getRandomPoint(){var x=game.rnd.integerInRange(0,game.width-1);console.log(x);var y=game.rnd.integerInRange(0,game.height-1);console.log(y);return new Phaser.Point(x,y);};function initGrid(){grid=[];for(var i=0;i<gridLinesHorizontal;i++){for(var j=0;j<gridLinesVertical;j++){grid.push(new Phaser.Point(i*gridSize,j*gridSize));}}shuffle(grid);return grid;};function addAtRandomPoint(sprite){var spawned=addAtPos(grid[gridIdx], sprite);gridIdx++;if(gridIdx===grid.length){gridIdx=0;shuffle(grid);}return spawned;};function addAtPos(point,sprite){return game.add.sprite(point.x,point.y,sprite);};function shuffle(a){var j,x,i;for(i=a.length;i;i--){j=Math.floor(Math.random()*i);x=a[i-1];a[i-1]=a[j];a[j]=x;}};";


	var gameInitString = "game = new Phaser.Game(400, 300, Phaser.AUTO, 'gameContainer', { preload: preload, create: create }, false);";

	var generatedGame = gameInitString + gameLogicString;

	eval(generatedGame);

/*	setStateValue() {
		State.set([varName], varValue);
	}
*/
}

return {
	init : init
}

});



//how does game broadcast to the narrative system?
//how does the narrative broadcast to the game?
	//-there's a member function of the gameLogicString that handles it
