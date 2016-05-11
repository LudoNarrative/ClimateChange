
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

controlLogicBool :- controlLogic(CONTROLS).
:- not controlLogicBool.
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

% 2 outcomes are the same if they share a precondition
same(OUTCOME1, OUTCOME2) :- 
    precondition(CONDITION,OUTCOME1),
    precondition(CONDITION,OUTCOME2),
    outcomeOrder(OUTCOME1,OUTCOME2).
  
% 2 outcomes are different if one has a precondition the other doesn't  
differentL(OUTCOME1,OUTCOME2) :- 
    precondition(CONDITION,OUTCOME1),
    not precondition(CONDITION,OUTCOME2),
    condition(CONDITION),
    outcomeOrder(OUTCOME1,OUTCOME2),
    same(OUTCOME1,OUTCOME2).
  
%vice versa  
differentR(OUTCOME1,OUTCOME2) :- 
    not precondition(CONDITION,OUTCOME1),
    precondition(CONDITION,OUTCOME2),
    condition(CONDITION),
    outcomeOrder(OUTCOME1,OUTCOME2),
    same(OUTCOME1,OUTCOME2).
    
% outcomes must be different - perhaps this is overly strong
% should subsets be allowed?  
:-  not differentL(OUTCOME1,OUTCOME2), 
    outcome(OUTCOME1),outcome(OUTCOME2),
    outcomeOrder(OUTCOME1,OUTCOME2),
    same(OUTCOME1,OUTCOME2). 
 
:-  not differentR(OUTCOME1,OUTCOME2), 
    outcome(OUTCOME1),outcome(OUTCOME2),
    outcomeOrder(OUTCOME1,OUTCOME2),
    same(OUTCOME1,OUTCOME2). 
% don't have more than the max conditions per outcome
:- max_conditions_per+1 {precondition(CONDITION,OUTCOME)}, outcome(OUTCOME).

% doesn't make sense to care about something overlapping and not overlapping at same time
:- 2 {precondition(overlaps(E1,E2,POLARITY),OUTCOME) :
    entity(E1),entity(E2),polarity(POLARITY)}, 
        outcome(OUTCOME).

% don't compare 1 resource for more than 1 value        
:-  2 {precondition(le(RESOURCE,VALUE),OUTCOME) :
            potentialValues(VALUE)}, 
        outcome(OUTCOME), 
        resource(RESOURCE).

% don't compare 1 resource for more than 1 value   
:-  2 {precondition(lt(RESOURCE,VALUE),OUTCOME) :
            potentialValues(VALUE)}, 
        outcome(OUTCOME), 
        resource(RESOURCE).
        
% don't compare 1 resource for more than 1 value   
:-  2 {precondition(ge(RESOURCE,VALUE),OUTCOME) :
            potentialValues(VALUE)}, 
        outcome(OUTCOME), 
        resource(RESOURCE).
        
% don't compare 1 resource for more than 1 value   
:-  2 {precondition(gt(RESOURCE,VALUE),OUTCOME) :
            potentialValues(VALUE)}, 
        outcome(OUTCOME), 
        resource(RESOURCE).
    
% don't compare 1 resource for more than 1 value   
:-  precondition(le(RESOURCE,VALUE),OUTCOME), 
    precondition(lt(RESOURCE,VALUE2),OUTCOME).
    
% don't compare 1 resource for more than 1 value   
:-  precondition(ge(RESOURCE,VALUE),OUTCOME), 
    precondition(gt(RESOURCE,VALUE2),OUTCOME).

% sanity check on outcome - only allow it have it has a result and precondition
result_outcome(OUTCOME) :-     result(OUTCOME,EFFECT).
precondition_outcome(OUTCOME) :-     precondition(CONDITION,OUTCOME).
validOutcome(OUTCOME) :- result_outcome(OUTCOME), 
    precondition_outcome(OUTCOME).
:- outcome(OUTCOME), not validOutcome(OUTCOME).

%generic above below to do interval reasoning 
below(RESOURCE,VALUE,OUTCOME) :- 
    precondition(le(RESOURCE,VALUE),OUTCOME).

