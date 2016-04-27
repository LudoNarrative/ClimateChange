#const max_resource_change_per = 4.
#const max_conditions_per = 4.


%%%%%% INITIALIZATIONS %%%%%%%

min_entities {entity(ENTITY) : potentialEntities(ENTITY)} max_entities.
min_resources {resource(RESOURCE) : potentialResources(RESOURCE)} max_resources.
min_outcomes {outcome(OUTCOME) : potentialOutcomes(OUTCOME)} max_outcomes.



% Setting a resource is weird - need to think about where it should exist
% 1 {initialize(set_to(RESOURCE,CONSTANT)) :
    % resource(RESOURCE),
    % constants(CONSTANT)} 1 :- 
        % resource(RESOURCE).
    
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
    
{many(ENTITY): entity(ENTITY)}.
{singular(ENTITY): entity(ENTITY)}.

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

    
{physicsLogic(ENTITY,mapping(control_event(BUTTON,STATE),DIRECTION,AMOUNT)) :
    entity(ENTITY),
    buttons(BUTTON),
    buttonStates(STATE),
    direction(DIRECTION),
    constants(AMOUNT)} .
    
controlLogic(BUTTON) :- precondition(control_event(BUTTON,STATE),OUTCOME).
controlLogic(cursor) :- physicsLogic(ENTITY,follows(cursor)).

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
