/* Implements a Character module for StoryAssembler.

A character is a person in the story being assembled (player or NPC). We use the standard State module to store character info: this module just provides a convenience wrapper around getting/setting character info.
*/

define([], function() {

	var State;
	var characters = {}; // For each key, an array of IDs: all properties associated with this character.

	var init = function(_State) {
		State = _State;
	}

	var stateKey = function(charId, key) {
		return charId + "_" + key;
	}

	var add = function(key, charDef) {
		if (characters[key]) {
			return undefined;
		}
		var charFields = [];
		for (var defKey in charDef) {
			State.set(stateKey(key, defKey), charDef[defKey]);
			charFields.push(defKey);
		}
		characters[key] = charFields;
		return get(key);
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

	return {
		init: init,
		add: add,
		remove: remove,
		set: set,
		get: get,
		getAllIds: getAllIds

	}
});	