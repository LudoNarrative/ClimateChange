#const max_resource_change_per = 4.
#const max_conditions_per = 4.
%%%%% SOUP OF THINGS TO PULL FROM %%%%%


physicsMetaphors(spring;pendulum).

buttons(mouse_button;up_arrow;down_arrow;left_arrow;right_arrow).
buttonStates(pressed;held;released).
controls(cursor). % OTHERS?
controls(BUTTON) :- buttons(BUTTON).

sprites(square;circle;upset_face;anxious_face;happy_face).
colors(red;green;blue;yellow;magenta;cyan;white;light_grey;dark_grey;black).

potentialEntities(e1;e2;e3;e4;e5).
potentialResources(r1;r2;r3;r4;r5).
potentialOutcomes(o1;o2;o3;o4;o5).

constants(low;mid;high).
potentialValues(V) :- constants(V).
potentialChangeableValues(R) :- potentialResources(R).

%potentialValues(R) :-  potentialResources(R).

potentialModes(playing;story_progression;game_loss;game_win).
polarity(true;false).


%%%%%% INITIALIZATIONS %%%%%%%

{entity(ENTITY) : potentialEntities(ENTITY)}.
{resource(RESOURCE) : potentialResources(RESOURCE)}.




1 {initialize(set_to(RESOURCE,CONSTANT)) :
    resource(RESOURCE),
    constants(CONSTANT)} 1 :- 
        resource(RESOURCE).
    
1 {initialize(set_sprite(ENTITY,SPRITE)) :
    entity(ENTITY),
    sprites(SPRITE)} 1 :- 
        entity(ENTITY).

    
1 {initialize(set_color(ENTITY,COLOR)) :
    entity(ENTITY),
    colors(COLOR)} 1 :- 
        entity(ENTITY).
        
%%%%%% PRECONDITIONS %%%%%%%


overlapLogic(ENTITY1,ENTITY2) :- 
    condition(overlaps(ENTITY1,ENTITY2,POLARITY)).
% 2 entities overlap
% {overlapLogic(ENTITY1,ENTITY2) : 
    % entity(ENTITY1),
    % entity(ENTITY2)}.
  
% % if overlap logic, need to actually care about it  
% :- overlapLogic(ENTITY1,ENTITY2), not condition(overlaps(ENTITY1,ENTITY2,POLARITY)),polarity(POLARITY).
% % vice versa
% :- not overlapLogic(ENTITY1,ENTITY2), condition(overlaps(ENTITY1,ENTITY2,POLARITY)).

%anything with a physicsLogic can move
moving(ENTITY) :- physicsLogic(ENTITY,LOGIC).

%if 2 things can overlap, 1 of them must move
:-  overlapLogic(ENTITY1,ENTITY2),
    not moving(ENTITY1),
    not moving(ENTITY2).

%tick can happen
{precondition(tick,OUTCOME) :  potentialOutcomes(OUTCOME)}.

% < can happen - but don't check if something less than itself
{precondition(lt(RESOURCE,CONSTANT),OUTCOME) : 
    resource(RESOURCE), 
    potentialValues(CONSTANT), 
    potentialOutcomes(OUTCOME)} :- 
        resource(RESOURCE), 
        potentialValues(CONSTANT), 
        RESOURCE != CONSTANT.

% > can happen - but don't check if something greater than itself
{precondition(gt(RESOURCE,CONSTANT),OUTCOME) : 
    resource(RESOURCE), 
    potentialValues(CONSTANT), 
    potentialOutcomes(OUTCOME)} :- 
        resource(RESOURCE), 
        potentialValues(CONSTANT), 
        RESOURCE != CONSTANT.

% <= can happen - but don't check if something less than/equal itself
{precondition(le(RESOURCE,CONSTANT),OUTCOME) : 
    resource(RESOURCE), 
    potentialValues(CONSTANT), 
    potentialOutcomes(OUTCOME)} :- 
        resource(RESOURCE), 
        potentialValues(CONSTANT), 
        RESOURCE != CONSTANT.

% >= can happen - but don't check if something greater than/equal itself
{precondition(ge(RESOURCE,CONSTANT),OUTCOME) : 
    resource(RESOURCE), 
    potentialValues(CONSTANT), 
    potentialOutcomes(OUTCOME)} :- 
        resource(RESOURCE), 
        potentialValues(CONSTANT), 
        RESOURCE != CONSTANT.
    
%overlap can happen
    
{precondition(overlaps(ENTITY1,ENTITY2,POLARITY),OUTCOME) : 
    entity(ENTITY1), 
    entity(ENTITY2), 
    potentialOutcomes(OUTCOME),
    polarity(POLARITY)} :- 
        entity(ENTITY1), 
        entity(ENTITY2),
        ENTITY1 != ENTITY2.

%buttons can be pressed 
%- but should only have at most 1 button involved per outcome
{precondition(control_event(BUTTON,STATE),OUTCOME): 
    buttons(BUTTON), 
    buttonStates(STATE), 
    potentialOutcomes(OUTCOME)}.

{physicsLogic(ENTITY, follows(cursor)) :
    entity(ENTITY)}.

{physicsLogic(ENTITY, METAPHOR) :
    entity(ENTITY),
    physicsMetaphors(METAPHOR)}.

    
    
controlLogic(BUTTON) :- precondition(control_event(BUTTON,STATE),OUTCOME).
controlLogic(cursor) :- physicsLogic(ENTITY,follows(CURSOR)).


