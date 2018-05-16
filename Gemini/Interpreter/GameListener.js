/*
 * Custom listener which inherits and overrides the Antlr-generated listener, CygnusListener.
 *
 */

const antlr4 = require('antlr4/index');
const CygnusParser = require('./CygnusParser');
var CygnusListener = require('./CygnusListener').CygnusListener;
  
var GameListener = function (data) {
	this.data = data;
    CygnusListener.call(this); // inherit default listener
    return this;
};
 
// inherit default listener
GameListener.prototype = Object.create(CygnusListener.prototype);
GameListener.prototype.constructor = GameListener;
 
// override default listener behavior

// Enter a parse tree produced by CygnusParser#game.
GameListener.prototype.enterGame = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#game.
GameListener.prototype.exitGame = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#declaration.
GameListener.prototype.enterDeclaration = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#declaration.
GameListener.prototype.exitDeclaration = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#comment_section.
GameListener.prototype.enterComment_section = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#comment_section.
GameListener.prototype.exitComment_section = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#separator.
GameListener.prototype.enterSeparator = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#separator.
GameListener.prototype.exitSeparator = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#entity.
GameListener.prototype.enterEntity = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#entity.
GameListener.prototype.exitEntity = function(ctx) {

	// If this entity has not been added to the entity symbol table, add it
	this.data.registerEntity(ctx.identifier().getText());
	
};


// Enter a parse tree produced by CygnusParser#resource.
GameListener.prototype.enterResource = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#resource.
GameListener.prototype.exitResource = function(ctx) {

	// If this resource has not been added to the resource symbol table, add it
	this.data.registerResource(ctx.identifier().getText());
};


// Enter a parse tree produced by CygnusParser#flag.
GameListener.prototype.enterFlag = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#flag.
GameListener.prototype.exitFlag = function(ctx) {

	// If this flag has not been added to the flag symbol table, add it
	
};


// Enter a parse tree produced by CygnusParser#timer.
GameListener.prototype.enterTimer = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#timer.
GameListener.prototype.exitTimer = function(ctx) {

	// If this timer has not been added to the timer symbol table, add it
	
};


// Enter a parse tree produced by CygnusParser#property.
GameListener.prototype.enterProperty = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#property.
GameListener.prototype.exitProperty = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#label.
GameListener.prototype.enterLabel = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#label.
GameListener.prototype.exitLabel = function(ctx) {

	var labelName = ctx.label_name().getText();	

	// A label can be for a resource or an entity
	if (ctx.resource() !== null) {
		var resourceID = ctx.resource().identifier().getText();
		var privacy = ctx.privacy_mode().getText();
		this.data.registerResourceProperty(resourceID, "label", labelName);
		this.data.registerResourceProperty(resourceID, "privacy", privacy);

	} else if (ctx.entity() !== null) {
		var entityID = ctx.entity().identifier().getText();
		this.data.registerEntityProperty(entityID, "label", labelName);
	}

};


// Enter a parse tree produced by CygnusParser#singular.
GameListener.prototype.enterSingular = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#singular.
GameListener.prototype.exitSingular = function(ctx) {

	// Register the given entity as 'many'=false
	var entityID = ctx.entity().identifier().getText();
	this.data.registerEntityProperty(entityID,"many",false);

};


// Enter a parse tree produced by CygnusParser#many.
GameListener.prototype.enterMany = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#many.
GameListener.prototype.exitMany = function(ctx) {

	// Register the given entity as 'many'=true
	var entityID = ctx.entity().identifier().getText();
	this.data.registerEntityProperty(entityID,"many",true);

};


// Enter a parse tree produced by CygnusParser#boundary.
GameListener.prototype.enterBoundary = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#boundary.
GameListener.prototype.exitBoundary = function(ctx) {

	// Register the game's boundary type (currently either 'closed' or 'torus')

};


// Enter a parse tree produced by CygnusParser#control_logic.
GameListener.prototype.enterControl_logic = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#control_logic.
GameListener.prototype.exitControl_logic = function(ctx) {

	// (Redundant with initialize(set_draggable(..)). Will be removed from Cygnus eventually)

};


