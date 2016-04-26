#const max_resource_change_per = 4.
#const max_conditions_per = 4.

%%%%% SOUP OF THINGS TO PULL FROM %%%%%


physicsMetaphors(spring;pendulum).

buttons(mouse_button;space;up_arrow;down_arrow;left_arrow;right_arrow).
buttonOrder(mouse_button,up_arrow).
buttonOrder(space,up_arrow).
buttonOrder(up_arrow,down_arrow).
buttonOrder(down_arrow,left_arrow).
buttonOrder(left_arrow,right_arrow).
buttonOrder(A,C) :- buttonOrder(A,B), buttonOrder(B,C).
buttonStates(pressed;held;released).
controls(cursor). % OTHERS?
controls(BUTTON) :- buttons(BUTTON).

sprites(square;circle;upset_face;anxious_face;happy_face).
colors(red;green;blue;yellow;magenta;cyan;white;light_grey;dark_grey;black).

potentialEntities(e1;e2;e3;e4;e5).
entityOrdering(e1,e2).
entityOrdering(e2,e3).
entityOrdering(e3,e4).
entityOrdering(e4,e5).
entityOrdering(A,C) :- entityOrdering(A,B), entityOrdering(B,C).

potentialResources(r1;r2;r3;r4;r5).
potentialOutcomes(o1;o2;o3;o4;o5).
outcomeOrder(o1,o2).
outcomeOrder(o2,o3).
outcomeOrder(o3,o4).
outcomeOrder(o4,o5).
outcomeOrder(A,C) :- outcomeOrder(A,B), outcomeOrder(B,C).

constants(low;mid;high).
potentialValues(V) :- constants(V).

%potentialValues(R) :-  potentialResources(R).

potentialModes(playing;story_progression;game_loss;game_win).
polarity(true;false).


%%%%%% INITIALIZATIONS %%%%%%%

min_entities {entity(ENTITY) : potentialEntities(ENTITY)} max_entities.
min_resources {resource(RESOURCE) : potentialResources(RESOURCE)} max_resources.
min_outcomes {outcome(OUTCOME) : potentialOutcomes(OUTCOME)} max_outcomes.




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
{precondition(tick,OUTCOME) :  outcome(OUTCOME)}.

% < can happen - but don't check if something less than itself
{precondition(lt(RESOURCE,CONSTANT),OUTCOME) : 
    resource(RESOURCE), 
    potentialValues(CONSTANT), 
    outcome(OUTCOME)} :- 
        resource(RESOURCE), 
        potentialValues(CONSTANT), 
        RESOURCE != CONSTANT.

% > can happen - but don't check if something greater than itself
{precondition(gt(RESOURCE,CONSTANT),OUTCOME) : 
    resource(RESOURCE), 
    potentialValues(CONSTANT), 
    outcome(OUTCOME)} :- 
        resource(RESOURCE), 
        potentialValues(CONSTANT), 
        RESOURCE != CONSTANT.

% <= can happen - but don't check if something less than/equal itself
{precondition(le(RESOURCE,CONSTANT),OUTCOME) : 
    resource(RESOURCE), 
    potentialValues(CONSTANT), 
    outcome(OUTCOME)} :- 
        resource(RESOURCE), 
        potentialValues(CONSTANT), 
        RESOURCE != CONSTANT.

% >= can happen - but don't check if something greater than/equal itself
{precondition(ge(RESOURCE,CONSTANT),OUTCOME) : 
    resource(RESOURCE), 
    potentialValues(CONSTANT), 
    outcome(OUTCOME)} :- 
        resource(RESOURCE), 
        potentialValues(CONSTANT), 
        RESOURCE != CONSTANT.
    
%overlap can happen
    
{precondition(overlaps(ENTITY1,ENTITY2,POLARITY),OUTCOME) : 
    entity(ENTITY1), 
    entity(ENTITY2), 
    outcome(OUTCOME),
    polarity(POLARITY)} :- 
        entity(ENTITY1), 
        entity(ENTITY2),
        ENTITY1 != ENTITY2.

%buttons can be pressed 
%- but should only have at most 1 button involved per outcome
{precondition(control_event(BUTTON,STATE),OUTCOME): 
    buttons(BUTTON), 
    buttonStates(STATE), 
    outcome(OUTCOME)}.

