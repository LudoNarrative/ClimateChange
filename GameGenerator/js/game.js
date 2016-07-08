define(["Phaser"], function(Phaser) {

/*
	Initializes the game
*/
var init = function() {
	
var gameLogicString = "var low = 1;var r1 = low;var e1;var e2;function preload(){game.load.image('e1', 'images/pineapple.png');game.load.image('e2', 'images/pineapple.png');};function create(){e1 = game.add.sprite(126,147,'e1');e1.inputEnabled = true;e1.events.onInputDown.add(e1ClickListener, this);};function update(){};function render(){};function e1ClickListener(){r1=r1+low;};";

var gameInitString = "var game = new Phaser.Game(800, 600, Phaser.AUTO, '', { preload: preload, create: create });";

var generatedGame = gameLogicString + gameInitString;

eval(generatedGame);

	

}



return {
	init : init
}

});