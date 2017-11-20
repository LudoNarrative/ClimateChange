define(["Phaser", "StoryAssembler", "AspPhaserGenerator"], function(Phaser, StoryAssembler, AspPhaserGenerator) {

	var Display;
	var State;
	var Coordinator;
	var gameIndex = -999
/*
	Initializes the game
*/
    var init = function(gameSpec, _State, _Display, _Coordinator,increment=true) {

		Display = _Display;
		State = _State;
		Coordinator = _Coordinator;

		var useGamestring = false;		//if true, will use the gameString variable in the gameSpec as the game code to eval
		var aspFilepath;
		if(gameIndex === -999){
			gameIndex = Math.floor(Math.random()*gameSpec.aspFilepaths.length);
			//aspFilepath = gameSpec.aspFilepaths[Math.floor(Math.random()*gameSpec.aspFilepaths.length)];		//pick a random aspfile if there are 1+
		}
		aspFilepath = gameSpec.aspFilepaths[gameIndex];
		console.log("PICKING GAME FILE: " , aspFilepath);
		console.log("PICKING GAME INDEX: " , gameIndex);

	    //increment game index for next roll out.
	    if (increment){
	    gameIndex += 1;
	}
	
		if(gameIndex >= gameSpec.aspFilepaths.length){
			gameIndex = 0;
		}
		


		//var fs = require('fs');
		//var AspPhaserGenerator = require('asp-phaser-generator/index');

		//var aspGame = fs.readFileSync('./test/fixtures/asp-game-4.lp', 'utf8');
		var aspGame = "";
		var aspGameInstructions = "";
		var initialPhaserFile ="";

		jQuery.get(aspFilepath, function(data) {
	    	aspGame = data.split("==========")[0];
	    	aspGameInstructions = iconParse(data.split("==========")[1]);

	    	jQuery.get('asp-phaser-generator-2/test/fixtures/initial-phaser-file.json', function(data2) {
	    		initialPhaserFile = data2;
	    		runGenerator(gameSpec, aspGame, aspGameInstructions, initialPhaserFile, useGamestring);
	    		if (document.getElementById("gameDiagnostics") == null) {
	    			Display.addGameDiagnostics(gameSpec, aspFilepath, aspGame, initialPhaserFile);		//create game diagnostics
	    		}
			});
		});

		//var initialPhaserFile = fs.readFileSync('./test/fixtures/initial-phaser-file-generated.json', 'utf8');

	}

	//parses icons for entities in the game into their respective shapes / colors
	var iconParse = function(rawString) {
		var newString = rawString;
		if (typeof newString !== "undefined") {
			while (newString.indexOf("[[") > -1) {
				var start = newString.indexOf("[[");
				var end = newString.substring(start, newString.length).indexOf("]]") + start;
				var icon = newString.substring(start+2,end);
				var theImg = icon.split("|")[1];
				var theColor = icon.split("|")[0];

				var replacement = "<div class='descIcon "+ theColor +"' style=\"-webkit-mask-box-image: url('assets/sprites/"+ theImg +".png')\"></div>";
				newString = newString.replace(newString.substring(start,end+2), replacement);
			}
		}
		else { newString == ""; }
		return newString;
	}

	var runGenerator = function(gameSpec, aspGame, aspGameInstructions, initialPhaserFile, useGamestring){
		var generator = AspPhaserGenerator.AspPhaserGenerator(aspGame, initialPhaserFile);
		var phaserProgram = AspPhaserGenerator.generate(generator.aspGame, generator.initialPhaser, true);

		console.log("\n------------------------------");
		console.log("Finished Phaser game:");
		console.log("------------------------------");
		console.log(phaserProgram);

		if (typeof game !== "undefined") {			//if we're refreshing the game we need to clean up the old one
			game.destroy();
		}


		//var gameInitString = "game = new Phaser.Game(400, 300, Phaser.AUTO, 'gameContainer', { preload: preload, create: create, update: update }, false);";
		var gameInitString = "game = new Phaser.Game(600, 400, Phaser.AUTO, 'gameContainer', { preload: preload, create: create, update: update }, true);";

		//var generatedGame = gameInitString + gameLogicStrings.filter(function(v) { return v.id === id; })[0].gameString;

		var gameCode;				//use the string or the generated program, based on the flag
		if (useGamestring) { gameCode = gameSpec.gameString; }
		else { gameCode = phaserProgram; }

		var generatedGame = gameInitString + gameCode;

		eval(generatedGame);

		if (document.getElementById("gameInstructions") == null) {
			$('<div/>', {
			    id: 'gameInstructions',
			    html: aspGameInstructions
			}).appendTo('#gameContainer');
		}
		else { 
			$("#gameInstructions").html(aspGameInstructions); 
		}

	    if (document.getElementById("restartGame") == null) {
		$('<div/>', {
		    id: 'restartGame',
		    text: 'Restart'
		}).click(function() { 
		    Coordinator.startGame(State.get("currentScene"),false);
		}).appendTo('#gameContainer');
	    }
	    if (document.getElementById("rerollGame") == null) {
		$('<div/>', {
		    id: 'rerollGame',
		    text: 'Reroll'
		}).click(function() { 
		    Coordinator.startGame(State.get("currentScene"));
		}).appendTo('#gameContainer');
	    }
	    if (document.getElementById("disableGame") == null) {
		$('<div/>', {
		    id: 'disableGame',
		    text: 'Disable'
		}).click(function() { 
		    game.destroy();
		    $("#gameContainer").hide();
		}).appendTo('#gameContainer');
	    }
	    
		//console.log(getAspGoals());
	}
    
    return {
	init : init,
	runGenerator : runGenerator
    }
    
});



//how does game broadcast to the narrative system?
//how does the narrative broadcast to the game?
	//-there's a member function of the gameLogicString that handles it
