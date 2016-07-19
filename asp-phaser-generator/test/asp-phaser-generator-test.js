var test = require('tape');
var fs = require('fs');
var AspPhaserGenerator = require('../index');
var aspGame = fs.readFileSync('./fixtures/asp-game-1.lp', 'utf8');
var initialPhaserFile = fs.readFileSync('./fixtures/initial-phaser-file.json', 'utf8');

test('given an ASP game, it generates a string', function (t) {
  var output = new AspPhaserGenerator(aspGame,initialPhaserFile).generate();
  t.equal('string', typeof output);
  t.end();
});
