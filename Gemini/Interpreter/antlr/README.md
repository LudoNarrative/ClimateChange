
To develop the Antlr-generated parser, download Antlr and add it to your classpath. 

To have Antlr generate a lexer and parser (in Java):

	antlr Cygnus.g4
	javac Cygnus*.java

Test using:

	grun Cygnus game tests/syntax.lp -gui

or

	grun Cygnus game tests/syntax.lp -tree

Or generate a lexer and parser in Javascript: 

	antlr -Dlanguage=JavaScript Cygnus.g4


