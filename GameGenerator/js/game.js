define(["Phaser", "StoryAssembler", "AspPhaserGenerator"], function(Phaser, StoryAssembler, AspPhaserGenerator) {

	var Display;
	var State;
	var Coordinator;
	var gameIndex = -999
/*
	Initializes the game
		-introGame: whether this is being called to show the game in the introduction screen
*/
    var init = function(gameSpec, _State, _Display, _Coordinator,increment=true, introGame=false) {

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

	    	jQuery.get('asp-phaser-generator-2/src/initial-phaser-file.json', function(data2) {
	    		initialPhaserFile = data2;
	    		runGenerator(gameSpec, aspGame, aspGameInstructions, initialPhaserFile, useGamestring, introGame);
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

	var runGenerator = function(gameSpec, aspGame, aspGameInstructions, initialPhaserFile, useGamestring, introGame){
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
		var gameContainer;
		if (introGame) { gameContainer = "introGame"; }
		else { gameContainer = "gameContainer"; }
		var gameInitString = "game = new Phaser.Game(600, 400, Phaser.AUTO, '"+ gameContainer +"', { preload: preload, create: create, update: update }, true);";

		//var generatedGame = gameInitString + gameLogicStrings.filter(function(v) { return v.id === id; })[0].gameString;

		var gameCode;				//use the string or the generated program, based on the flag
		if (useGamestring) { gameCode = gameSpec.gameString; }
		else { gameCode = phaserProgram; }

		var generatedGame = gameInitString + gameCode;

		eval(generatedGame);

		if (document.getElementById("gameInstructions") == null) {

			var theId;
			if (introGame) { theId = "introGameInstructions"; } else { theId = "gameInstructions"; }
			var appendDest;
			if (introGame) { appendDest = "#introGame"} else { appendDest = "#gameContainer"; }
			
			$('<div/>', {
			    id: theId,
			    html: parseInstructions(aspGameInstructions)
			}).appendTo(appendDest);

			if (introGame) { $("#introGameInstructions").html(parseInstructions(aspGameInstructions)); }
		}
		else { 
			$("#gameInstructions").html(aspGameInstructions); 
		}

		//create restart, reroll, and disable buttons
	    if (document.getElementById("restartGame") == null) {
			$('<div/>', {
			    id: 'restartGame',
			    text: 'Restart',
			    style: 'float:right; margin-left:10px'
			}).click(function() { Coordinator.startGame(State.get("currentScene"),false); }).appendTo('#gameControls');
	    }
	    if (document.getElementById("rerollGame") == null) {
			$('<div/>', {
			    id: 'rerollGame',
			    text: 'Reroll',
			    style: 'float:right; margin-left:10px'
			}).click(function() { Coordinator.startGame(State.get("currentScene")); }).appendTo('#gameControls');
	    }
	    if (document.getElementById("disableGame") == null) {
			$('<div/>', {
			    id: 'disableGame',
			    text: 'Disable',
			    style: 'float:right; margin-left:10px'
			}).click(function() { game.destroy(); $("#gameContainer").hide(); }).appendTo('#gameControls');
	    }
	    
		//console.log(getAspGoals());
	}

	//changes the instruction format exported from ASP into something more readable
	var parseInstructions = function(aspGameInstructions) {
		$('<div/>', {
			    id: "temp",
			    html: aspGameInstructions
			}).appendTo("body");

		var bullets = $("#temp ul li").toArray().slice(1);		//get bullets
		$("#temp").remove();


		var mode = "";
		var goals = [];
		var subGoals = [];
		var controls = [];
		for (var x=0; x < bullets.length; x++) {
			var category = bullets[x].innerText;
			if (category == "GOAL:") { mode = category; }
			else if (category.substring(0,9) == "SUBGOALS:") { mode = "SUBGOALS:"; }
			else if (category.substring(0,9) == "CONTROLS:") { mode = "CONTROLS:"; }

			else {
				var entry = bullets[x].innerHTML;
				switch (mode) {
					case "GOAL:":
						goals.push(entry);
						break;
					case "SUBGOALS:":
						subGoals.push(entry);
						break;
					case "CONTROLS:":
						controls.push(entry);
						break;
				}
			}
		}

		var instructions = "";

		if (goals.length > 0) {
			var goalLabel = "Goal: ";
			if (goals.length > 1) { goalLabel = "Goals:"; }
			var goalString = "";
			for (var x=0; x < goals.length; x++) { goalString+= goals[x] + ", "; }
			goalString = goalString.slice(0,-2);
			instructions += "<h2><strong>"+ goalLabel +"</strong><span style='font-weight:normal; color:white'> " + goalString + "</span></h2>";
		}
		
		if (subGoals.length > 0) {
			var subgoalString = "<h2>Sub-Goals: </h2><ul>";
			for (var x=0; x < subGoals.length; x++) { subgoalString+= "<li>" + subGoals[x] + "</li>"; }
			subgoalString += "</ul>";
			instructions += subgoalString;
		}
		
		if (controls.length > 0) {
			var controlString = "<h2>Controls: </h2><ul>";
			for (var x=0; x < controls.length; x++) { controlString+= "<li>" + controls[x] + "</li>";}
			controlString += "</ul>";
			instructions += controlString;
		}

		return instructions;		

	}
    
    return {
	init : init,
	runGenerator : runGenerator
    }
    
});



//how does game broadcast to the narrative system?
//how does the narrative broadcast to the game?
	//-there's a member function of the gameLogicString that handles it