// Enter a parse tree produced by CygnusParser#timer_logic.
GameListener.prototype.enterTimer_logic = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#timer_logic.
GameListener.prototype.exitTimer_logic = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#initialize.
GameListener.prototype.enterInitialize = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#initialize.
GameListener.prototype.exitInitialize = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#precondition.
GameListener.prototype.enterPrecondition = function(ctx) {

	var outcome_name = ctx.outcome_name();
	var ruleID;

	// Save the rule identifier ('tick' is a special case,
	// since it doesn't have an 'identifier' child)
	if (outcome_name.getText() == 'tick') {
		ruleID = 'tick';
	} else if (outcome_name.identifier() !== null) {
		ruleID = outcome_name.identifier().getText();
	}

	// Add rule to rules symbol table
	this.data.registerRule(ruleID);
};

// Exit a parse tree produced by CygnusParser#precondition.
GameListener.prototype.exitPrecondition = function(ctx) {

	// Save the context of the 'condition' child of 'precondition' 
	var cond_ctx = ctx.condition();

	// Collect relevant data about a condition to register with the Collector:
	// the name of the condition operation
	// the raw text from the Cygnus file
	// arguments to the condition operation (vary by operation)

	var condition = cond_ctx.getChild(0).getText();
	var text = cond_ctx.getText();
	var args = [];

	switch (condition) {

		case "ge" : 
		case "le" : 
			args.push(cond_ctx.value(0).getText());
			args.push(cond_ctx.value(1).getText());
			break;

		case "overlaps" :
			args.push(cond_ctx.entity(0).getText());
			args.push(cond_ctx.entity(1).getText());
			args.push(cond_ctx.bool().getText());
			break;

		case "control_event" : 
			// Could be either 'click(entity)' or 'button(button,button_state)'

			var control_predicate_ctx = cond_ctx.control_event();
			var control_predicate_name = cond_ctx.control_event().getChild(0).getText();

			if (control_predicate_name == "click") {
				args.push(control_predicate_ctx.entity().getText());

			} else if (control_predicate_name == "button") {
				args.push(control_predicate_ctx.button().getText());
				args.push(control_predicate_ctx.button_state().getText());
			}

			break;

		case "timer_elapsed" :

			// The third child is either the nonterminal 'timer' or nonterminal 'identifier'
			args.push(cond_ctx.getChild(2).getText());
			break;

		case "tick" :
			// Tick has no arguments
			break;
	}

	// Register condition and its arguments if it isn't the "tick" rule
	// (Don't need to save any conditions for "tick")
	if (condition !== "tick") {

		var ruleID = ctx.outcome_name().identifier().getText();
		this.data.registerCondition(ruleID, condition, args, text);
	
	}
};


