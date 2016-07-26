/*
  This file translates the generated ASP logic into Rensa-flavored JSON. Useful for visualizing the generated ASP games, as well as for translating the generated games into Phaser code.
*/
// A list of all keywords used in preconditions and results that
// we have already addressed/translated.

define([], function() {

// X(Y). --> Y is_a X.
// Example: entity(ball).
function translateIsA(str){
  var hypStart = str.indexOf("(");
  var hypEnd = str.indexOf(").");
  if (hypStart != -1 && hypEnd != -1){
    var x = str.substring(0,hypStart);
    var y = str.substring(hypStart+1,hypEnd);
    if (translateNested(y).substring(translateNested(y).indexOf(".")+1)=="draggable"){
      var entity = translateNested(y).substring(0,translateNested(y).indexOf("."));
      return {"l":[entity], "relation":"is_a", "r":["draggable"], "tags":["global"]};
    }else{
      return {"l":[translateNested(y)], "relation":"is_a", "r":[x], "tags":["global"]};
    }

  }
  return null;
}

// X(Y,Z). --> Y X Z
// Examples:
//    move_towards(entity, other)
//    move_away(entity, other)
//    move(entity, dir) where dir = north, south, east, west, northeast, etc.
function translateSimpleRelation(str){
  var hypStart = str.indexOf("(");
  var hypMid = str.indexOf(",");
  var hypEnd = str.indexOf(").");

  if (hypStart != -1 && hypMid != -1 && hypEnd != -1){
    var x = str.substring(0,hypStart);
    var y = str.substring(hypStart+1,hypMid);
    var z =str.substring(hypMid+1,hypEnd);
    return {"l":[y], "relation": x, "r": [z]};
  }
  return null;
}

// helper, deals with statements like add(e2, random)
var translateAdd=function(str, addCommand){
  var b = str.substring(addCommand+4);
  var hypStart2 = b.indexOf("(");
  var hypMid = b.indexOf(",");
  var hypEnd = b.indexOf(")).");
  if (hypStart2 != -1 && hypMid != -1 && hypEnd != -1){
    var y = b.substring(hypStart2+1,hypMid);
    var z = b.substring(hypMid+1,hypEnd);
    return {"l":[translateNested(y)], "relation":"add_to_location", "r":[translateNested(z)], "tags":["create"]};
  }
}

// initialize(set_X(Y,Z)). --> Y has_X Z
// Example: initialize(set_value(confidence,5)).
function translateInitialize(str){

  var addCommand = str.indexOf("(add");
  var setSpriteStart = str.indexOf("(set_sprite");

  // Check for add command.
  if (addCommand != -1){
    return translateAdd(str, addCommand);
  }

  // Check for set_sprite command.
  else if (setSpriteStart != -1){
    var b = str.substring(setSpriteStart+10);
    var hypStart2 = b.indexOf("(");
    var hypMid = b.indexOf(",");
    var hypEnd = b.indexOf(")).");
    if (hypStart2 != -1 && hypMid != -1 && hypEnd != -1){
      var y = b.substring(hypStart2+1,hypMid);
      var z = b.substring(hypMid+1,hypEnd);
      return {"l":[translateNested(y)], "relation":"has_sprite", "r":[translateNested(z)]};
    }
  }
  // Otherwise, check for set command.
  else{
    var hypStart = str.indexOf("(set");
    var b = str.substring(hypStart+4);
    var hypStart2 = b.indexOf("(");
    var hypMid = b.indexOf(",");
    var hypEnd = b.indexOf(")).");
    if (hypStart != -1 && hypStart2 != -1 && hypMid != -1 && hypEnd != -1){
      var y = b.substring(hypStart2+1,hypMid);
      var z = b.substring(hypMid+1,hypEnd);
      return {"l":[translateNested(y)], "relation":"set_value", "r":[translateNested(z)], "tags":["global"]};
    }
  }

  return null;
}

var translateTickPrecondition = function(results,keyword){
  var assertionsToAdd = [];
  var rs = [];
  rs = addNormalResult(rs, results);

  // Add each result to the brain with an update tag.
  for (var i=0; i<rs.length;i++){
    var result = rs[i];
    if (result.hasOwnProperty("tags")){
      result["tags"] = result["tags"].push("update");
    }
    else{
      result["tags"] = ["update"];
    }
    result["goal_keyword"]=keyword;
    assertionsToAdd.push(result);
  }
  return assertionsToAdd;
}
/*
  Takes in a list of precondition statements and another list of the results they cause.
  Returns a list of assertions to add.

 Examples:
 1) precondition(below(confidence,5),bad_face).
    result(bad_face,set_sprite(face, upset_face)).

 2) precondition(control_event(mouse_button,pressed),gain).
    precondition(overlaps(ball,square,true),gain).
    result(gain,increases(confidence,2)).
    result(gain,change_color(square,green,1)).

 3) precondition(le(r1, med), o1).
    result(o1, increase(r1, low)).
*/
function translatePrecondition(preconds, results, keyword){
  // If this is a click control_event precondition-result pair, we'll need to initialize the listener for the mouse in the "create" function, and create a new function for the listener's callback.
  var isClickEvent = false;
  // For every precondition in preconds,
  for (i in preconds){
    if (preconds[i].indexOf("control_event(click(")>=0){
      isClickEvent=true;
    }
  }
  if (isClickEvent){
    return translateClickPrecondition(preconds,results,keyword);
  }
  // Otherwise, assume the precondition should be fed into the update function ([“update”][“outcomes”]).
   else{
     return translateUpdatePrecondition(preconds,results,keyword);
   }
};

/*
 Handles preconditions/results that occur as a result of clicking.

 Examples:
 1) precondition(control_event(click(e1)), o1).
    result(o1, add(e2, random)).
    result(o1, increase(r1, low)).
*/
var translateClickPrecondition = function(preconds,results,keyword){
  // List of assertions to push.
  assertionsToAdd = [];

  // Name of the click listener.
  var listenerName = "";

  // List of precond and result dictionaries to be added to left
  // and right concepts.
  var ps = [];
  var rs = [];

  // For every precondition in preconds,
  for (i in preconds){
    var p = preconds[i].substring(1);
    var start = p.indexOf("(");
    var mid = p.lastIndexOf("),");

    if (start != -1 && mid != -1){
      var a = p.substring(0,start);
      var bList = p.substring(start+1, mid).split(",");

      // If this is the control event, don't add to our final array of preconditions.
      if (a=="control_event"){
        // Grab the argument of the click. (Assume bList has one element).
        var argument = bList[0].substring(bList[0].indexOf("(")+1,bList[0].indexOf(")"));
        listenerName = argument+"ClickListener";
        var clickAssertion = {"l":[listenerName],"relation":"is_a","r":["click_listener"],"for":[argument],"tags":["create"],"goal_keyword":keyword};
        assertionsToAdd.push(clickAssertion);
        ps.push(clickAssertion);

      }
      // Otherwise, push this precondition into our final array of all preconditions.
      else{
        ps = addNormalPrecond(ps, bList, a);
      }
    }
  }
  rs = addNormalResult(rs, results);

  // If we have valid preconditions and results,
  if (ps.length > 0 && rs.length > 0){
    /* Form the final assertion.
       This conditional will be stored in a function called listenerName, in the format of:
            if (each precondition in ps is true){
              execute each result in rs.
            }
    */
    assertionsToAdd.push({"l": ps,"relation":"causes","r":rs, "listener":listenerName, "goal_keyword":keyword});
  }
  return assertionsToAdd;
};

/*
  Handles conditional statements that should be displayed in the update function (["updates"]["outcomes"]) of the final Phaser program.

  Examples:
  1) precondition(le(r1, med), o1).
     result(o1, increase(r1, low)).

  2) precondition(gt(health(e1), 0), o2).
     result(o2, increase(r1, low)).
     result(o2, decrease(health(e1), 1)).
*/
var translateUpdatePrecondition = function(preconds,results,keyword){
  // List of precond and result dictionaries to be added to left
  // and right concepts.
  var ps = [];
  var rs = [];

  // For every precondition in preconds,
  for (i in preconds){
    var p = preconds[i].substring(1);
    var start = p.indexOf("(");
    var mid = p.lastIndexOf("),");

    if (start != -1 && mid != -1){
      var a = p.substring(0,start);
      var bList = p.substring(start+1, mid).split(",");

      // Push this precondition into our final array of all preconditions.
      ps = addNormalPrecond(ps, bList, a);
    }
  }

  rs = addNormalResult(rs, results);

  // If we have valid preconditions and results,
  if (ps.length > 0 && rs.length > 0){
    // Form the final assertion.
    return [{"l": ps,"relation":"causes","r":rs,"goal_keyword":keyword}];
  }
  return null;
};

// Helper for translateUpdatePrecondition and translateClickPrecondition.
// Populates the list of precondition assertions.
var addNormalPrecond = function(ps, bList,a){
  // check for mouse press
  if (translateNested(bList[0])==="button(.button"){
    bList[0]="mouse_button";
    bList[1]=bList[1].replace(/\(|\)/g,'')
  }
  if (bList.length==2){ // B = bList[0], C = bList[1]
    ps.push({"l":[translateNested(bList[0])],"relation":a,"r":[bList[1]]});
  }
  else if (bList.length==3){
    if (typeof bList[2] == "number"){
      ps.push({"l":[translateNested(bList[0])],"relation":a,"r":[bList[1]],"num":bList[2]});
    }
    else{
      ps.push({"l":[translateNested(bList[0])],"relation":a,"r":[bList[1]]});
    }
  }
  return ps;
};

// Helper for translateUpdatePrecondition and translateClickPrecondition.
// Populates the list of result assertions.
var addNormalResult = function(rs, results){
  // For every result in results,
  for (i in results){
    var r = results[i];
    var firstComma = r.indexOf(",");
    if (firstComma != -1){
      var r = r.substring(firstComma+1);
      var firstParen = r.indexOf("(");
      var lastParen = r.indexOf(")).");

      if (firstParen != -1 && lastParen != -1){

        var e = r.substring(0,firstParen);
        var fList = r.substring(firstParen+1,lastParen).split(",");

        if (e=="add"){
          e="add_to_location";
        }

        if (fList.length==1){
          if (e=="mode_change"){
              rs.push({"l":["game"],"relation":"set_mode","r":[fList[0]]});
          }
          else if(e=="delete"){
            rs.push({"l":[fList[0]],"relation":"action","r":["delete"]});
          }
        }
        // Push this result into our final array of all results.
        if (fList.length==2){ // F = fList[0], G = fList[1]
          rs.push({"l":[translateNested(fList[0])],"relation":e,"r":[fList[1]]});
        }
        else if (fList.length==3){
          if (typeof fList[2]=="number"){
            rs.push({"l":[translateNested(fList[0])],"relation":e,"r":[fList[1]],"num":fList[2]});
          }
          else{
            rs.push({"l":[translateNested(fList[0])],"relation": e,"r":[fList[1]]});
          }
        }
      }
    }
  }
  return rs;
};

/*
  Assumption: only one layer of nesting, e.g., only examples like:
   > entity(e1).
   > resource(health(e1)).
 */
 // Translates e.g. "health(e1)" to "e1.health".
function translateNested(x){
  var newX = x;
  if (x.indexOf("(")>0){
    // Find inner and outer terms.
    var innerStart = x.indexOf("(");
    var innerEnd = x.indexOf(")");
    var inside = x.substring(innerStart+1,innerEnd);
    var outside = x.substring(0,innerStart);
    newX = inside+"."+outside;
  }
  return newX;
}

// For now, assume lines is the string array of lines
// read in from the ASP file.
function translateASP(lines){
  var assertions = [];
  var doneLines = [];
  var doneKeywords = [];
  // For each line,
  for (var i in lines){
    var assertionsToAdd = null;
    // If is_a relation,
    if (isIsA(lines[i])){
      assertionsToAdd = [translateIsA(lines[i])];
      doneLines.push(lines[i]);
    }
    // If initializing values,
    else if (isInitialize(lines[i])){
      assertionsToAdd = [translateInitialize(lines[i])];
      doneLines.push(lines[i]);
    }
    // If precondition / result
    else if (isPrecondition(lines[i])){
      if (!containsObj(lines[i], doneLines)){
        var keyword = getKeyword(lines[i]);
        // If we haven't addressed this keyword,
        if (doneKeywords.indexOf(keyword)==-1){
          // Find all related preconditions and results.
          preconds = findPreconds(lines, keyword);
          results = findResults(lines, keyword);

          // Check if this is a "tick" precondition.
          var isTick = false;
          for (i in preconds){
            if (preconds[i].indexOf("tick")>=0){
              isTick=true;
            }
          }
          //If this is a "tick" precondition, it means all of the results should simply be put in the update function.
          // At this time, if a tick precondition occurs, there are no other preconditions in the group.  If this changes, we will need to alter how this works.
          if (isTick){
            assertionsToAdd = translateTickPrecondition(results, keyword);
          }
          // If this isn't a tick precondition,
          else{
            // Make and add assertion.
            assertionsToAdd = translatePrecondition(preconds, results, keyword);
          }
          // Add keyword to the list that shows we've already addressed it.
          doneKeywords.push(keyword);

          // Add all preconditions and results to doneLines.
          for (p in preconds){
            doneLines.push(preconds[p]);
          }
          for (r in results){
            doneLines.push(results[r]);
          }
        }
      }
    }
    else if (isSimpleRelation(lines[i])){
      assertionsToAdd = [translateSimpleRelation(lines[i])];
      doneLines.push(lines[i]);
    }

    // Add new assertion to final list of all assertions.
    if (assertionsToAdd != null){
      for (var k=0;k<assertionsToAdd.length;k++){
        if (assertionsToAdd[k]!=null){
            assertions.push(assertionsToAdd[k]);
        }
      }
    }
  }
  return assertions;
}

function isIsA(str){
  return str.indexOf(",") == -1;
}

function isInitialize(str){
  return str.indexOf("initialize") != -1;
}
function isPrecondition(str){
  return str.indexOf("precondition") != -1;
}
function isResult(str){
  return str.indexOf("result") != -1;
}
// X(Y,Z).
function isSimpleRelation(str){
  return /\w+\(\w+\,\w+\)\./.test(str);
}

function containsObj(obj, list) {
    var i;
    for (i = 0; i < list.length; i++) {
        if (JSON.stringify(obj) === JSON.stringify(list[i])) {
            return true;
        }
    }
    return false;
}

function findPreconds(lines, keyword){
  arr = [];
  for (var i in lines){
    if (lines[i].substring(0,lines[i].indexOf("("))=="precondition"){
      if (lines[i].substring(lines[i].lastIndexOf(",")+1,lines[i].lastIndexOf(")."))==keyword){
        arr.push(lines[i].substring(12)); // substring removes "precondition" prefix
      }
    }
  }
  return arr;
}

function findResults(lines, keyword){
  arr = [];
  for (var i in lines){
    if (lines[i].substring(0,lines[i].indexOf("("))=="result"){
      if (lines[i].substring(lines[i].indexOf("(")+1,lines[i].indexOf(","))==keyword){
        arr.push(lines[i].substring(6)); // substring removes "precondition" prefix
      }
    }
  }
  return arr;
}

var getKeyword = function(line){
  var keyword = line.substring(line.lastIndexOf(",")+1,line.lastIndexOf(")."));
  return keyword;
}

return {
  translateASP : translateASP
};
});
