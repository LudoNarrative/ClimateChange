
java:
	java -cp /usr/local/lib/antlr-4.7.1-complete.jar:. org.antlr.v4.Tool *.g4
	javac -cp /usr/local/lib/antlr-4.7.1-complete.jar:. *.java

js: 
	java -cp /usr/local/lib/antlr-4.7.1-complete.jar:. org.antlr.v4.Tool -Dlanguage=JavaScript *.g4

javatest:
	java -cp /usr/local/lib/antlr-4.7.1-complete.jar:. org.antlr.v4.gui.TestRig Cygnus game tests/syntax.lp -gui
	
spotless: clean
	rm CygnusListener.js *Lexer.js *Parser.js 

clean:
	rm *.interp *.tokens *.java *.class 