// Enter a parse tree produced by CygnusParser#result.
GameListener.prototype.enterResult = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#result.
GameListener.prototype.exitResult = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#label_name.
GameListener.prototype.enterLabel_name = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#label_name.
GameListener.prototype.exitLabel_name = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#outcome_name.
GameListener.prototype.enterOutcome_name = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#outcome_name.
GameListener.prototype.exitOutcome_name = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#identifier.
GameListener.prototype.enterIdentifier = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#identifier.
GameListener.prototype.exitIdentifier = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#condition.
GameListener.prototype.enterCondition = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#condition.
GameListener.prototype.exitCondition = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#initial_only_action.
GameListener.prototype.enterInitial_only_action = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#initial_only_action.
GameListener.prototype.exitInitial_only_action = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#action.
GameListener.prototype.enterAction = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#action.
GameListener.prototype.exitAction = function(ctx) {

	// Similarly to precondition, collect relevant data about the action
	// to register with the Collector:
	// - the name of the action
	// - the raw text from the Cygnus file
	// - arguments to the action operation (vary by operation)

	// TODO: Construct a custom ctx.action object 
	
	var action = ctx.getChild(0).getText();
	var text = ctx.getText();
	var args = [];

	// The parent node predicate name is either "initialize" or "result"
	var parent = ctx.parentCtx.getChild(0).getText();
	var isInInitialize = (parent == "initialize");

	switch (action) { 

		case "add":
			break;

		case "delete":
			break;

		case "draw":
			break;

		case "clear":
			break;

		case "fill":
			break;

		case "increase":
			break;

		case "decrease":
			break;

		case "increase_over_time":
			break;

		case "decrease_over_time":
			break;

		case "set_value":

			// Children: settable, value
			// The single child of settable is either resource or property
			
			var moreSpecificAction = "",
				args = [];

			if (ctx.settable().resource() !== null) {

				// Setting the value of a resource: 2 args (resourceID, get_value Action object)
				moreSpecificAction = "set_resource_value"; 
				args[0] = ctx.settable().resource().identifier().getText();
			
			} else if (ctx.settable().property() !== null) {

				// Setting the value of a property: 3 args (entityID, propertyName, get_value Action object)
				moreSpecificAction = "set_property_value"; 
				args[0] = ctx.settable().property().entity().identifier().getText();
				args[1] = ctx.settable().property().identifier().getText();
			}

			// Value has already been populated by descendant nodes 
			var value = ctx.value().value;
			args.push(value);

			ctx.action = this.data.createAction(moreSpecificAction, args);
			console.log (ctx.action);

			if (isInInitialize) {

				//if (ctx.settable().resource !== null) {
				//	this.data.setResourceValue (resourceID, value);

				//} else if (ctx.settable().property() !== null) {
				//	this.data.setPropertyValue (entityID, propertyName, value);
				//}
				//this.data.registerResourceProperty(resourceID, "initialValue", value);
			}

			break;
		
		case "set_point":
			break;

		case "set_bool":
			break;

		case "moves":
			break;

		case "move_toward":
			break;

		case "move_away":
			break;

		case "set_acceleration":
			break;

		case "apply_restitution":
			break;

		case "rotates":
			break;

		case "rotate_to":
			break;

		case "look_at":
			break;

		case "set_sprite":
			break;

		case "set_color":
			break;

		case "set_size":
			break;

		case "set_bounce":
			break;

		case "set_draggable":
			break;

		case "set_static":
			break;

		case "mode_change":
			break;

	}

	//console.log("Action:",action);
};


// Enter a parse tree produced by CygnusParser#value.
GameListener.prototype.enterValue = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#value.
GameListener.prototype.exitValue = function(ctx) {

	// Value ctx has a single immediate child,
	// scalar, amount, distance, random_int, or settable.
	// Each one has a custom value property in their ctx,
	// which has been built up by their own listener funcs.
	// Add that as the argument for a new action, get_value.

	args = [ ctx.getChild(0).value ];

	ctx.value = this.data.createAction("get_value",args);
	//console.log("---value action:", ctx.valueAction);

};


// Enter a parse tree produced by CygnusParser#scalar.
GameListener.prototype.enterScalar = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#scalar.
GameListener.prototype.exitScalar = function(ctx) {

	// Add scalar integer value to a new property for this ctx
	// Convert scalar's NUM token from string to integer
	ctx.value = parseInt( ctx.NUM().getText() );
	
};

// Enter a parse tree produced by CygnusParser#amount.
CygnusListener.prototype.enterAmount = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#amount.
CygnusListener.prototype.exitAmount = function(ctx) {

	var args = [ ctx.getChild(2).getText() ];
	ctx.value = this.data.createAction("amount",args);

};


// Enter a parse tree produced by CygnusParser#distance.
CygnusListener.prototype.enterDistance = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#distance.
CygnusListener.prototype.exitDistance = function(ctx) {

	// Arguments for 'distance' operation
	// e.g., ['e_1_XX_', 'e_2_XX_', 'nearest']
	var args = [ 
		ctx.entity(0).identifier().getText(), 
		ctx.entity(1).identifier().getText(), 
		ctx.look_criterion().getText()
	];
	
	ctx.value = this.data.createAction("distance",args);

};


// Enter a parse tree produced by CygnusParser#random_int.
CygnusListener.prototype.enterRandom_int = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#random_int.
CygnusListener.prototype.exitRandom_int = function(ctx) {

	// Arguments for 'random_int' operation. E.g., [0,360]
	var args = [ 
		ctx.scalar(0).value,
		ctx.scalar(1).value
	];
	
	ctx.value = this.data.createAction("random_int",args);
};

