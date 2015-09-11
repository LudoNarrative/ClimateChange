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

updatePassage = null;
Passage.prototype = {
  render:function(){
    clearInterval(updatePassage);

    update_passage([new Passage(this.title,this.scene,this.choices)]);
    updatePassage = setInterval ( update_passage, 1000, [new Passage(this.title,this.scene,this.choices)]);

  }
}

scrubTimer = undefined;
showingScrubMessage = false;

function update_passage(passage){
  // Make temporary array for choices.
  // This will ensure that we do not overwrite coded variables.
  var scenes = passage[0].scene.slice(0);

  // Check for scene commands.
  // Doing this prior to the scrub check will ensure passages are not accidentally
  // displayed before they should be.
  for(k=0;k<scenes.length;k++){
    scenes[k] = check_commands(scenes[k]);
  }


  // Check if scrub percentage threshold has been met (scrubbing game).
  if (store.get("required_percent") != -1){
    if (store.get("percent") < store.get("required_percent")){

    if (!showingScrubMessage) {

        document.getElementById("scene-description").innerHTML = "";
        document.getElementById("choice-points").innerHTML = "";
    if (!scrubTimer) {
      scrubTimer = setTimeout(function() {
        document.getElementById("choice-points").innerHTML = "<span style='color:yellow'>Keep scrubbing...</span>";
        showingScrubMessage = true;
      }, 1500);
    }
    }
    }
    else {
    show_passage(passage);
    clearTimeout(scrubTimer);
    scrubTimer = undefined;
    showingScrubMessage = false;

      show_passage([new Passage(passage[0].title,scenes,passage[0].choices)]);
    }
  }
  else{
    show_passage([new Passage(passage[0].title,scenes,passage[0].choices)]);
  }
}