below(RESOURCE,VALUE,OUTCOME) :-     
    precondition(lt(RESOURCE,VALUE),OUTCOME).
    
above(RESOURCE,VALUE,OUTCOME) :- 
    precondition(ge(RESOURCE,VALUE),OUTCOME).
above(RESOURCE,VALUE,OUTCOME) :- 
    precondition(gt(RESOURCE,VALUE),OUTCOME).

%helpers
conditionedOnResource(RESOURCE,OUTCOME) :- above(RESOURCE,VALUE,OUTCOME).
conditionedOnResource(RESOURCE,OUTCOME) :- below(RESOURCE,VALUE,OUTCOME).
  

%it should not be the case that you care about a value being above a high value and below a low value
:-  below(RESOURCE,VALUE_L,OUTCOME), 
    above(RESOURCE,VALUE_H,OUTCOME), 
    lower_than(VALUE_L,VALUE_H).

% buttons should be done in order - i.e. prioritize mouse and space (e.g. don't do left_arrow before space)
:- controlLogic(BUTTON), not controlLogic(BUTTON_H), buttonOrder(BUTTON_H,BUTTON).

:- entity(B), not entity(A), entityOrdering(A,B).
% cleanliness - choose e1 before e2
:- condition(overlaps(A,B,POLARITY)), entityOrdering(B,A).

% cleanliness - choose r1 before r2
:- conditionedOnResource(RESOURCE,OUTCOME1), not changes(RESOURCE,OUTCOME2), OUTCOME1 != OUTCOME2, outcome(OUTCOME2).


effect(EFFECT) :- result(OUTCOME,EFFECT).

%an outcome shouldn't result in game win and game loss simultaneously
:-  result(OUTCOME,mode_change(END)), 
    end_mode(END),
    2 {result(OUTCOME,EFFECT) : effect(EFFECT)}.
    
%don't tie losing or winning to a button press (press space to lose feels odd)
:-  precondition(control_event(BUTTON,STATE),OUTCOME),
    result(OUTCOME,mode_change(END)), 
    end_mode(END).
    
% certain things tick shouldn't do
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
    
    
:-  2 {physicsLogic(ENTITY,mapping(control_event(BUTTON,STATE),DIRECTION,AMOUNT)) :
    entity(ENTITY),
    buttons(BUTTON),
    buttonStates(STATE),
    direction(DIRECTION),
    constants(AMOUNT)},
    entity(ENTITY),
    direction(DIRECTION).  
:-  2 {physicsLogic(ENTITY,mapping(control_event(BUTTON,STATE),DIRECTION,AMOUNT)) :
    entity(ENTITY),
    buttons(BUTTON),
    buttonStates(STATE),
    direction(DIRECTION),
    constants(AMOUNT)},
    entity(ENTITY),
    buttons(BUTTON).  
:-  2 {physicsLogic(ENTITY,mapping(control_event(BUTTON,STATE),DIRECTION,AMOUNT)) :
    entity(ENTITY),
    buttons(BUTTON),
    buttonStates(STATE),
    direction(DIRECTION),
    constants(AMOUNT)},
    entity(ENTITY),
    buttonStates(STATE).     

:-  physicsLogic(ENTITY,mapping(control_event(left_arrow,STATE),DIRECTION,AMOUNT)),   
    vertical(DIRECTION).
    
:-  physicsLogic(ENTITY,mapping(control_event(right_arrow,STATE),DIRECTION,AMOUNT)),   
    vertical(DIRECTION).
 
    
:-   physicsLogic(ENTITY,mapping(control_event(BUTTON,STATE),DIR,AMOUNT)),
    physicsLogic(ENTITY,mapping(control_event(O_BUTTON,O_STATE),O_DIR,O_AMOUNT)),
    cardinal(DIR), 
    local(O_DIR).
    
    
:- 2{ physicsLogic(ENTITY,LOGIC) : physicsMetaphors(LOGIC)}, entity(ENTITY).

:- singular(ENTITY), many(ENTITY).
:- entity(ENTITY), not singular(ENTITY), not many(ENTITY).


