define(["Phaser", "StoryAssembler", "AspPhaserGenerator"], function(Phaser, StoryAssembler, AspPhaserGenerator) {

	var Display;
	var State;
/*
	Initializes the game
*/
var init = function(gameSpec, _State, _Display) {

	Display = _Display;
	State = _State;

	var useGamestring = false;

	var aspFilepath = gameSpec.aspFilepaths[Math.floor(Math.random()*gameSpec.aspFilepaths.length)];		//pick a random aspfile if there are 1+

	//var fs = require('fs');
	//var AspPhaserGenerator = require('asp-phaser-generator/index');
	/*
	All with generated- prefixes:
	Dinner: 2
	Worker: 3
	Travel: 5
	Lecture: 4
	*/
	//var aspGame = fs.readFileSync('./test/fixtures/asp-game-4.lp', 'utf8');
	var aspGame = "";
	var initialPhaserFile ="";

	jQuery.get(aspFilepath, function(data) {
    	aspGame = data;
    	jQuery.get('asp-phaser-generator/test/fixtures/initial-phaser-file-generated.json', function(data) {
    		initialPhaserFile = data;
    		_initGenerator();
		});
	});
	
	//var initialPhaserFile = fs.readFileSync('./test/fixtures/initial-phaser-file-generated.json', 'utf8');
	
	var _initGenerator = function(){
		var generator = AspPhaserGenerator.AspPhaserGenerator(aspGame, initialPhaserFile);
		var phaserProgram = AspPhaserGenerator.generate(generator.aspGame, generator.initialPhaser, true);

		console.log("\n------------------------------");
		console.log("Finished Phaser game:");
		console.log("------------------------------");
		console.log(phaserProgram);


		var gameInitString = "game = new Phaser.Game(400, 300, Phaser.AUTO, 'gameContainer', { preload: preload, create: create, update: update }, false);";

		//var generatedGame = gameInitString + gameLogicStrings.filter(function(v) { return v.id === id; })[0].gameString;

		var gameCode;				//use the string or the generated program, based on the flag
		if (useGamestring) { gameCode = gameSpec.gameString; }
		else { gameCode = phaserProgram; }

		var generatedGame = gameInitString + gameCode;

		eval(generatedGame);
		console.log(getAspGoals());

	}
	

	// game = new Phaser.Game(400, 300, Phaser.AUTO, 'gameContainer', { preload: preload, create: create, update: update }, false);

}

return {
	init : init
}

});



//how does game broadcast to the narrative system?
//how does the narrative broadcast to the game?
	//-there's a member function of the gameLogicString that handles it
