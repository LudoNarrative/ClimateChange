
grammar Cygnus;

/* Parser Rules */

game : declaration+ EOF ; // A game is made up of one or more declarations

declaration  : 	
	( entitydecl 
	| resourcedecl 
	| flagdecl 
	| labeldecl
	| singulardecl
	| manydecl
	| boundarydecl
	//| initialize
	//| timer
	//| pool
	//| precondition
	//| result
	) '.'; // A declaration always has a period at the end


entitydecl 	 : 'entity' '(' identifier ')';
resourcedecl : 'resource' '(' identifier ')';
flagdecl 	 : 'flag' '(' identifier ')';

labeldecl 
	: 'label' '(' resourcedecl ',' label ',' privacymode ')'
	| 'label' '(' entitydecl ',' label ')'
	;

singulardecl : 'singular' '(' entitydecl ')';
manydecl 	 : 'many' '(' entitydecl ')';

boundarydecl : 'boundary' '(' boundarytype ')';

privacymode  : 'read' | 'write' | 'private'; 
boundarytype : 'closed' | 'torus';

// TODO: a label can't have spaces right now (WS ignored). Do we want to allow?
label // A resource or entity label can be in quotes or not
	: identifier
	| '"' identifier '"'
	;

identifier
	: ID
	| ID '(' ID ')'
	;

ID: ([a-z]|[A-Z]|[0-9]|'_')+ ; 
WS : [ \t\r\n]+ -> skip ; // skip spaces, tabs, newlines