// Enter a parse tree produced by CygnusParser#settable.
GameListener.prototype.enterSettable = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#settable.
GameListener.prototype.exitSettable = function(ctx) {

	// Settable could either be used as a value or a reference
	// (something to set something else's value, or something which itself is being set)
	// ctx.value is used for the former case, and ctx.reference for the latter

	// Could also be a resource or an entity property

	var isResource = ( ctx.getChild(0) instanceof CygnusParser.CygnusParser.ResourceContext );
	var isProperty = ( ctx.getChild(0) instanceof CygnusParser.CygnusParser.PropertyContext );

	if (isResource) {

		var resourceID = ctx.resource().identifier().getText();		
		ctx.value = this.data.createAction("get_resource_value",[resourceID]);

	} else if (isProperty) {

		var entityID = ctx.property().entity().identifier().getText();
		var propertyName = ctx.property().identifier().getText();

		ctx.value = this.data.createAction("get_property_value",[entityID, propertyName]);

	}
	//ctx.reference = 

};


// Enter a parse tree produced by CygnusParser#settable_point.
GameListener.prototype.enterSettable_point = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#settable_point.
GameListener.prototype.exitSettable_point = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#settable_bool.
GameListener.prototype.enterSettable_bool = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#settable_bool.
GameListener.prototype.exitSettable_bool = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#point.
GameListener.prototype.enterPoint = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#point.
GameListener.prototype.exitPoint = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#bool.
GameListener.prototype.enterBool = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#bool.
GameListener.prototype.exitBool = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#location.
GameListener.prototype.enterLocation = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#location.
GameListener.prototype.exitLocation = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#pool_decl.
CygnusListener.prototype.enterPool_decl = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#pool_decl.
CygnusListener.prototype.exitPool_decl = function(ctx) {

	var poolID = ctx.pool_name().getText();
	var row = ctx.location().row().getText();
	var col = ctx.location().col().getText();
	var locationType = ctx.spawn_type(0).getText();
	var withinType = ctx.spawn_type(1).getText();

	this.data.registerPool (poolID);
	this.data.registerSubpool (poolID,row,col,locationType,withinType);

};


// Enter a parse tree produced by CygnusParser#pool.
CygnusListener.prototype.enterPool = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#pool.
CygnusListener.prototype.exitPool = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#pool_name.
CygnusListener.prototype.enterPool_name = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#pool_name.
CygnusListener.prototype.exitPool_name = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#control_event.
GameListener.prototype.enterControl_event = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#control_event.
GameListener.prototype.exitControl_event = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#privacy_mode.
GameListener.prototype.enterPrivacy_mode = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#privacy_mode.
GameListener.prototype.exitPrivacy_mode = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#boundary_type.
GameListener.prototype.enterBoundary_type = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#boundary_type.
GameListener.prototype.exitBoundary_type = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#look_criterion.
GameListener.prototype.enterLook_criterion = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#look_criterion.
GameListener.prototype.exitLook_criterion = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#spawn_type.
GameListener.prototype.enterSpawn_type = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#spawn_type.
GameListener.prototype.exitSpawn_type = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#loop_type.
GameListener.prototype.enterLoop_type = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#loop_type.
GameListener.prototype.exitLoop_type = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#direction.
GameListener.prototype.enterDirection = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#direction.
GameListener.prototype.exitDirection = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#row.
GameListener.prototype.enterRow = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#row.
GameListener.prototype.exitRow = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#col.
GameListener.prototype.enterCol = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#col.
GameListener.prototype.exitCol = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#angular_direction.
GameListener.prototype.enterAngular_direction = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#angular_direction.
GameListener.prototype.exitAngular_direction = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#button.
GameListener.prototype.enterButton = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#button.
GameListener.prototype.exitButton = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#button_state.
GameListener.prototype.enterButton_state = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#button_state.
GameListener.prototype.exitButton_state = function(ctx) {
};


// Enter a parse tree produced by CygnusParser#reading.
GameListener.prototype.enterReading = function(ctx) {
};

// Exit a parse tree produced by CygnusParser#reading.
GameListener.prototype.exitReading = function(ctx) {
};



exports.GameListener = GameListener;
