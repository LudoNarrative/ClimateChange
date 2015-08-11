/**
 * Copyright (c) 2015 Sarah Harmon
 *
 * This source code is free to use under the GNU General Public License (GPL) with author attribution.
 *
 **/

/*
 * Creates a Passage object.
 *
 * Parameters:
 	* Title: Passage name (String).
 	* Scene: Static text description of scene (String array - each element is a paragraph).
 	* Choices: List of choices for the passage (String array).
 */

(function() {

window.Passage = function(title,scene,choices){
	this.title = title;
	this.scene = scene;
	this.choices = choices;
};

Passage.prototype = {
	render:function(){
		// Make temporary arrays for scene and choices.
		// This will ensure that we do not overwrite coded variables.
		var scenes = this.scene.slice(0);

		var chs = new Choices([]);
		for (var j=0; j<this.choices.list.length;j++){
			chs.addChoice(this.choices.list[j].text,this.choices.list[j].link);
		}


		// Check for commands.
		for(k=0;k<scenes.length;k++){
			scenes[k] = check_commands(scenes[k]);
		}

		// Show scene description.
		document.getElementById("scene-description").innerHTML = scenes.join("<br><br>");

		// Clear choice points.
		document.getElementById("choice-points").innerHTML = "";

		// Add new choice points.
		var element = document.getElementById("choice-points");
		for (i=0; i<chs.list.length;i++){
			// Check for commands in the current choice point.
			chs.list[i].text = check_commands(chs.list[i].text);

			// Show choice point.
			element.innerHTML +=  "<p class='choice-point' id="+ chs.list[i].link + " onClick='click_choice(this.id)'>" + chs.list[i].text + "</p>";
		}
	}
}

/*
 * Creates a Choices object.
 *
 * Parameters
 	* List: all choices (Choice array).
 */

window.Choices = function(listOfChoices){
	this.list = listOfChoices;
}

Choices.prototype = {
	addChoice:function(text,link){
		var ch = new Choice();
		ch.text = text;
		ch.link = link;
		this.list.push(ch);
	}
}

/*
 * Creates a Choice object.
 *
 * Parameters:
 	* Text: text for a choice (String).
 	* Link: name of the passage the choice leads to (String).
 */

function Choice(text,link){
	this.text = text;
	this.link = link;
}

/*
 * When you click a choice, show the passage that follows.
 */
window.click_choice = function(chosenLink){
	// Clear choices shown on screen.
	document.getElementById("choice-points").innerHTML = "";

	// Display chosen passage.
	passages[chosenLink].render();
}

/*
 * Check for commands in scene description.
 */
function check_commands(text){
	// Make an array of all of the commands.
	var re = /\@@(.*?)\@@/g;
	var commands = text.match(re);

	if (commands){
		// For each command,
		for (var i=0; i<commands.length; i++){
			// Trim @@ marker on both sides.
			commands[i] = commands[i].slice(2,-2);

			// Act on the command, if it does not modify the surrounding text.
			follow_simple_command(commands[i]);
		}

		// If command was a request for a parameter value, state the value.
		text = text.replace(/\@@(get\s.*?)\@@/g, function(matched){
  			return store.get(matched.slice(6,-2));
		});

		// Process conditionals.
		text = text.replace(/\@@(if\s.*?)\endif@@/g, function(matched){
			return process_conditional(matched);
		});

		// Return text with commands removed.
		text = text.replace(re,"");
	}

	return text;
}

/*
 * Reads a string containing a command, and attempts
 * to follow the command, if the command is known.
 *
 * Currently handles:
 *	- @@set PARAM to VALUE@@: Sets a variable to a number or string.
 *  - @@incr PARAM@@: 	Increments a numeric variable by one.
 *  - @@incr PARAM x@@: Increments a numeric variable by x.
 *  - @@decr PARAM@@: 	Decrements a numeric variable by one.
 *  - @@decr PARAM x@@: Decrements a numeric variable by x.
 *  - @@mult PARAM x@@: Multiplies a numeric variable by x.
 */
function follow_simple_command(text){
	// If the command is setting a parameter, do so.
	if (~text.indexOf("set ")){
		// Determine parameter name.
		var findParam = get_var_name(text,"set",false);
		var paramName = findParam[0];

		// Determine parameter value.
		var value = findParam[1].slice(paramName.length+4);

		// Set parameter to value.
		// Value may be a float (number) or a String.
		if (isNumeric(value)){
			store.set(paramName, parseFloat(value));
		}
		else {
			store.set(paramName, value);
		}
	}
	else if (~text.indexOf("incr ")){
		perform_op(text,"incr")
	}
	else if (~text.indexOf("decr ")){
		perform_op(text,"decr")
	}
	else if(~text.indexOf("mult ")){
		perform_op(text,"mult");
	}
}

/*
 * Extracts and handles a conditional command.
 *
 * Currently handles:
 *  - @@if PARAM eq VALUE@@Write something.@@endif@@
 *  - @@if PARAM eq VALUE@@Write something.@@else@@Write something else.@@endif@@
 */
function process_conditional(cond){
	var replacement = ""; 	// We will replace the code with the text it specifies.
	var operator = "";  	// eq, geq, leq, gt, lt

	// Determine parameter name.
	var findParam = get_var_name(cond,"if",true);
	var param = findParam[0];

	// Determine operator.
	var findOp = get_var_name(findParam[1],param,false);
	var operator = findOp[0];

	// Handy variables for later reference:
	// 	- x is remaining command after finding the operator
	//  - y is the first space we find in x
	var x = findOp[1];
	var y = x.indexOf(" ");

	// Determine value.
	var z = x.indexOf("@@");
	var value = x.slice(y+1,z);

	// Check if the expression is true.
	isTrue = is_exp_true(param,operator,value);

	// If the conditional is true, write the first statement.
	if (isTrue){
		var g = x.indexOf("@@");
		var i = x.slice(g+2);
		var h = i.indexOf("@@");

		replacement = i.slice(0,h);
	}
	// If the conditional is not true,
	else{
		// If conditional contains else,
		var a = x.indexOf('@@else@@');
		if(~a){
			// ...write the statement corresponding with the else.
			var b = x.slice(a+8);
			var c = b.indexOf("@@endif@@");
			replacement=b.slice(0,c);
		}
	}
	return replacement;
}

/*
 * Extracts entity name from a command expression
 * (e.g., finds parameter and operator names).
 *
 * If codetag is true, assumes command includes '@@'
 * in the beginning.
 *
 */
function get_var_name(text, keyword, codetag){
	var tag = 0;
	if (codetag){
		tag = 2;
	}
	var keywordRemoved = text.slice(keyword.length+tag+1);
	var firstSpace = keywordRemoved.indexOf(" ");

	// If there is no first space, parameter is until end of string
	if (firstSpace==-1){
		firstSpace = keywordRemoved.length;
	}

	var paramName = keywordRemoved.slice(0, firstSpace);

	return [paramName,keywordRemoved];
}

/*
 * Performs basic operation (incr, decr, mult), as
 * demanded by a command expression.
 *
 * Operators (op) include "incr", "decr", and "mult".
 *
 */
function perform_op(text,op){
	// Determine parameter name.
	var findParam = get_var_name(text,op,false);
	var paramName = findParam[0];

	// How much to multiply the parameter by.
	var toOp = 1;

	if (findParam[1].length > paramName.length){
		toOp = parseFloat(get_var_name(findParam[1],paramName,false));
	}

	// Retrieve stored param
	var paramVal = store.get(paramName);

	// If it is a number, increment appropriately
	if (isNumeric(paramVal)){
		if (op=="incr"){
			store.set(paramName, paramVal+toOp);
		}
		else if (op=="decr"){
			store.set(paramName, paramVal-toOp);
		}
		else if (op=="mult"){
			store.set(paramName, paramVal*toOp);
		}
		else{
			console.log("Unrecognized operator. " + paramName + " is still " + paramVal + ".");
		}
	}
}
/*
 * Determines if an expression that compares a parameter's
 * ('param') actual value with another value ('val'), by way
 * of an operator ('op').
 *
 * Currently supports the following operators for comparison:
 *  - eq 	(equals)
 *  - lt 	(less than)
 *  - gt 	(greater than)
 *  - geq	(greater than or equal to)
 *  - leq	(less than or equal to)
 *
 */
function is_exp_true(param, op, val){
	var isTrue = false;
	var actualVal = store.get(param);

	if (op=="eq"){
		if (actualVal==val){
			isTrue=true;
		}
	}
	else if(op=="lt"){
		if (actualVal<val){
			isTrue=true;
		}
	}
	else if(op=="gt"){
		if (actualVal>val){
			isTrue=true;
		}
	}
	else if(op=="geq"){
		if (actualVal>=val){
			isTrue=true;
		}
	}
	else if(op=="leq"){
		if (actualVal<=val){
			isTrue=true;
		}
	}
	else{
		console.log("Unrecognized operator.  Returning false.");
	}

	return isTrue;
}

/*
 * Check if an input String contains a number.
 */
function isNumeric(s) {
  return !isNaN(parseFloat(s)) && isFinite(s);
}

})();
