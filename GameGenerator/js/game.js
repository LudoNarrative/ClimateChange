define(["Phaser", "State"], function(Phaser, State) {

/*
	Initializes the game
*/
var init = function(id) {

	//some array with config info for each scene (that includes the ASP text)
	//do rensa to it
		
	var gameLogicString = "var low = 1;var r1 = low;var e1;var e2;function preload(){game.load.image('e1', 'assets/pineapple.png');game.load.image('e2', 'assets/pineapple.png');};function create(){e1 = game.add.sprite(126,147,'e1');e1.inputEnabled = true;e1.events.onInputDown.add(e1ClickListener, this);};function update(){};function render(){};function e1ClickListener(){r1=r1+low;};";


	var gameInitString = "game = new Phaser.Game('100', '100', Phaser.AUTO, 'gameContainer', { preload: preload, create: create }, false);";

	var generatedGame = gameLogicString + gameInitString;

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