% outcomes exist if they have both result(s) and precondition(s)  
outcome(OUTCOME) :- 
    result(OUTCOME,EFFECT), 
    precondition(CONDITION,OUTCOME).

    
%%%%%% RESULTS %%%%%%%

%things can increase
{result(OUTCOME,increases(CV,V)) : 
    potentialChangeableValues(CV),
    potentialValues(V), 
    potentialOutcomes(OUTCOME)} 
        :- 
            potentialChangeableValues(CV),
            potentialValues(V),
            V != CV .
            
%things can decrease            
{result(OUTCOME,decreases(CV,V)) : 
    potentialChangeableValues(CV),
    potentialValues(V), 
    potentialOutcomes(OUTCOME)} 
        :- 
            potentialChangeableValues(CV),
            potentialValues(V),
            V != CV .
   
%things can be set to a value            
{result(OUTCOME,set_to(CV,V)) : 
    potentialChangeableValues(CV),
    potentialValues(V), 
    potentialOutcomes(OUTCOME)} 
        :- 
            potentialChangeableValues(CV),
            potentialValues(V),
            V != CV .
            
% mode can change - but only once per outcome
{result(OUTCOME, mode_change(MODE)) : 
    potentialModes(MODE), 
    potentialOutcomes(OUTCOME)} 1 :- potentialOutcomes(OUTCOME).


% VISUALS %

{result(OUTCOME,  set_sprite(ENTITY,SPRITE)) :
    sprites(SPRITE),
    entity(ENTITY), 
    potentialOutcomes(OUTCOME)} 1 :-
        entity(ENTITY),
        potentialOutcomes(OUTCOME).

{result(OUTCOME,  change_color(ENTITY,COLOR,DURATION)) :
    colors(COLOR),
    entity(ENTITY), 
    potentialOutcomes(OUTCOME),
    constants(DURATION)} 1 :- 
        potentialOutcomes(OUTCOME),
        entity(ENTITY).
    
    
%%%% OUTCOMES %%%%

changes(OUTCOME,increases,CV,V) :- result(OUTCOME,increases(CV,V)).
changes(OUTCOME,decreases,CV,V) :- result(OUTCOME,decreases(CV,V)).
changes(OUTCOME,decreases,CV,V) :- result(OUTCOME,set_to(CV,V)).

condition(CONDITION) :- precondition(CONDITION).

change(increases;decreases).


% CONSTRAINTS

:- max_resource_change_per + 1  {changes(OUTCOME,CHANGE, CV,V) :
    potentialChangeableValues(CV),
    potentialValues(V), 
    change(CHANGE)}, 
        outcome(OUTCOME).
:-  2 {changes(OUTCOME,CHANGE,CV,V)}, 
    outcome(OUTCOME), 
    potentialChangeableValues(CV).        
        
        
        
        

3 {outcome(OUTCOME) : outcome(OUTCOME)}.

:- goal(prevent(OUTCOME)), goal(achieve(OUTCOME)).


controlLogic :- controlLogic(CONTROLS).
:- not controlLogic.
%:- {controlLogic(CONTROLS) : controls(CONTROLS)} 0.

        
%tick must occur alone
:-  precondition(tick,OUTCOME), 
    2 { precondition(CONDITION,OUTCOME) : condition(CONDITION)}.
 
% no precondition without outcome 
:-  precondition(CONDITION,OUTCOME), 
    not outcome(OUTCOME).
% no result without outcome    
:-  result(OUTCOME,EFFECT), 
    not outcome(OUTCOME).
    
% don't care about more than 1 button at a time
:- 2 {precondition(control_event(BUTTON,STATE),OUTCOME): 
    buttons(BUTTON), 
    buttonStates(STATE), 
    potentialOutcomes(OUTCOME)}, outcome(OUTCOME).
    
different(OUTCOME1,OUTCOME2) :- 
    precondition(CONDITION1,OUTCOME1),
    precondition(CONDITION2,OUTCOME2),
    CONDITION1 != CONDITION2,
    OUTCOME1 != OUTCOME2.
    
:-  not different(OUTCOME1,OUTCOME2), 
    outcome(OUTCOME1),outcome(OUTCOME2), 
    OUTCOME1 != OUTCOME2.
    
:- max_conditions_per {precondition(CONDITION,OUTCOME)}, outcome(OUTCOME).

:- 2 {precondition(overlaps(E1,E2),OUTCOME) :
    entity(E1),entity(E2)}, 
        outcome(OUTCOME).
        
:-  precondition(le(RESOURCE,VALUE),OUTCOME), 
    precondition(lt(RESOURCE,VALUE2),OUTCOME).
    
:-  precondition(ge(RESOURCE,VALUE),OUTCOME), 
    precondition(gt(RESOURCE,VALUE2),OUTCOME).
    
below(RESOURCE,VALUE,OUTCOME) :- 
    precondition(le(RESOURCE,VALUE),OUTCOME).

below(RESOURCE,VALUE,OUTCOME) :-     
    precondition(lt(RESOURCE,VALUE),OUTCOME).
    
above(RESOURCE,VALUE,OUTCOME) :- 
    precondition(ge(RESOURCE,VALUE),OUTCOME).
above(RESOURCE,VALUE,OUTCOME) :- 
    precondition(gt(RESOURCE,VALUE),OUTCOME).

    
lower_than(low,mid).
lower_than(low,high).
lower_than(mid,high).
:-  below(RESOURCE,VALUE_L,OUTCOME), 
    above(RESOURCE,VALUE_H,OUTCOME), 
    lower_than(VALUE_L,VALUE_H).