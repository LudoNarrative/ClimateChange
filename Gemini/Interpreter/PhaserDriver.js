/*
 * Interface between Interpreter and Phaser 
 */

var PhaserDriver = ( function () {

	var game;

	// var game = new Phaser.Game(500, 400, Phaser.AUTO, 'game', { preload: preload, create: create, update: update }, true);

	var config = {
	    type: Phaser.AUTO,
	    width: 500,
	    height: 400,
	    parent: 'game',
	};
	
	function init () {

		game = new Phaser.Game(config);
		game.state.add('Game', Game);
		game.state.start('Game');

	}

	// Main game state 
	var Game = { 

		preload : function () {

		},

		create : function () { 

			console.log("from within Phaser create()");
		},

		update : function () {

		}

	}

	return {
		init : init
	}

})();