
To develop the Antlr-generated parser, download Antlr and add it to your classpath. 

## To have Antlr generate a lexer and parser (in Java):

	antlr Cygnus.g4
	javac Cygnus*.java

(or `make`)

## Test using:

	grun Cygnus game tests/syntax.lp -gui

(or `make javatest`)

or

	grun Cygnus game tests/syntax.lp -tree

## When you're satisfied with your Java lexer/parser, generate a Javascript version: 

	antlr -Dlanguage=JavaScript Cygnus.g4
