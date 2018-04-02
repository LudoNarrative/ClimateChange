
grammar Cygnus;

/* Parser Rules */

// A game is made up of one or more declarations 
// (TODO: followed by an optional instructions section, which is skipped)
game : declaration* comment_section? EOF ; 

declaration  
	: 	
	( entity 
	| resource 
	| flag 
	| label
	| singular
	| many
	| boundary
	| control_logic // (Redundant with initialize(set_draggable(..)). Will be removed from Cygnus eventually)
	| timer_logic
	| pool

	| initialize
	| precondition
	| result

	| reading // Reading rules are not technically in the Cygnus language, but often exported with them
	) '.'; // A declaration always has a period at the end

comment_section : separator .* ;

separator : '='+ ;

entity 	 : 'entity' '(' identifier ')';
resource : 'resource' '(' identifier ')';
flag 	 : 'flag' '(' identifier ')';
timer 	 : 'timer' '(' identifier ')';

property : 'property' '(' entity ',' identifier ')';

label 
	: 'label' '(' resource ',' label_name ',' privacy_mode ')'
	| 'label' '(' entity ',' label_name ')'
	;

singular : 'singular' '(' entity ')';
many 	 : 'many' '(' entity ')';
boundary : 'boundary' '(' boundary_type ')';

control_logic : 'controlLogic' '(' 'draggable' '(' entity ')' ')';

timer_logic : 'timer_logic' '(' timer ',' value ',' loop_type ')';

initialize   : 'initialize' '(' action ')'
			 | 'initialize' '(' initial_only_action ')'
			 ;

precondition : 'precondition' '(' condition ',' outcome_name ')';
result		 : 'result' '(' outcome_name ',' action ')';



// TODO: a label can't have spaces right now (WS ignored). Decide whether we want to allow.
label_name // A resource or entity label can be in quotes or not
	: identifier
	| '"' identifier '"'
	;

outcome_name 
	: 'outcome' '(' identifier ')'
	| 'tick'
	;

identifier
	: WORD
	| WORD '(' WORD ')'
	| WORD '(' NUM ')' // An identifier can't be a number by itself, but can have a nested number, e.g., 'e(1)''
	;

condition 
	: 'ge' '(' value ',' value ')'
	| 'le' '(' value ',' value ')'
	| 'overlaps' '(' entity ',' entity ',' bool ')'
	| 'control_event' '(' control_event ')'
	| 'timer_elapsed' '(' (timer|identifier) ')' // Should require timer only - need to fix in Gemini.
	| 'tick'
	; 

initial_only_action : 'set_static' '(' entity ',' bool ')'; 

action 
	: 'add' '(' entity ',' value ',' point ')'
	| 'delete' '(' entity ')' 
	| 'draw' '(' point ',' WORD ')' // WORD should be a color
	| 'clear' '(' point ')'
	| 'fill' '(' 'all' ',' WORD ')' // WORD should be a color

	| 'increase' '(' settable ',' value ')'
	| 'decrease' '(' settable ',' value ')'
	| 'increase_over_time' '(' settable ',' value ')'
	| 'decrease_over_time' '(' settable ',' value ')'

	| 'set_value' '(' settable ',' value ')'
	| 'set_point' '(' settable_point ',' point ')'
	| 'set_bool' '(' settable_bool ',' bool ')'

	| 'moves' '(' entity ',' direction ',' value ')' // For consistency, consider changing to 'move'
	| 'move_toward' '(' entity ',' point ',' value ')'
	| 'move_away' '(' entity ',' point ',' value ')'

	| 'set_acceleration' '(' entity ',' ( direction | point ) ',' value ')' 
	| 'apply_restitution' '(' entity ',' entity ')'
	| 'rotates' '(' entity ',' angular_direction ',' value ')' // Consider changing to 'rotate'
	| 'rotate_to' '(' entity ',' value ')' // Red in BNF but used in games now.
	| 'look_at' '(' entity ',' point ',' look_criterion ')'

	| 'set_sprite' '(' entity ',' WORD ')' // WORD should be a sprite
	| 'set_color' '(' entity ',' WORD ')' // WORD should be a color
	| 'set_size' '(' entity ',' value ')' // Red in BNF
	| 'set_bounce' '(' entity ',' value ')' // Red in BNF
	| 'set_draggable' '(' entity ',' bool ')'

	| 'mode_change' '(' WORD ')' // WORD should be a mode
	;

value 
	: scalar
	| 'amount' '(' (WORD|'clear') ')' // WORD should specify a color that the interpreter's graphics module can represent (checked later)
	| 'distance' '(' entity ',' entity ',' look_criterion ')'
	| 'random_int' '(' scalar ',' scalar ')' // Red in BNF - may not be implemented in Gemini, compiler, or both
	| settable
	;

scalar : 'scalar' '(' NUM ')';

settable 		: resource | property |  ;
settable_point 	: entity | property ; // Is an entity property only settable as a point if it's a point type? 
settable_bool	: flag | property ; // ""

point
	: location
	| 'cursor'
	| pool
	| settable_point
	;

bool : BOOL | settable_bool ;

location : 'location' '(' row ',' col ')' ;

pool 
	: 'pool' '(' entity ',' location ',' spawn_type ',' spawn_type ')'
	| 'pool' '(' entity ')'
	;

control_event 
	: 'click' '(' entity ')'
	| 'button' '(' button ',' button_state ')'
	;

privacy_mode  	: 'read' | 'write' | 'private'; 
boundary_type 	: 'closed' | 'torus';
look_criterion 	: 'nearest' | 'furthest' | 'random';
spawn_type 		: 'random' | 'ordered';
loop_type		: 'loop' | 'once' | 'repeat'; // 'once' and 'repeat' are red in BNF

direction 		: 'forward' | 'backward' | 'left' | 'right' | 'north' | 'south' | 'east' | 'west' ; // west is red in BNF
row 			: 'top' | 'middle' | 'bottom';
col 			: 'left' | 'center' | 'right';
angular_direction : 'cw' | 'ccw';

button 			: 'mouse' | 'key_up' | 'key_down' | 'key_left' | 'key_right' | 'key_space' ;
button_state 	: 'pressed' | 'held' | 'released' ;

reading : 'reading' '(' .*? ',' .*? ')';

BOOL: 'true' | 'false';

NUM : [0-9]+;

WORD: ([a-z]|[A-Z]|[0-9]|'_')+ ; 
WS : [ \t\r\n]+ -> skip ; // skip spaces, tabs, newlines

COMMENT: '%' ~[\n\r]* ( [\n\r] | EOF) -> channel(HIDDEN) ;
MULTILINE_COMMENT: '/*' ( MULTILINE_COMMENT | . )*? ('*/' | EOF) -> channel(HIDDEN);

ANYCHAR : . ;

