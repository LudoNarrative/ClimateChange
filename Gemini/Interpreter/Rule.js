/*
 * Rule class, with subclasses Condition and Action
 */

function Rule () {

	var conditions = [];
	this.actions = [];
	this.allConditionsMet = false;

	// Categorization of each supported condition operation into a broad type
	var conditionTypeMap = 
		{
			"ge" 			: "comparison",
			"le" 			: "comparison",
			"overlaps" 		: "collision",
			"control_event" : "control",
			"timer_elapsed" : "timer",
			"tick" 			: "tick"
		};

	// Whether this condition type is checked by Interpeter (internal) or Driver (external)
	var conditionScopeMap = 
		{
			"comparison" : "internal",
			"collision"  : "external",
			"control"	 : "external",
			"timer"		 : "internal",
			"tick"		 : "internal"
		};

	function Condition (operation, args, text) {

		this.operation = operation; // e.g., 'ge', 'le', 'overlaps', ...
		this.type = conditionTypeMap[operation]; // e.g., 'comparison', 'collision', ...
		this.scope = conditionScopeMap[this.type]; // 'internal' or 'external'
		this.text = text; // raw text from the Cygnus file

		this.args = args; // Array of arguments to the operation
		
		this.conditionMet = false;

		var checkCondition = function (currentState) {

			//switch (this.operation) {
			//	case "ge" : 
			//		return getValue(this.args[0]) >= getValue(this.args[1]);
			//	case "le" : 
			//		return getValue(this.args[0]) <= getValue(this.args[1]);
			//}
			// return true or false	
		}
	
	}

	var addCondition = function (operation, args, text) {
		conditions.push(new Condition(operation, args, text));
	}

	return {
		addCondition : addCondition,
		conditions : conditions
	}

}