function show_passage(passage){
  // Make temporary array for choices.
  // This will ensure that we do not overwrite coded variables.
  var scenes = passage[0].scene.slice(0);

  var chs = new Choices([]);
  for (var j=0; j<passage[0].choices.list.length;j++){
    chs.addChoice(passage[0].choices.list[j].text,passage[0].choices.list[j].link);
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
  // Clear scene description
  document.getElementById("scene-description").innerHTML = "";

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
 *  - @@set PARAM to VALUE@@: Sets a variable to a number or string.
 *  - @@incr PARAM@@:   Increments a numeric variable by one.
 *  - @@incr PARAM x@@: Increments a numeric variable by x.
 *  - @@decr PARAM@@:   Decrements a numeric variable by one.
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
 *  - @@if PARAM eq VALUE AND PARAM eq VALUE@@
 *  - @@if PARAM eq VALUE OR PARAM eq VALUE@@
 *  - @@if PARAM eq VALUE AND PARAM eq VALUE AND PARAM eq VALUE@@ ...
 */
function process_conditional(cond){
  var replacement = "";   // We will replace the code with the text it specifies.
  var operator = "";    // eq, geq, leq, gt, lt
  var reachedTerminal = false;
  var rest = cond;
  var logic = "";
  var logicOp = "if";

  while (!reachedTerminal) {
    // Determine parameter name.
    var findParam = get_var_name(rest,logicOp,true);
    
    var param = findParam[0];

    // Determine operator.
    var findOp = get_var_name(findParam[1],param,false);
    operator = findOp[0];

    rest = findOp[1].slice(operator.length + 1, findOp[1].length).trim();

    // Determine value.
    var symPos = rest.indexOf("@@");
    var andPos = rest.indexOf("AND");
    var orPos = rest.indexOf("OR");
    var xPos;
    if (andPos >= 0 && andPos < symPos) {
      xPos = andPos;
      logicOp = "AND";
    } else if (orPos >= 0 && orPos < symPos) {
      xPos = orPos;
      logicOp = "OR";
    } else {
      // @@
      logicOp = undefined;
      xPos = symPos;
      reachedTerminal = true;
    }
    var value = rest.slice(0, xPos).trim();
    var startPos = xPos;
    if (logicOp) {
      startPos += logicOp.length;
    }

    // Check if the expression is true.
    var isTrue = is_exp_true(param,operator,value);
    logic += isTrue;
    if (!reachedTerminal) {
      logic += " " + (logicOp === "AND" ? "&&" : "||") + " ";
    }
  }

  // If the overall logic condition is true, write the first statement.
  var isOverallTrue = eval(logic);
  if (isOverallTrue){
    var g = rest.indexOf("@@");
    var i = rest.slice(g+2);
    var h = i.indexOf("@@");

    replacement = i.slice(0,h);
  }
  // If the conditional is not true,
  else{
    // If conditional contains else,
    var a = rest.indexOf('@@else@@');
    if(~a){
      // ...write the statement corresponding with the else.
      var b = rest.slice(a+8);
      var c = b.indexOf("@@endif@@");
      replacement=b.slice(0,c);
    }
  }
  return replacement;
}

// Basic unit test for process conditional.

// function test_process_conditional() {
//   var result, cond;
//   store.set("testVar", 0);
//   store.set("testVar2", 0);
//   cond = "@@if testVar eq 5@@Output A@@endif@@";
//   result = process_conditional(cond);
//   console.assert(result === "", "Simple if should return empty string if false");
//   store.set("testVar", 5);
//   result = process_conditional(cond);
//   console.assert(result === "Output A", "Simple if should return contents if true");
//   cond = "@@if testVar eq 5@@Output B@@else@@Output C@@endif@@";
//   result = process_conditional(cond);
//   console.assert(result === "Output B", "Else should return first field if true");
//   store.set("testVar", 0);
//   result = process_conditional(cond);
//   console.assert(result === "Output C", "Else should return second field if false");
//   store.set("testVar2", 5);
//   cond = "@@if testVar eq 0 AND testVar2 eq 5@@Output D@@else@@Output E@@endif@@";
//   result = process_conditional(cond);
//   console.assert(result === "Output D", "Compound with AND should return first field if both true");
//   store.set("testVar2", 0);
//   result = process_conditional(cond);
//   console.assert(result === "Output E", "Compound with AND should return second field if either one false");
//   store.set("testVar", 3);
//   result = process_conditional(cond);
//   console.assert(result === "Output E", "Compound with AND should return second field if both false");
//   cond = "@@if testVar eq 0 OR testVar2 eq 0@@Output F@@else@@Output G@@endif@@";
//   store.set("testVar", 0);
//   store.set("testVar2", 1);
//   result = process_conditional(cond);
//   console.assert(result === "Output F", "Compound with OR should return first field if second true");
//   store.set("testVar", 1);
//   store.set("testVar2", 0);
//   result = process_conditional(cond);
//   console.assert(result === "Output F", "Compound with OR should return first field if first true");
//   store.set("testVar", 0);
//   result = process_conditional(cond);
//   console.assert(result === "Output F", "Compound with OR should return first field if both true");
//   store.set("testVar", 1);
//   store.set("testVar2", 1);
//   result = process_conditional(cond);
//   console.assert(result === "Output G", "Compound with OR should return second field if both false");
//   cond = "@@if testVar eq 1 AND testVar2 eq 1 AND testVar leq 1 AND testVar2 geq 1@@Output J@@else@@Output K@@endif@@";
//   result = process_conditional(cond);
//   console.assert(result === "Output J", "Compound with > 2 operators should parse correctly.");
//   cond = "@@  if   testVar   eq   1    AND    testVar2   eq       1   @@Output H@@endif@@";
//   result = process_conditional(cond);
//   console.assert(result === "Output H", "Extra spaces shouldn't mess things up.");
// }
// test_process_conditional();

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
  var keywordPos = text.indexOf(keyword);
  var keywordRemoved = text.slice(keywordPos+keyword.length + 1).trim();
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
 *  - eq  (equals)
 *  - lt  (less than)
 *  - gt  (greater than)
 *  - geq (greater than or equal to)
 *  - leq (less than or equal to)
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
    console.log("Unrecognized operator '" + op + "'.  Returning false.");
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
