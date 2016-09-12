/* Implements a Character module for StoryAssembler.

A character is a person in the story being assembled (player or NPC). We use the standard State module to store character info: this module just provides a convenience wrapper around getting/setting character info.
*/

define([], function() {

	var State;
	var characters = {}; // For each key, an array of IDs: all properties associated with this character.

	var init = function(_State) {
		State = _State;
	}

	var add = function(key, charDef) {
		/*
		if (characters[key]) {			//if the char was already read in, return undefined
			return undefined;
		}
		var charFields = [];
		for (var defKey in charDef) {
			State.set(stateKey(key, defKey), charDef[defKey]);
			charFields.push(defKey);
		}
		characters[key] = charFields;
		return get(key);
		*/
		var temp = State.get("characters");
		if (typeof temp == "undefined") {
			temp = [];
		}
		temp.push(charDef);
		State.set("characters", temp);
	}

	var remove = function(key) {
		if (!characters[key]) return;
		characters[key].forEach(function(defKey) {
			State.remove(stateKey(key, defKey));
		});
		delete characters[key];
	}

	var set = function(key, statsObj) {
		if (!characters[key]) {
			throw new Error("Tried to set stats for character '" + key + "' but no such character was found.");
		}
		for (var statsKey in statsObj) {
			if (characters[key].indexOf(statsKey) < 0) {
				characters[key].push(statsKey);
			}
			var parts = statsObj[statsKey].split(" ");
			var op = parts[0].trim();
			var val = parts[1].trim();
			State.change(op + " " + stateKey(key, statsKey) + " " + val);
		}
	}

	var get = function(key, stat) {
		if (!characters[key]) {
			return undefined;
		}
		if (!stat) {
			var charObj = {}
			charObj.id = key;
			characters[key].forEach(function(defKey) {
				charObj[defKey] = State.get(stateKey(key, defKey));
			});
			return charObj;
		} else {
			return State.get(stateKey(key, stat));
		}
	}

	var getAllIds = function() {
		return Object.keys(characters);
	}

	var stateKey = function(charId, key) {
		return charId + "_" + key;
	}

	//this returns the character id that matches the discourse pattern (dialogue, etc)
	//if rLevel is passed in, will run some times 
	var getBestSpeaker = function(currentSpeaker, rLevel) {
		var storyMode = State.get("mode");
		var bestSpeaker;
		var iterNum = (rLevel === undefined) ? 1 : rLevel+1;

		if (typeof currentSpeaker == "undefined") { bestSpeaker = storyMode.initiator; }
		else {
			var tempCurrentSpeaker = currentSpeaker;
			for (var x=0; x < iterNum; x++) {
				switch (storyMode.type) {
					case "narration" : 		//nothing needed
					break;
					case "monologue" : 		//set back to initiator if we get off track
					bestSpeaker = storyMode.initiator;		
					break;
					case "dialogue": 		//alternate between initiator and responder
						if (tempCurrentSpeaker == storyMode.initiator) { bestSpeaker = storyMode.responder; tempCurrentSpeaker = storyMode.responder }
						else { bestSpeaker = storyMode.initiator; tempCurrentSpeaker = storyMode.initiator; }
					break;
				}
			}
			bestSpeaker = tempCurrentSpeaker;
		}
		return bestSpeaker;
	}


	// Public interface for Character module.
	return {
		init: init,
		add: add,
		remove: remove,
		set: set,
		get: get,
		getAllIds: getAllIds,
		getBestSpeaker: getBestSpeaker

	}
});	