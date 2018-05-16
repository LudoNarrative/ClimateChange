/*
 * Interface between Interpreter and Phaser 
 */

var PhaserDriver = ( function () {

	var phaserGame;
	var gameData; // Data object populated by Interpreter and GameListener

	var previousState;
	var nextState;
	var driverConditions; // Conditions that the driver needs to check and return to Interpreter

	// var game = new Phaser.Game(500, 400, Phaser.AUTO, 'game', { preload: preload, create: create, update: update }, true);

	var config = {
	    type: Phaser.AUTO,
	    width: 500,
	    height: 400,
	    parent: 'game',
	};
	
	function init (data) {

		gameData = data;

		phaserGame = new Phaser.Game(config);
		phaserGame.state.add('Game', Game);
		phaserGame.state.start('Game');
	}

	// Main game state 
	var Game = { 

		preload : function () {

			// Load images and sounds
			phaserGame.load.image('circle','assets/sprites/circle.png');
			phaserGame.load.image('triangle','assets/sprites/triangle.png');
			phaserGame.load.image('square','assets/sprites/square.png');
			phaserGame.load.image('triangle','assets/sprites/triangle.png');
		
			phaserGame.load.audio('good_sound', 'assets/sounds/good.wav');
			phaserGame.load.audio('bad_sound', 'assets/sounds/bad.wav');

		},

		create : function () { 

			console.log("from within Phaser create()");
			console.log("Game entities:", gameData.getEntities());

		},

		update : function () {

			// Check external conditions 
			//checkExternalConditions(); 

			// Get updated state from the Interpeter
			// nextState = Interpreter.step (previousState, driverConditions)

		}

	}

	function checkExternalConditions () {

	}

	return {
		init : init
	}

})();