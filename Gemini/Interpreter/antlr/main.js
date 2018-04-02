

const antlr4 = require('./antlr4/index');
const CygnusLexer = require('./CygnusLexer');
const CygnusParser = require('./CygnusParser');
//const GameListener = require('./GameListener').GameListener;

// Called when the file chooser form input is submitted
function openFile (event) {
    var input = event.target;

    var reader = new FileReader();

    reader.onload = function() {

        var contents = reader.result;
        parseGame (contents);

        // Append game file text to window
        var output = document.getElementById('output');
        output.textContent = contents;

    };

    reader.readAsText(input.files[0]);
}

function parseGame (gamefile) {

    var gametext = gamefile; 
  
    var chars = new antlr4.InputStream(gametext);
    var lexer = new CygnusLexer.CygnusLexer(chars);
    var tokens = new antlr4.CommonTokenStream(lexer);
    var parser = new CygnusParser.CygnusParser(tokens);

    parser.buildParseTrees = true;
    var tree = parser.game();
    console.log("Parsed:",tree);
    
    //var gameListener = new GameListener(response);
    //antlr4.tree.ParseTreeWalker.DEFAULT.walk(gameListener, tree);
}
