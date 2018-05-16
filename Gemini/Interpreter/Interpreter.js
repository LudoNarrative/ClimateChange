/*
 * Main interpreter program
 */

var Interpreter = ( function () {

    const antlr4 = require('./antlr4/index');
    const CygnusLexer = require('./CygnusLexer');
    const CygnusParser = require('./CygnusParser');
    const GameListener = require('./GameListener').GameListener;


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
    
        var data = new Collector();
    
        var gameListener = new GameListener(data);
        antlr4.tree.ParseTreeWalker.DEFAULT.walk(gameListener, tree);
    
        console.log("Game entities:",data.getEntities());
        console.log("Game resources:",data.getResources());
        console.log("Game pools:",data.getPools());
        console.log("Game rules:",data.getRules());

        initGame(data);
    
    }

    function initGame (data) {



        PhaserDriver.init(data);
    }
    
    /* 
     * Called by the driver with the current state object, 
     * conditions checked by the driver, and the difference between now and last step time
     */
    function step (currentState, externalConditions, deltaTime) {

        // Clone current state


        // Check conditions
        //checkInternalConditions (currentState);


        // Apply outcomes for triggered rules

        
        // Update entity state (velocity, acceleration, etc)
        // (Position updates are handled by the driver)


        // Return next state

    }

    function checkInternalConditions (currentState) {

        //for 

    }

    return {
        openFile : openFile,
        step : step
    }

})(); 