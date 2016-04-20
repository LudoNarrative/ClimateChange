#const max_resource_change_per = 4.



physicsMetaphors(spring;pendulum).

buttons(mouse_button;up_arrow;down_arrow;left_arrow;right_arrow).
buttonStates(pressed;held;released).

images(square;circle;upset_face;anxious_face;happy_face).
potentialEntities(e1;e2;e3;e4;e5).
potentialResources(r1;r2;r3;r4;r5).
potentialOutcomes(o1;o2;o3;o4;o5).
constants(1).
potentialValues(V) :- constants(V).
potentialChangeableValues(R) :- potentialResources(R).
%potentialChangeableValues(sub(E,R)) :- potentialEntities(E), potentialResources(R).

%potentialValues(sub(E,R)) :- potentialEntities(E), potentialResources(R).
potentialValues(R) :-  potentialResources(R).

potentialModes(playing;story_progression;game_loss;game_win).


{overlapLogic(ENTITY1,ENTITY2) : 
    potentialEntities(ENTITY1),
    potentialEntities(ENTITY2)}.
    
:- overlapLogic(ENTITY1,ENTITY2), not condition(overlaps(ENTITY1,ENTITY2)).

:- not overlapLogic(ENTITY1,ENTITY2), condition(overlaps(ENTITY1,ENTITY2)).

moving(ENTITY) :- physicsLogic(ENTITY,LOGIC).

:-  overlapLogic(ENTITY1,ENTITY2),
    not moving(ENTITY1),
    not moving(ENTITY2).

{precondition(tick,OUTCOME) :  potentialOutcomes(OUTCOME)}.

{precondition(below(RESOURCE,CONSTANT),OUTCOME) : 
    potentialResources(RESOURCE), 
    potentialValues(CONSTANT), 
    potentialOutcomes(OUTCOME)}.

{precondition(above(RESOURCE,CONSTANT),OUTCOME) : 
    potentialResources(RESOURCE), 
    potentialValues(CONSTANT), 
    potentialOutcomes(OUTCOME)}.

{precondition(overlaps(ENTITY1,ENTITY2),OUTCOME) : 
    potentialEntities(ENTITY1), 
    potentialEntities(ENTITY2), 
    potentialOutcomes(OUTCOME)}.

{precondition(control_event(BUTTON,STATE,OUTCOME)): 
    buttons(BUTTON), 
    buttonStates(STATE), 
    potentialOutcomes(OUTCOME)} 1 :- buttons(BUTTON),potentialOutcomes(OUTCOME).


:-  precondition(tick,OUTCOME), 
    2 { precondition(CONDITION,OUTCOME) : condition(CONDITION)}.
    
:-  precondition(CONDITION,OUTCOME), 
    not outcome(OUTCOME).
    
:-  result(OUTCOME,EFFECT), 
    not outcome(OUTCOME).

outcome(OUTCOME) :- 
    result(OUTCOME,EFFECT), 
    precondition(CONDITION,OUTCOME).


{result(OUTCOME,increases(CV,V)) : 
    potentialChangeableValues(CV),
    potentialValues(V), 
    potentialOutcomes(OUTCOME)} 
        :- 
            potentialChangeableValues(CV),
            potentialValues(V),
            V != CV.
            
{result(OUTCOME,decreases(CV,V)) : 
    potentialChangeableValues(CV),
    potentialValues(V), 
    potentialOutcomes(OUTCOME)} 
        :- 
            potentialChangeableValues(CV),
            potentialValues(V),
            V != CV.

changes(OUTCOME,increases,CV,V) :- result(OUTCOME,increases(CV,V)).
changes(OUTCOME,decreases,CV,V) :- result(OUTCOME,decreases(CV,V)).

condition(CONDITION) :- precondition(CONDITION).

change(increases;decreases).

:- max_resource_change_per  {changes(OUTCOME,CHANGE, CV,V) :
    potentialChangeableValues(CV),
    potentialValues(V), 
    change(CHANGE)}, 
        outcome(OUTCOME).