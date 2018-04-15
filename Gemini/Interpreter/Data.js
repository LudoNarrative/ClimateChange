function Data () {

	var entities = {}, // An object whose keys are entity IDs and values are objects with entity info
		resources = {},
		pools = {}, // An object whose keys are pool names and values are each an array of subpools
		gameInfo = {};
		rules = {};

	var conditionMap = 
		{
			"ge" : "comparison",
			"le" : "comparison",
			"overlaps" : "collision",
			"control_event" : "control",
			"timer_elapsed" : "timer",
			"tick" : "tick"
		};

	// Constructors
	function Entity (label="", many=true) {
		this.label = label;
		this.many = many;
	}

	function Resource (label="", privacy="private", initialValue=0) {
		this.label = label;
		this.privacy = privacy;
		this.initialValue = initialValue;
	}

	function Pool () {
		this.subpools = [];
	}

	function Subpool (row, col, locationType, withinType) {
		this.row = row;
		this.col = col;
		this.locationType = locationType;
		this.withinType = withinType;
	}

	function Rule () {
		this.conditions = [];
		this.actions = [];

		this.allConditionsMet = false;
	}

	function Condition (operation, args, text) {
		this.operation = operation; 
		this.type = conditionMap[operation];
		this.text = text;

		this.args = args; // expect an array

		this.conditionMet = false;
	}

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

	function registerEntityProperty (entityID, propertyName, value) {
		entities[entityID][propertyName] = value;
	}

	function registerResourceProperty (resourceID, propertyName, value) {
		resources[resourceID][propertyName] = value;
	}

	function registerSubpool (poolID, row, col, locationType, withinType) {
		pools[poolID].subpools.push(new Subpool(row, col, locationType, withinType));
	}

	function registerCondition (ruleID, operation, args, text) {
		// expect args to be an array
		rules[ruleID].conditions.push(new Condition(operation, args, text));
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

		registerEntityProperty : registerEntityProperty,
		registerResourceProperty : registerResourceProperty,
		registerSubpool : registerSubpool,
		registerCondition : registerCondition
	}

}