{physicsLogic(ENTITY, follows(cursor)) :
    entity(ENTITY)}.

{physicsLogic(ENTITY, METAPHOR) :
    entity(ENTITY),
    physicsMetaphors(METAPHOR)}.

    
    
controlLogic(BUTTON) :- precondition(control_event(BUTTON,STATE),OUTCOME).
controlLogic(cursor) :- physicsLogic(ENTITY,follows(cursor)).

:- 2{ physicsLogic(ENTITY,follows(cursor)) : entity(ENTITY)}.

% outcomes exist if they have both result(s) and precondition(s)  

    
%%%%%% RESULTS %%%%%%%

%things can increase
{result(OUTCOME,increases(CV,V)) : 
    resource(CV),
    potentialValues(V), 
    outcome(OUTCOME)} 
        :- 
            resource(CV),
            potentialValues(V),
            V != CV .
            
%things can decrease            
{result(OUTCOME,decreases(CV,V)) : 
    resource(CV),
    potentialValues(V), 
    outcome(OUTCOME)} 
        :- 
            resource(CV),
            potentialValues(V),
            V != CV .
   
%things can be set to a value            
{result(OUTCOME,set_to(CV,V)) : 
    resource(CV),
    potentialValues(V), 
    outcome(OUTCOME)} 
        :- 
            resource(CV),
            potentialValues(V),
            V != CV .
            
% mode can change - but only once per outcome
{result(OUTCOME, mode_change(MODE)) : 
    potentialModes(MODE), 
    outcome(OUTCOME)} 1 :- outcome(OUTCOME).


% VISUALS %

{result(OUTCOME,  set_sprite(ENTITY,SPRITE)) :
    sprites(SPRITE),
    entity(ENTITY), 
    outcome(OUTCOME)} 1 :-
        entity(ENTITY),
        outcome(OUTCOME).

{result(OUTCOME,  change_color(ENTITY,COLOR,DURATION)) :
    colors(COLOR),
    entity(ENTITY), 
    outcome(OUTCOME),
    constants(DURATION)} 1 :- 
        outcome(OUTCOME),
        entity(ENTITY).
    
  
changes(RESOURCE,OUTCOME) :- result(OUTCOME,increases(RESOURCE,AMOUNT1)).
changes(RESOURCE,OUTCOME) :- result(OUTCOME,decreases(RESOURCE,AMOUNT2)).
changes(RESOURCE,OUTCOME) :- result(OUTCOME,set_to(RESOURCE,AMOUNT3)).
    
%%%% OUTCOMES %%%%

changes(OUTCOME,increases,CV,V) :- result(OUTCOME,increases(CV,V)).
changes(OUTCOME,decreases,CV,V) :- result(OUTCOME,decreases(CV,V)).
changes(OUTCOME,set_to,CV,V) :- result(OUTCOME,set_to(CV,V)).

condition(CONDITION) :- precondition(CONDITION,OUTCOME).

change(increases;decreases;set_to).


% CONSTRAINTS

:- max_resource_change_per + 1  {changes(OUTCOME,CHANGE, CV,V) :
    resource(CV),
    potentialValues(V), 
    change(CHANGE)}, 
        outcome(OUTCOME).
:-  2 {changes(OUTCOME,CHANGE,CV,V)}, 
    outcome(OUTCOME), 
    resource(CV).        
        
        
:- goal(prevent(OUTCOME)), goal(achieve(OUTCOME)).

:- bad(RESOURCE), good(RESOURCE).

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
    outcome(OUTCOME)}, outcome(OUTCOME).

same(OUTCOME1, OUTCOME2) :- 
    precondition(CONDITION,OUTCOME1),
    precondition(CONDITION,OUTCOME2),
    outcomeOrder(OUTCOME1,OUTCOME2).
    
different(OUTCOME1,OUTCOME2) :- 
    precondition(CONDITION,OUTCOME1),
    not precondition(CONDITION,OUTCOME2),
    condition(CONDITION),
    outcomeOrder(OUTCOME1,OUTCOME2),
    same(OUTCOME1,OUTCOME2).

    
:-  not different(OUTCOME1,OUTCOME2), 
    outcome(OUTCOME1),outcome(OUTCOME2),
    outcomeOrder(OUTCOME1,OUTCOME2),
    same(OUTCOME1,OUTCOME2). 
    
