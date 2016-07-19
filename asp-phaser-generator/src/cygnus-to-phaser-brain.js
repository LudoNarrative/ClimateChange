/*
  This file translates Cygnus abstract syntax into Phaser abstract syntax.
*/

define(["rensa"], function(rensa) {
//var rensa = require('./brain');

/*
Input:  initial Phaser abstract syntax content (brain),
        Cygnus abstract syntax (brain).

Output: Cygnus input translated into Phaser abstract syntax,
        merged with initial Phaser content (brain).
*/
var cygnusToPhaser = function(initialBrain,cygnusBrain){
  // Make a clone of the initial brain.
  var finalBrain = initialBrain.clone();

  // Find the ID of the assertion containing the program data.
  // For now, we assume only one program.
  // This ID should be zero.
  var pID = finalBrain.getAssertionsWith({"relation":"is_a","r":["program"]})[0];

  // Use the information from the cygnusBrain to edit the final brain.
  finalBrain = mergeInitialWithCygnus(pID, finalBrain, cygnusBrain);

  // If no sprite is specified for an entity or resource, choose one at random from the Phaser brain.  (Optional step.) TODO: resources probably won't have sprites; just entities.
  // finalBrain = addMissingSprites(finalBrain);

  // Add sprites in the create method.
  finalBrain = addSprites(pID, finalBrain);

  // Add preload information.
  finalBrain = updatePreload(pID, finalBrain);

  return finalBrain;
};

var addSprites=function(pID, brain){
  var newBrain = brain.clone();
  var newProgram = JSON.parse(JSON.stringify(brain.assertions[pID]));

  for (var i in brain.assertions){
    if (isRelationType(brain.assertions[i],"add_to_location")){
      newProgram["create"]["sprites"].push(brain.assertions[i]);
    }
  }
  // Update the program assertion.
  newBrain.assertions[pID] = newProgram;
  return newBrain;
};

var addMissingSprites=function(brain){
  var newBrain = brain.clone();
  // For each assertion in the brain,
  for (var i in brain.assertions){
    // If this assertion is about an entity or resource,
    if ((isVariableAssertion(brain.assertions[i]) && brain.assertions[i].hasOwnProperty("variableType") && (brain.assertions[i]["variableType"]=="resource" || brain.assertions[i]["variableType"]=="entity")) || isVariableTypeAssertion(brain.assertions[i])){
      // Look for the associated sprite.
      var spriteID = brain.getAssertionsWith({"l":brain.assertions[i]["l"],"relation":"has_sprite"})[0];

      // If there is no sprite,
      if (spriteID==undefined){
        // Find all the sprites known by the brain that are tagged with "randomSprite".
        var randomSpriteIDs = brain.getAssertionsWith({"relation":"is_a","r":["sprite"],"tags":["randomSprite"]});

        // Choose one of these sprites at random.
        var randomSpriteID =  randomSpriteIDs[Math.floor(Math.random()*randomSpriteIDs.length)];

        var randomSprite = brain.getAssertionByID(randomSpriteID);

        // Add a new assertion to the brain with the random sprite.
        newBrain.addAssertion({"l":brain.assertions[i]["l"],"relation":"has_sprite","r":randomSprite["l"]});
      }
    }
  }
  return newBrain;
};

// Add preload information based on any "has_sprite" assertions.
// e.g. player has_sprite sprite should be an assertion in preload.
var updatePreload=function(pID, brain){
  var newBrain = brain.clone();

  // newProgram will contain any existing assertions, plus any we modify.
  var newProgram = JSON.parse(JSON.stringify(brain.assertions[pID]));

  // For each assertion in the brain,
  for (var i in brain.assertions){
    // If it's a has_sprite assertion,
    if (isRelationType(brain.assertions[i],"has_sprite")){
      var inPreload = false;
      // Check if is this sprite is already in ["preload"]["images"].
      for (var e=0; e<newProgram["preload"]["images"].length;e++){
        if (rensa.arraysEqual(newProgram["preload"]["images"][e]["r"],brain.assertions[i]["r"])&& rensa.arraysEqual(newProgram["preload"]["images"][e]["l"],brain.assertions[i]["l"])){
          inPreload=true;
        }
      }
      // Add assertion to ["preload"]["images"] if it's not already in there.
      if (!inPreload){
        newProgram["preload"]["images"].push(brain.assertions[i]);
      }

      // Remove this assertion from the brain.
      delete newBrain.assertions[i];
    }
  }
  // Update the program assertion.
  newBrain.assertions[pID] = newProgram;

  return newBrain;
};

// Modify the contents of the create function inside the program data assertion.
// For now, we assume all variable setting happens in create.
// We're also assuming that any old assertions won't be repeated.
var mergeInitialWithCygnus = function(pID, initialBrain, cygnusBrain){
  // Make a clone of the initial brain.
  var newBrain = initialBrain.clone();

  // newProgram will contain any existing assertions, plus any we gain from cygnusBrain.
  var newProgram = initialBrain.assertions[pID].clone();

  // These objects temporarily store known variables from cygnusBrain.
  // {varName1:type1, varName2:type2...}
  var tempVarTypes = {};
  // {varName1:value1, varName2:value2...}
  var tempVarValues = {};

  for (var i in cygnusBrain.assertions){
    if (isVariableTypeAssertion(cygnusBrain.assertions[i])){
      tempVarTypes[cygnusBrain.assertions[i]["l"]] = cygnusBrain.assertions[i]["r"];
    }
    else if (isSetValueAssertion(cygnusBrain.assertions[i])){
      tempVarValues[cygnusBrain.assertions[i]["l"]] = cygnusBrain.assertions[i]["r"];
    }
    else if (isConditionalAssertion(cygnusBrain.assertions[i])){
      // We are going to add a new assertion based on the current "old" assertion in the cygnus brain (cygnusBrain.assertions[i]).

      var newAssertion = cygnusBrain.assertions[i].clone();
      var newLeft = [];
      var newRight = [];
      var goal_keyword = newAssertion["goal_keyword"];

      // Check if one of the preconditions (elements in the left array) is a click listener.
      var isClickConditional=false;
      // Get the click listener assertion, if any.
      var clickAssertion = null;
      for (var q in cygnusBrain.assertions[i]["l"]){
        var oldHypRight = cygnusBrain.assertions[i]["l"][q]["r"];
        if (rensa.arraysEqual(oldHypRight,["click_listener"])){
          isClickConditional=true;
          clickAssertion = cygnusBrain.assertions[i]["l"][q];
        }
      }
      if (isClickConditional && clickAssertion!=null){
        // Get the name of the click listener function.
        var clickListenFn = clickAssertion["l"][0];
        // Get the entity/resource/etc. that is to be clicked.
        var clicked = clickListenFn.substring(0,clickListenFn.indexOf("ClickListener"));
        // Add listener to create method.
        // i.e., in create: e1.events.onInputDown.add(e1ClickListener, this);
        var newAssert = {
          "l": [clicked],
          "relation":"triggers",
          "r": [clickListenFn]
        };
        if (goal_keyword != undefined){
          newAssert["goal_keyword"]=goal_keyword;
        }
        newProgram["create"]["listeners"].push(newAssert);
        /*
          Add new function to the brain that contains all other preconditions (besides the click listener) and the results.
          i.e.,
            function e1ClickListener() {
            	if (precond_1 && precond_2 &&...precond_n){
                result_1;...result_n;
              }
            }
        */
        newLeft = getNewHypotheses(newLeft, cygnusBrain.assertions[i]["l"]);
        newRight = getNewConclusions(newRight,cygnusBrain.assertions[i]["r"]);

        newProgram[clickListenFn] = {};
        newProgram[clickListenFn]["outcomes"] = [];

        var newAssert2 = {
          "l": newLeft,
          "relation":"causes",
          "r": newRight
        };
        if (goal_keyword != undefined){
          newAssert2["goal_keyword"]=goal_keyword;
        }
        newProgram[clickListenFn]["outcomes"].push(newAssert2);
        // Push the old assertion into the brain anyway.  This lets us update coordinates.
        newBrain.addAssertion(cygnusBrain.assertions[i]);
      }
      else{
        newLeft = getNewHypotheses(newLeft, cygnusBrain.assertions[i]["l"]);
        newRight = getNewConclusions(newRight,cygnusBrain.assertions[i]["r"]);

        var newAssert3 = {
          "l": newLeft,
          "relation":"causes",
          "r": newRight
        };
        if (goal_keyword != undefined){
          newAssert3["goal_keyword"]=goal_keyword;
        }
        // Push the new assertion into the outcomes list.
        newProgram["update"]["outcomes"].push(newAssert3);
      }
    }
    else if (isRelationType(cygnusBrain.assertions[i],"move_towards") || isRelationType(cygnusBrain.assertions[i],"move_away")|| isRelationType(cygnusBrain.assertions[i],"move")){
      if (cygnusBrain.assertions[i].hasOwnProperty("tags")){
        if (cygnusBrain.assertions[i]["tags"].indexOf("update")>=0){
          newProgram["update"]["motion"].push(cygnusBrain.assertions[i]);
        }
        else{
          newProgram["create"]["motion"].push(cygnusBrain.assertions[i]);
        }
      }
      else{
        newProgram["create"]["motion"].push(cygnusBrain.assertions[i]);
      }
    }
    else if (isDraggableAssertion(cygnusBrain.assertions[i])){
      newProgram["create"]["vars"].push(cygnusBrain.assertions[i]);
    }
    else if (cygnusBrain.assertions[i].hasOwnProperty("tags")){
      if (cygnusBrain.assertions[i]["tags"].indexOf("update")>=0){
        if (isRelationType(cygnusBrain.assertions[i],"increase") || isRelationType(cygnusBrain.assertions[i],"decrease")){
            newProgram["update"]["vars"].push(changeToSetValue(cygnusBrain.assertions[i]));
        }
        else {
          newProgram["update"]["misc"].push(cygnusBrain.assertions[i]);
        }
      }
      else{
        newBrain.addAssertion(cygnusBrain.assertions[i]);
      }
    }
    else{
      newBrain.addAssertion(cygnusBrain.assertions[i]);
    }
  }

  // Push all known variables (with/without values) into into newBrain's assertions.
  for (var k in tempVarTypes) {
    if (tempVarTypes.hasOwnProperty(k)) {
      // If we know what the value of the variable is,
      if (tempVarValues.hasOwnProperty(k)){
        newBrain.addAssertion({"l":[k], "relation":"is_a", "r":["variable"],"variableType":tempVarTypes[k],"value":tempVarValues[k]});
        // newProgram["create"]["vars"].push({"l":[k], "relation":"is_a", "r":["variable"],"variableType":tempVarTypes[k],"value":tempVarValues[k]});
      }
      else{
        newBrain.addAssertion({"l":[k], "relation":"is_a", "r":["variable"],"variableType":tempVarTypes[k]});
        // newProgram["create"]["vars"].push({"l":[k], "relation":"is_a", "r":["variable"],"variableType":tempVarTypes[k]});
      }
    }
  }

  // Update the program assertion.
  newBrain.assertions[pID] = newProgram;
  return newBrain;
};

// assert = cygnusBrain.assertions[i]["l"]
var getNewHypotheses = function(newLeft, assert){
  // Update each element in left array
  // > add logicalOp &&.
  for (var m in assert){
    // TODO add each property of cygnusBrain.assertions[i]["l"][m], (not just l, relation, r)

    // Here are the "old" values from the cygnus brain corresponding to the left attribute.
    var oldLeft = assert[m]["l"];
    var oldRelation = assert[m]["relation"];
    var oldRight = assert[m]["r"];

    if (!rensa.arraysEqual(oldRight,["click_listener"])){
      var newLeftA =  {"l":oldLeft,"relation":oldRelation,"r":oldRight,"logicalOp":"&&"};
      newLeft.push(newLeftA);
    }
  }
  return newLeft;
};

// assert = cygnusBrain.assertions[i]["r"];
// Again TODO: Need to push all properties, not just l, relation, right...
var getNewConclusions = function(newRight, asserts){
  // Update each element in right array.
  // > increase, decrease --> set_value.
  for (var n in asserts){
    var newRightA = changeToSetValue(asserts[n]);
    newRight.push(newRightA);
  }
  return newRight;
};

var changeToSetValue = function(assert){
  var newRightA ={};
  newRightA["l"]=assert["l"];

  // Here are the "old" values from the cygnus brain corresponding to the right attribute.
  var oldRelation = assert["relation"];
  var oldRight = assert["r"];

  if (oldRelation=="increase"){
    newRightA["relation"]="set_value";
    // TODO fix so not assuming newRightA["l"] consists of one element
    newRightA["r"]=[newRightA["l"][0]+"+"+oldRight];
  }
  else if (oldRelation=="decrease"){
    newRightA["relation"]="set_value";
    newRightA["r"]=[newRightA["l"][0]+"-"+oldRight];
  }
  else {
    newRightA["relation"]=oldRelation;
    newRightA["r"]=oldRight;
  }
  return newRightA;
}

// Check if an assertion is a variable declaration in Phaser Abstract Syntax.
var isVariableAssertion=function(a){
  return a["relation"]=="is_a" && (a["r"].indexOf("variable")>=0);
};

// Checks if an assertion is a variable declaration in Cygnus Abstract Syntax.
var isVariableTypeAssertion=function(a){
  return a["relation"]=="is_a" && (a["r"].indexOf("resource")>=0 || a["r"].indexOf("entity")>=0);
};

var isRelationType=function(a,relationType){
  return a["relation"]==relationType;
};

// Check if an assertion is setting the value of one or more concepts.
var isSetValueAssertion=function(a){
  return isRelationType(a,"set_value");
};

// Check if an assertion is a conditional.
var isConditionalAssertion = function(a){
  return isRelationType(a,"causes");
}

var isCallbackAssertion = function(a){
  return isRelationType(a,"triggers");
}

var isDraggableAssertion = function(a){  
  return isRelationType(a,"is_a") && (a["r"].indexOf("draggable")>=0);
}

var isFunctionAssertion = function(a){
  return a["relation"]=="is_a" && (a["r"].indexOf("function")>=0);
}

var isGoalAssertion = function(a){
  return isRelationType(a,"is_a") && (a["r"].indexOf("goal")>=0);
}

return {
  cygnusToPhaser : cygnusToPhaser,
  isVariableAssertion : isVariableAssertion,
  isGoalAssertion : isGoalAssertion,
  isFunctionAssertion : isFunctionAssertion,
  isConditionalAssertion : isConditionalAssertion,
  isSetValueAssertion : isSetValueAssertion,
  isRelationType : isRelationType,
  isCallbackAssertion : isCallbackAssertion,
  isDraggableAssertion : isDraggableAssertion
}
});