/*
 This file generates a string containing a complete Phaser program, giving a brain that contains Phaser abstract syntax.
*/

define(["ctp", "rensa"], function(ctp, rensa) {
// Change to false to remove whitespace from output.
var addWhitespace = false;

// Contains realized goals from the ASP code.
var goals = [];

//var ctp = require('./cygnus-to-phaser-brain');
//var rensa = require('./brain');

// Input: Phaser abstract syntax (brain).
// Output: Phaser program (string).
var writePhaserProgram = function(brain){
  var programText = "";

  // Grab variable assertions so we can store their values in create.
  var variableValues = [];

  // Output variable initializations first.
  for (var i in brain.assertions){
    /* VARIABLE INSTANTIATIONS */
    if (ctp.isVariableAssertion(brain.assertions[i])){
      programText += defineVariable(brain, brain.assertions[i]);
      variableValues.push(brain.assertions[i]);
    }
    /* REALIZING GOALS */
    if (ctp.isGoalAssertion(brain.assertions[i])){
      updateAspGoals(brain, brain.assertions[i]);
    }
  }
  // Now write functions.
  for (var j in brain.assertions){
    /* DEFINED FUNCTIONS */
    if (ctp.isFunctionAssertion(brain.assertions[j])){
      programText += translateFunctionAssertion(brain.assertions[j]);
    }
    /* WRITING A PROGRAM FROM A PROGRAM ASSERTION CONTAINING PHASER ABSTRACT SYNTAX */
    // We assume, for now, there is only one "program" assertion.
    else if (brain.assertions[j]["relation"]=="is_a" && brain.assertions[j]["r"].indexOf("program")>=0){
      // For each function property specified in the object (e.g. "create"),
      for (var p in brain.assertions[j]) {
        if (brain.assertions[j].hasOwnProperty(p) && typeof brain.assertions[j][p]!=="function") {
          if (p!="l" && p!="relation" && p!="r"){
            // Write the content for that function.
            programText += "function " + p + "(){";

            // If this is the create function, assign any initial variable values.
            // (We assign variable values here, because outside the functions, variables like
            // game.width have not been correctly assigned yet.)
            // Also, add default values for arcade physics (like velocity), unless they have been initialized already.
            if (p==="create"){
              // Define initial values.
              if(addWhitespace){programText+="\n"};
              for (var z=0; z<variableValues.length;z++){
                var curAssert = variableValues[z];
                if (curAssert.hasOwnProperty("value")){
                  if (curAssert["value"]!==""){
                    // if(addWhitespace){programText+="\n"};
                    programText += translateVariableAssertion(brain, curAssert, false);                                  }
                }
              }
              // Add any entities to the canvas.
              // For each content property specified in the function (e.g. "vars"),
              for (var d in brain.assertions[j][p]) {
                if (brain.assertions[j][p].hasOwnProperty(d)) {
                  // For each assertion in the list of assertions,
                  for (var b in brain.assertions[j][p][d]){
                    if (ctp.isRelationType(brain.assertions[j][p][d][b], "add_to_location")){
                      if (addWhitespace){programText+="\n\t";}
                      programText += translateAddSpriteAssertion(brain, brain.assertions[j][p][d][b]);
                    }
                  }
                }
              }
            }

            // Add all remaining statements.
            // For each content property specified in the function (e.g. "vars"),
            for (var c in brain.assertions[j][p]) {
              if (brain.assertions[j][p].hasOwnProperty(c)) {
                // For each assertion in the list of assertions,
                for (var a in brain.assertions[j][p][c]){
                  if (addWhitespace){programText+="\n\t";}
                  // Declare / change value of variables.
                  if (ctp.isVariableAssertion(brain.assertions[j][p][c][a])){
                    programText += translateVariableAssertion(brain, brain.assertions[j][p][c][a], true);
                  }
                  else if (ctp.isConditionalAssertion(brain.assertions[j][p][c][a])){
                    programText += translateConditionalAssertion(brain, brain.assertions[j][p][c][a]);
                  }
                  else if (ctp.isSetValueAssertion(brain.assertions[j][p][c][a])){
                    programText += translateSetValue(brain.assertions[j][p][c][a]);
                  }
                  else if (ctp.isRelationType(brain.assertions[j][p][c][a], "has_sprite")){
                    programText += translateHasSpriteAssertion(brain, brain.assertions[j][p][c][a]);
                  }
                  else if (ctp.isRelationType(brain.assertions[j][p][c][a], "add_to_location") && p!=="create"){
                    programText += translateAddSpriteAssertion(brain, brain.assertions[j][p][c][a]);
                  }
                  else if (ctp.isRelationType(brain.assertions[j][p][c][a], "action")&& brain.assertions[j][p][c][a]["r"][0].indexOf("delete")>=0){
                    programText += translateDeleteSpriteAssertion(brain, brain.assertions[j][p][c][a]);
                  }
                  else if (ctp.isRelationType(brain.assertions[j][p][c][a], "set_mode")){
                    programText += translateSetMode(brain, brain.assertions[j][p][c][a]);
                  }
                  else if (ctp.isRelationType(brain.assertions[j][p][c][a], "move_toward") || ctp.isRelationType(brain.assertions[j][p][c][a], "move_away")|| ctp.isRelationType(brain.assertions[j][p][c][a], "move")){
                    programText += translateMove(brain.assertions[j][p][c][a],brain.assertions[j][p][c][a]["relation"]);
                  }
                  else if (ctp.isRelationType(brain.assertions[j][p][c][a], "apply_force")){
                    programText += translateGravity(brain.assertions[j][p][c][a]);
                  }
                  else if (ctp.isGoalAssertion(brain.assertions[j][p][c][a])){
                    updateAspGoals(brain, brain.assertions[j][p][c][a]);
                  }
                  // TODO: might need isListenerAssertion at some point.
                  else if (ctp.isCallbackAssertion(brain.assertions[j][p][c][a])){
                    programText += translateListenerAssertion(brain.assertions[j][p][c][a]);
                  }
                  else if (ctp.isDraggableAssertion(brain.assertions[j][p][c][a])){
                    programText += translateDraggableAssertion(brain.assertions[j][p][c][a]);
                  }
                }
              }
            }

            // Add direction changes in the update function.
            if (p==="update"){
              if(addWhitespace){programText+="\n\t"};              programText += "for(var k in addedEntities) {if (addedEntities.hasOwnProperty(k)) {"
              if(addWhitespace){programText+="\n\t\t"};
              programText += "var entity = addedEntities[k];";
              if(addWhitespace){programText+="\n\t\t"};
              programText += "entity.directionChange.clamp(0,1);";
              if(addWhitespace){programText+="\n\t\t"};
              programText += "entity.x+=entity.directionChange.x;";
              if(addWhitespace){programText+="\n\t\t"};
              programText += "entity.y+=entity.directionChange.y;";
              if(addWhitespace){programText+="\n\t"};
              programText += "if(entity.x>game.width){entity.x=game.width;}if (entity.x<0){entity.x=0;} if (entity.y>game.height){entity.y=game.height;}if (entity.y<0){entity.y=0;}"
              if(addWhitespace){programText+="\n\t"};
              programText += "}}\n";
            }

            programText += "};";
            if (addWhitespace){programText += "\n\n"}
          }
        }
      }
    }
  }
  // Set goals variable.
  if (goals !== undefined && goals.length != 0){
    programText += "goals=[";
    for (var y=0;y<goals.length;y++){
      programText += "'"+goals[y]+"'";
      if (y<goals.length-1){
        programText+=",";
      }
    }
    programText+="];";
  }
  return programText;
};

var defineVariable = function(b,a){
  str = "";
  // If variable is a property, don't define it.
  if (a["l"][0].indexOf(".")<0){
    str = "var " + a["l"][0] + ";";
    if (addWhitespace){str+="\n";}
  }
  return str;
}

// Input: assertion to convert ("a"), brain that contains that assertion ("b")
// Convert an assertion containing a variable declaration to string.
// We're assuming here, like in most other places, that there is only one
// element in the list.
var translateVariableAssertion = function(b, a, isNewVar){
  var str="";
  if (addWhitespace){str+="\t";}
  // If this is an attribute (e.g. "e1.health")
  if (a["l"][0].indexOf(".")>=0){
    // Make sure there is a value defined (for e.g. "e1.health"),
    // and also make sure that e1 is a defined variable.
    var parent = a["l"][0].substring(0,a["l"][0].indexOf("."))
    if (a.hasOwnProperty("value") && b.getAssertionsWith({"l":[parent],"relation":"is_a","r":["variable"]}).length>0){
      // TODO deal with hash
      str += a["l"][0]+"="+a["value"]+";";
      if (addWhitespace){str+="\n";}
    }
  }
  // If this isn't an attribute (e.g. "e1")
  else{
    if (isNewVar){str += "var ";}
    str+=a["l"][0];
    // Set variable equal to value, if specified.
    if (a.hasOwnProperty("value")){
      // if value is a {}, set appropriately
      if (!(a["value"] instanceof Array) && typeof a["value"]  === "object"){
        var size = Object.keys(a["value"]).length;
        str += "={";
        var count = 0;
        for (var k in a["value"]){
          if (a["value"].hasOwnProperty(k)){
            str += "'" + k + "':'" + a["value"][k] + "'";
            count+=1;
            if (count<size){str+=",";}
          }
        }
        str +="}"
      }
      // Otherwise,
      else{
          str += "="+a["value"];
      }
    }
    str += ";";
    if (addWhitespace){str+="\n";}
  }
  return str;
}

// Convert an assertion that changes the value of a variable to string.
var translateSetValue = function(a){
  if (addWhitespace){
    return a["l"][0] + "=" + a["r"][0] + ";\n";
  }
  else{
    return a["l"][0] + "=" + a["r"][0] + ";";
  }
}

// Convert an assertion containing a conditional to string.
var translateConditionalAssertion = function(b,a){
  var str="";

  var emptyHypothesis = false;
  if (a["l"].length < 1){
    emptyHypothesis = true;
  }

  /* Formulate hypothesis. */
  if (!emptyHypothesis){
    str += "if(";
    // Add each assertion in the hypothesis.
    for (var i=0; i< a["l"].length;i++){
      if (a["l"][i]["relation"]=="gt"){
        str += a["l"][i]["l"];
        str += ">";
        str+=a["l"][i]["r"];
      }
      else if (a["l"][i]["relation"]=="ge"){
        str += a["l"][i]["l"];
        str += ">=";
        str+=a["l"][i]["r"];
      }
      else if (a["l"][i]["relation"]=="lt"){
        str += a["l"][i]["l"];
        str += "<";
        str+=a["l"][i]["r"];
      }
      else if (a["l"][i]["relation"]=="le"){
        str += a["l"][i]["l"];
        str += "<=";
        str+=a["l"][i]["r"];
      }
      else if (a["l"][i]["relation"]=="near"){
        // str+= |entity2.location - entity1.location| < screen.width*0.1
        var left = a["l"][i]["l"];
        var right = a["l"][i]["r"];
        // var leftLoc = new Phaser.Point(left.x, left.y);
        // var rightLoc = new Phaser.Point(right.x, right.y);
        // var distance = Phaser.Point.distance(leftLoc,rightLoc);
        str+="Phaser.Point.distance(new Phaser.Point("+left+".x,"+left+".y),new Phaser.Point("+right+".x,"+right+".y)) < game.width*0.1";
      }
      else if (a["l"][i]["relation"]=="control_event" && a["l"][i]["l"][0]==[ 'mouse_button' ] && a["l"][i]["r"][0]==["pressed"]){
        str+="game.input.activePointer.leftButton.isDown";
      }
      else if (a["l"][i]["relation"]=="control_event" && a["l"][i]["l"][0]==[ 'mouse_button' ] && a["l"][i]["r"][0]==["released"]){
        str+="!game.input.activePointer.leftButton.isDown";
      }
      else{
        console.log("Error: unrecognized relation " + a["relation"] + " for conditional assertion.  \n\tFile: PhaserInterpreter.  Function: translateConditionalAssertion.");
      }


      if (i <a["l"].length-1){
        str+=" " + a["l"][i+1]["logicalOp"] + " ";
      }
    }
    str+="){";
    if (addWhitespace){str+="\n";}
  }

  /* Formulate conclusion. */
  // Add each assertion in the conclusion.
  if (!emptyHypothesis && addWhitespace){str+="\t\t";}
  for (var j=0; j<a["r"].length;j++){
    if (a["r"][j]["relation"]==="set_value"){
      str+=translateSetValue(a["r"][j]);
    }
    else if (a["r"][j]["relation"]==="add_to_location"){
      str+=translateAddSpriteAssertion(b,a["r"][j]);
    }
    else if (a["r"][j]["relation"]==="action" && a["r"][j]["r"].indexOf("delete")>=0){
      str+=translateDeleteSpriteAssertion(b,a["r"][j]);
    }
    else if (a["r"][j]["relation"]==="set_mode"){
      str+=translateSetMode(b,a["r"][j]);
    }
    else if (a["r"][j]["relation"]==="move_toward" || a["r"][j]["relation"]==="move_away" || a["r"][j]["relation"]==="move"){
      str += translateMove(a["r"][j],a["r"][j]["relation"]);
    }
    if (addWhitespace){str+="\t";}
  }
  if (addWhitespace){str+="\t";}
  if (!emptyHypothesis){
    str+="}"
  }
  if (addWhitespace){str+="\n";}
  return str;
};

// Input: b is the full brain, a is the assertion to translate.
// Example:
// > player has_sprite sprite1
// > sprite1 is_a sprite with image: someImageName
// > game.load.image('"'+player+'"', 'assets/sprites/' + someImageName);
var translateHasSpriteAssertion=function(b, a){
  var str = "";

  // Find sprite image name.
  var spriteImgID = b.getAssertionsWith({"l":[a["r"][0]],"relation":"is_a","r":["sprite"]});

  // If the image name exists, add the appropriate preload message for the sprite.
  if (spriteImgID!=undefined && b.assertions[spriteImgID]!=undefined){
    if (b.assertions[spriteImgID]["image"]){
      var img = b.assertions[spriteImgID]["image"];
      str+= "game.load.image('" + a["l"][0] + "','assets/sprites/"+img+"');"
      if (addWhitespace){str+="\n";}
    }
  }
  return str;
}

// Example: e1=addAtRandomPoint('e1');
var translateAddSpriteAssertion=function(b,a){
  var str="";
  str+=a["l"][0]+"=addAtRandomPoint('"+a["l"][0]+"');"
  if (addWhitespace){str+="\n";}
  // If it's an entity, set default arcade values.
  var isVariableID = b.getAssertionsWith({"l":a["l"],"relation":"is_a","r":["variable"]})[0];
  if (isVariableID!=undefined){
    var curAssert = b.getAssertionByID(isVariableID);
    if (curAssert.hasOwnProperty("variableType")){
      if (curAssert["variableType"].indexOf("entity")>=0){
        if(addWhitespace){str+="\n\t"};
        str += "addedEntities['"+a['l'][0]+"']="+a['l'][0]+";";
        if(addWhitespace){str+="\n\t"};
        str+="initEntityProperties('"+a['l'][0]+"');"
      }
    }
  }
  if(addWhitespace){str+="\n\t"};
  return str;
}

// Example: {"l":["e1"],"relation":"triggers","r":["e1ClickListener"]}
//  >> e1.inputEnabled = true;
//  >> e1.events.onInputDown.add(e1ClickListener, this);
var translateListenerAssertion=function(a){
  var str="";
  str += a["l"][0]+".inputEnabled=true;";
  if (addWhitespace){str+="\n\t";}
  str+=a["l"][0]+".events.onInputDown.add("+a["r"][0]+",this);";
  if (addWhitespace){str+="\n";}
  return str;
}

// Example: controlLogic(draggable(e1)). --> e1 is_a draggable -->
// >>e1.inputEnabled = true;
// >>e1.input.enableDrag(true);
var translateDraggableAssertion=function(a){
  var str="";
  str += a["l"][0]+".inputEnabled=true;";
  if (addWhitespace){str+="\n\t";}
  str += a["l"][0]+".input.enableDrag(true);";
  if (addWhitespace){str+="\n";}
  return str;
}

// We assume the function has a single name.
var translateFunctionAssertion=function(a){
  var str="";
  str += "function " + a["l"][0] + "("
  count = 0;
  for (var i=0;i<a.params.length;i++){
    str+=a.params[i]
    count+=1;
    if (count<a.params.length){
      str+=","
    }
  }
  str += "){";
  if (a["lines"]!=undefined && a["lines"]!=""){
    for (var j=0;j<a["lines"].length;j++){
      if (addWhitespace){str+="\n\t";}
      str+=a.lines[j];
    }
    if (addWhitespace){str+="\n";}
  }

  str += "};";
  if (addWhitespace){str +="\n\n";}
  return str;
}


// tempPoint.x = other.x-entity.x;
// tempPoint.y = other.y-entity.y;
// tempPoint.normalize();
// entity.movementProfile(entity, tempPoint)
var translateMove = function(a, move_type){
  str = "";
  // if move_toward(entity, other) or move_away(entity, other)
  if (move_type==="move_toward" || move_type==="move_away"){
    // if a["r"][0]==="cursor", change it to to "game.input.mousePointer"
    var other = a["r"][0];
    if (other==="cursor"){
      other="game.input.mousePointer";
    }
    str += "var tempPoint = new Phaser.Point("+other+".x-"+a["l"][0]+".x,"+other+".y-"+a["l"][0]+".y);";
    if (addWhitespace){str+="\n\t";}
    str+="tempPoint.normalize();"
    if (addWhitespace){str+="\n\t";}
    str+=move_type+"("+a["l"][0]+", tempPoint);";
    if (addWhitespace){str+="\n";}
  }
  // Otherwise, assume move(entity, direction)
  else{
    str+="move(";
    if (a["r"][0]==="north"){
      // move(entity, 0, -1);
      str += a["l"][0]+",0,-1);"
    }
    else if (a["r"][0]==="south"){
      str += a["l"][0]+",0,1);"
    }
    else if (a["r"][0]==="east"){
      str += a["l"][0]+",1,0);"
    }
    else if (a["r"][0]==="west"){
      str += a["l"][0]+",-1,0);"
    }
    else if (a["r"][0]==="northeast"){
      // move(entity, 0, -1);
      str += a["l"][0]+",1,-1);"
    }
    else if (a["r"][0]==="northwest"){
      str += a["l"][0]+",-1,-1);"
    }
    else if (a["r"][0]==="southeast"){
      str += a["l"][0]+",1,1);"
    }
    else if (a["r"][0]==="southwest"){
      str += a["l"][0]+",-1,1);"
    }
    if (addWhitespace){str+="\n";}
  }

  return str;
}

// TODO: there are no examples beyond setting gravity to -mid at this
// time, but we should really store gravity value in the Cygnus brain.
var translateGravity = function(a){
  var str="";
  var entity = a["l"][0];
  str+= entity+".body.gravity.y = mid;"
  if (addWhitespace){str+="\n";}
  return str;
}

var translateDeleteSpriteAssertion = function(b, a){
  var str ="";
  var entity = a["l"][0];
  str+= entity+".destroy();"
  if (addWhitespace){str+="\n";}
  return str;
}

var translateSetMode = function(b,a){
  var str="";
  var newMode = a["r"][0];
  str+="changeMode('" + newMode +"');"
  if (addWhitespace){str+="\n";}
  return str;
}

var updateAspGoals = function(b, a){
  // For each element of left...
  for (var i=0;i<a["l"].length;i++){
    // This is the natural text translation of the ASP goal.
    var realizedGoal = "";
    // This is the string that specifies the ASP goal.
    var left = a["l"][i];
    // Goal types: "achieve", "prevent", "maintain"
    var goalType = left.substring(left.indexOf(".")+1);
    // Goal objects are resources (e.g. "r1") or precondition keywords (e.g. "o1").
    var goalObj = left.substring(0,left.indexOf("."));
    // If it's a precondition keyword, we have to find the preconditions.
    if (goalObj.indexOf("o")===0){
      var goalObjIDsOne = b.getAssertionsWith({"goal_keyword":goalObj});
      var goalObjsOne = [];
      for (var z=0; z<goalObjIDsOne.length;z++){
        goalObjsOne.push(b.getAssertionByID(goalObjIDsOne[z]))
      }

      /* Now we need to get any preconditions in the program assertion... */
      var goalObjsTwo = [];
      // First, retrieve the program assertion.  There can only be one!
      var pID = b.getAssertionsWith({"relation":"is_a","r":["program"]})[0];
      var pAssert = b.getAssertionByID(pID);
      // For each assertion in pAssert,
      for (var p in pAssert) {
          if (pAssert.hasOwnProperty(p) && typeof pAssert[p]!=="function") {
            if (p!="l" && p!="relation" && p!="r"){
            for (var c in pAssert[p]) {
              if (pAssert[p].hasOwnProperty(c)) {

                for (var e=0;e<pAssert[p][c].length;e++){
                  if (pAssert[p][c][e].hasOwnProperty("goal_keyword")){                                        if (pAssert[p][c][e]["goal_keyword"]===goalObj){
                      goalObjsTwo.push(pAssert[p][c][e]);
                    }
                  }
                }
              }
            }
          }
        }
      }

      // var goalObjIDsTwo = b.getAssertionsWith({"goal_keyword":goalObj});
      // merge one and two
      var goalObjs = goalObjsOne.concat(goalObjsTwo);

      for (var j=0;j<goalObjs.length;j++){
        var assert = goalObjs[j];

        preconds = assert["l"];
        realizedGoal = goalType.charAt(0).toUpperCase() + goalType.substr(1).toLowerCase() + ":"
        for (var k=0; k<preconds.length; k++){
          var pre = rensa.prettyprint(preconds[k],false);
          pre = pre.replace(/['"]+/g, '');
          realizedGoal += pre;
          if (k<preconds.length-1){
            realizedGoal+=",";
          }
        }
      }
    }
    // Otherwise, if it's a resource, simply state the resource.
    else if (goalObj.indexOf("r")===0){
      realizedGoal = goalType.charAt(0).toUpperCase() + goalType.substr(1).toLowerCase() + " " + goalObj;
    }
    else {
      console.log("ERROR: Unrecognized goal object.")
    }
    // Add the realized goal to the "goals" array.
    if (realizedGoal !== ""){
      goals.push(realizedGoal);
    }
  }
}

return {
  writePhaserProgram : writePhaserProgram
}

});
