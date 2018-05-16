function Collector () {

	var entities = {}, // An object whose keys are entity IDs and values are objects with entity info
		resources = {},
		pools = {}, // An object whose keys are pool names and values are each an array of subpools
		rules = {},
		state = {};

	// Getters
	function getEntities () { return entities; }
	function getResources () { return resources; }
	function getPools () { return pools; }
	function getRules () { return rules; }

	// Setters
	function registerEntity (entityID) {
		// If this entity has not been added to the entity symbol table, add it
		if (!entities.hasOwnProperty(entityID)) {
			entities[entityID] = new Entity();
		}
	}

	function registerResource (resourceID) {
		// If this resource has not been added to the resource symbol table, add it
		if (!resources.hasOwnProperty(resourceID)) {
			resources[resourceID] = new Resource();
		}
	}

	function registerPool (poolID) {
		// If this pool ID has not been added to the pool symbol table, add it
		if (!pools.hasOwnProperty(poolID)) {
			pools[poolID] = new Pool();
		}
	}

	function registerRule (ruleID) {
		if (!rules.hasOwnProperty(ruleID)) {
			rules[ruleID] = new Rule();
		}
	}

	function isBaseCase (actionArg) {
		switch (actionArg) {
			case "scalar": 
			case "bool": 
			case "WORD": 
				return true;
			default: 
				return false;
		}
	}

	// Recursively build an action
	// Return that complex action
	function createAction (operation, args) {

		//console.log("action:",operation);
		//args.forEach (function (arg) {
		//	if ( !isBaseCase(arg) ){
			//console.log("-arg:",arg);
		//});

		return new Action (operation,args);
	}

	function registerEntityProperty (entityID, propertyName, value) {
		entities[entityID][propertyName] = value;
	}

	function registerResourceProperty (resourceID, propertyName, value) {
		resources[resourceID][propertyName] = value;
	}

	function registerSubpool (poolID, row, col, locationType, withinType) {
		pools[poolID].addSubpool(row, col, locationType, withinType);
	}

	function registerCondition (ruleID, operation, args, text) {
		// expect args to be an array
		rules[ruleID].addCondition(operation, args, text);
	}

	function registerAction (operation, args, ruleID=null) {

		if (ruleID==null) {
			// This action is in an 'initialize' statement (no ruleID)
		}

	}

	return {
		getEntities : getEntities,
		getResources : getResources,
		getPools : getPools,
		getRules : getRules,

		registerEntity : registerEntity,
		registerResource : registerResource,
		registerPool : registerPool,
		registerRule : registerRule,
		createAction : createAction,

		registerEntityProperty : registerEntityProperty,
		registerResourceProperty : registerResourceProperty,
		registerSubpool : registerSubpool,
		registerCondition : registerCondition,

	}

}
