define(["translateAsp", "rensa", "ctp", "translatePhaserBrain"], function(translateAsp, rensa, ctp, translatePhaserBrain) {

//var translateAsp = require('./src/asp-to-cygnus');
//var rensa = require('./src/brain');
//var ctp = require('./src/cygnus-to-phaser-brain');
//var translatePhaserBrain = require('./src/phaser-brain-to-code');

function AspPhaserGenerator(generatedAsp, initialPhaserFile) {
  
  var newGenerator = {};
  // Read each line of the ASP game.
  var lines = generatedAsp.split('\n');
  // For each line read, remove any extra spaces,
  //  and add a period at the end if there isn't one.
  for (var i=0; i<lines.length;i++){
    lines[i] = lines[i].replace(/\s+/g, '');
    if (lines[i]!="" && lines[i].slice(-1)!="."){
      lines[i] = lines[i]+".";
    }    
  }
  // Store the ASP game.
  newGenerator.aspGame = lines;

  // Store the initial Phaser file as a brain.
  newGenerator.initialPhaser = rensa.makeBrain(initialPhaserFile);

  return newGenerator
}

var generate = function(aspGame, initialPhaser, debug) {
  // Create a Rensa brain from literal ASP.
  var cygnus = rensa.makeBrain(translateAsp.translateASP(aspGame));

  // Translate this brain into Phaser Abstract Syntax given some initial Phaser assertions.
  var generatedPhaserBrain = ctp.cygnusToPhaser(initialPhaser, cygnus);

  // Write a Phaser program using this brain.
  var gameProgram = translatePhaserBrain.writePhaserProgram(generatedPhaserBrain);

  // If debug flag is true, show output at each step.
  if (debug){
    console.log("\n------------------------------");
    console.log("Initial Phaser Brain: ");
    console.log("------------------------------");
    initialPhaser.prettyprint();
    console.log("\n------------------------------");
    console.log("Cygnus Brain: ");
    console.log("------------------------------");
    cygnus.prettyprint();
    console.log("\n------------------------------");
    console.log("Generated Phaser Brain: ");
    console.log("------------------------------");
    generatedPhaserBrain.prettyprint();
  }
  return gameProgram;
};

return {
  AspPhaserGenerator : AspPhaserGenerator,
  generate : generate
}
});
