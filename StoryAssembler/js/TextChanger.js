/*
  This file provides functions for changing the personality,
  or style, of an input sentence.

  Functions include:
   - shy(sentence)
      * Inserts a filled pause randomly in the given sentence.
      * Example: "This is an example." >> "This is, um, an example."
*/

define([], function() {
  "use strict";

  // Helper for replaceAll.
  function escapeRegExp(string) {
      return string.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
  }

  // Replace all occurences of a string.
  function replaceAll(string, find, replace) {
    return string.replace(new RegExp(escapeRegExp(find), 'g'), replace);
  }

  // Generates a random int between a and b, inclusive.
  function randInt(a,b){return a+Math.floor(Math.random()*(++b-a))}

  // Joins array elements into a String.
  function stringFromArray(arr){
    var punk = [".", "!", ";", ":", ",", "?"];
    var str = arr.join(" ");
    for (var i = 0; i < punk.length; i++) {
      str = replaceAll(str," "+punk[i], punk[i]);
    }
    return str;
  }

  // Inserts a filled pause randomly within a sentence.
  function shy(sentence){
    var finalText = sentence;
    var re = /[\w']+|[.,!?;:]/g;
    var m;
    var arrayToSay = new Array();
    var filledPauses = ["um","er","ah","uh","mm","you know","I mean"];

    // Choose one of the filled pauses at random.
    var fillPause = filledPauses[randInt(0,filledPauses.length-1)];

    while ((m = re.exec(sentence)) !== null) {
        if (m.index === re.lastIndex) {
            re.lastIndex++;
        }
        arrayToSay.push(m[0]);
    }

    // Insert filled pause randomly into sentence.
    if (arrayToSay.length > 3){
      var randMidIndex = randInt(1,arrayToSay.length-2);

      arrayToSay.splice(randMidIndex,0,",");
      arrayToSay.splice(randMidIndex+1,0,fillPause);
      arrayToSay.splice(randMidIndex+2,0,",");

      finalText = stringFromArray(arrayToSay);
      finalText = finalText.replace(",,",",");
      finalText = finalText.replace(",.",".");
    }
  return finalText;
  }

  return {
    shy: shy
  }

});