:- max_conditions_per {precondition(CONDITION,OUTCOME)}, outcome(OUTCOME).

:- 2 {precondition(overlaps(E1,E2,POLARITY),OUTCOME) :
    entity(E1),entity(E2),polarity(POLARITY)}, 
        outcome(OUTCOME).
        
:-  2 {precondition(le(RESOURCE,VALUE),OUTCOME) :
            potentialValues(VALUE)}, 
        outcome(OUTCOME), 
        resource(RESOURCE).

:-  2 {precondition(lt(RESOURCE,VALUE),OUTCOME) :
            potentialValues(VALUE)}, 
        outcome(OUTCOME), 
        resource(RESOURCE).
        
:-  2 {precondition(ge(RESOURCE,VALUE),OUTCOME) :
            potentialValues(VALUE)}, 
        outcome(OUTCOME), 
        resource(RESOURCE).
        
:-  2 {precondition(gt(RESOURCE,VALUE),OUTCOME) :
            potentialValues(VALUE)}, 
        outcome(OUTCOME), 
        resource(RESOURCE).
    
:-  precondition(le(RESOURCE,VALUE),OUTCOME), 
    precondition(lt(RESOURCE,VALUE2),OUTCOME).
    
:-  precondition(ge(RESOURCE,VALUE),OUTCOME), 
    precondition(gt(RESOURCE,VALUE2),OUTCOME).

result_outcome(OUTCOME) :-     result(OUTCOME,EFFECT).
precondition_outcome(OUTCOME) :-     precondition(CONDITION,OUTCOME).
validOutcome(OUTCOME) :- result_outcome(OUTCOME), 
    precondition_outcome(OUTCOME).
:- outcome(OUTCOME), not validOutcome(OUTCOME).

 
below(RESOURCE,VALUE,OUTCOME) :- 
    precondition(le(RESOURCE,VALUE),OUTCOME).

below(RESOURCE,VALUE,OUTCOME) :-     
    precondition(lt(RESOURCE,VALUE),OUTCOME).
    
above(RESOURCE,VALUE,OUTCOME) :- 
    precondition(ge(RESOURCE,VALUE),OUTCOME).
above(RESOURCE,VALUE,OUTCOME) :- 
    precondition(gt(RESOURCE,VALUE),OUTCOME).

conditionedOnResource(RESOURCE,OUTCOME) :- above(RESOURCE,VALUE,OUTCOME).
conditionedOnResource(RESOURCE,OUTCOME) :- below(RESOURCE,VALUE,OUTCOME).
  
  
lower_than(low,mid).
lower_than(low,high).
lower_than(mid,high).
:-  below(RESOURCE,VALUE_L,OUTCOME), 
    above(RESOURCE,VALUE_H,OUTCOME), 
    lower_than(VALUE_L,VALUE_H).

:- controlLogic(BUTTON), not controlLogic(BUTTON_H), buttonOrder(BUTTON_H,BUTTON).

:- condition(overlaps(A,B,POLARITY)), entityOrdering(B,A).

:- conditionedOnResource(RESOURCE,OUTCOME1), not changes(RESOURCE,OUTCOME2), OUTCOME1 != OUTCOME2, outcome(OUTCOME2).

end_mode(game_loss;game_win).

effect(EFFECT) :- result(OUTCOME,EFFECT).

:-  result(OUTCOME,mode_change(END)), 
    end_mode(END),
    2 {result(OUTCOME,EFFECT) : effect(EFFECT)}.
    
:-  precondition(control_event(BUTTON,STATE),OUTCOME),
    result(OUTCOME,mode_change(END)), 
    end_mode(END).
    
:-  precondition(tick,OUTCOME), 
    result(OUTCOME,set_to(RESOURCE,VALUE)).
:-  precondition(tick,OUTCOME), 
    result(OUTCOME,mode_change(MODE)).
:-  precondition(tick,OUTCOME), 
    result(OUTCOME,change_color(ENTITY,COLOR,TIME)).
:-  precondition(tick,OUTCOME), 
    result(OUTCOME,set_sprite(ENTITY,SPRITE)).
    
:-  precondition(tick,OUTCOME),
    changes(OUTCOME,CHANGE,CV,high).
:-  precondition(tick,OUTCOME),
    changes(OUTCOME,CHANGE,CV,mid).