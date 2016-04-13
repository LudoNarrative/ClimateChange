
good(RESOURCE) :-     
    precondition(
        below(RESOURCE,THRESHOLD), OUTCOME),
    result(OUTCOME,game_loss).
    
bad(RESOURCE) :- 
    precondition(
        above(RESOURCE,THRESHOLD), OUTCOME),
    result(OUTCOME,game_loss).

bad(RESOURCE) :-     
    precondition(
        below(RESOURCE,THRESHOLD), OUTCOME),
    result(OUTCOME,game_win).
    
good(RESOURCE) :- 
    precondition(
        above(RESOURCE,THRESHOLD), OUTCOME),
    result(OUTCOME,game_win).
    

bad(RESOURCE) :-     
    precondition(
        below(RESOURCE,THRESHOLD), OUTCOME),
    result(OUTCOME,story_progression).
    
good(RESOURCE) :- 
    precondition(
        above(RESOURCE,THRESHOLD), OUTCOME),
    result(OUTCOME,story_progression).
    
    
outcome(OUTCOME) :- precondition(CONDITION,OUTCOME).
condition(CONDITION) :- precondition(CONDITION,OUTCOME).

moreThanOnePrecondition(OUTCOME) :- 
    2 {precondition(CONDITION,OUTCOME) : condition(CONDITION)} , 
    outcome(OUTCOME).
onlyOnePrecondition(OUTCOME) :- 
    1 {precondition(CONDITION,OUTCOME) : condition(CONDITION)} 1 , 
    outcome(OUTCOME).

worseWithTime(RESOURCE) :- 
    good(RESOURCE),
    precondition(time,OUTCOME), 
    onlyOnePrecondition(OUTCOME),
    result(OUTCOME,decreases(RESOURCE,AMOUNT)).
worseWithTime(RESOURCE) :- 
    bad(RESOURCE),
    precondition(time,OUTCOME), 
    onlyOnePrecondition(OUTCOME),
    result(OUTCOME,increases(RESOURCE,AMOUNT)).

betterWithTime(RESOURCE) :- 
    bad(RESOURCE),
    precondition(time,OUTCOME), 
    onlyOnePrecondition(OUTCOME),
    result(OUTCOME,decreases(RESOURCE,AMOUNT)).
betterWithTime(RESOURCE) :- 
    good(RESOURCE),
    precondition(time,OUTCOME), 
    onlyOnePrecondition(OUTCOME),
    result(OUTCOME,increases(RESOURCE,AMOUNT)).
    
 



playerActionHelps(PLAYER_ACTION,RESOURCE) :-
    good(RESOURCE),
    precondition(control_event(PLAYER_ACTION),OUTCOME),
    result(OUTCOME,increases(RESOURCE,AMOUNT)).

playerActionHelps(PLAYER_ACTION,RESOURCE) :-
    bad(RESOURCE),
    precondition(control_event(PLAYER_ACTION),OUTCOME),
    result(OUTCOME,decreases(RESOURCE,AMOUNT)).
    
playerActionHurts(PLAYER_ACTION,RESOURCE) :-
    bad(RESOURCE),
    precondition(control_event(PLAYER_ACTION),OUTCOME),
    result(OUTCOME,increases(RESOURCE,AMOUNT)).

playerActionHurts(PLAYER_ACTION,RESOURCE) :-
    good(RESOURCE),
    precondition(control_event(PLAYER_ACTION),OUTCOME),
    result(OUTCOME,decreases(RESOURCE,AMOUNT)).

    
playerActionAffects(PLAYER_ACTION,RESOURCE) :-
    playerActionHurts(PLAYER_ACTION,RESOURCE).
    
playerActionAffects(PLAYER_ACTION,RESOURCE) :-
    playerActionHelps(PLAYER_ACTION,RESOURCE).
    
    
actionHasRiskReward(PLAYER_ACTION) :- 
    playerActionHelps(PLAYER_ACTION,RESOURCE1),
    playerActionHurts(PLAYER_ACTION,RESOURCE2).
    
actionNeededForMaintenance(PLAYER_ACTION,RESOURCE) :-
    playerActionHelps(PLAYER_ACTION,RESOURCE),
    worseWithTime(RESOURCE).
    
timingBasedPhysics(spring).
timingBasedPhysics(pendulum).

correlated(RESOURCE1,RESOURCE2,positive) :-
    result(OUTCOME,increases(RESOURCE1, AMOUNT1)),
    result(OUTCOME,increases(RESOURCE2, AMOUNT2)),
    RESOURCE1 != RESOURCE2.
    
correlated(RESOURCE1,RESOURCE2,positive) :-
    result(OUTCOME,decreases(RESOURCE1, AMOUNT1)),
    result(OUTCOME,decreases(RESOURCE2, AMOUNT2)),
    RESOURCE1 != RESOURCE2.
    
correlated(RESOURCE1,RESOURCE2,negative) :-
    result(OUTCOME,decreases(RESOURCE1, AMOUNT1)),
    result(OUTCOME,increases(RESOURCE2, AMOUNT2)).
        
timingAffectsEntity(ENTITY) :- 
    physicsLogic(ENTITY,PHYSICS_TYPE),
    timingBasedPhysics(PHYSICS_TYPE).


timingAffectsAction(PLAYER_ACTION) :- 
    precondition(control_event(PLAYER_ACTION),OUTCOME),
    precondition(collides(ENTITY_A,ENTITY_B,POLARITY),OUTCOME),
    timingAffectsEntity(ENTITY_A).

timingAffectsAction(PLAYER_ACTION) :- 
    precondition(control_event(PLAYER_ACTION),OUTCOME),
    precondition(collides(ENTITY_A,ENTITY_B,POLARITY),OUTCOME),
    timingAffectsEntity(ENTITY_B).
  
timingChallenge(PLAYER_ACTION) :- 
    actionHasRiskReward(PLAYER_ACTION),
    timingAffectsAction(PLAYER_ACTION).

goal(achieve(OUTCOME)) :-
    result(OUTCOME, game_win).
goal(achieve(OUTCOME)) :-
    result(OUTCOME, story_progression).
    
goal(prevent(OUTCOME)) :-
    result(OUTCOME, game_loss).

result(OUTCOME,decreases(RESOURCE,1)) :-
    result(OUTCOME,delete(ENTITY)),
    resourceLogic(RESOURCE,count(ENTITY)).
    
result(OUTCOME,increases(RESOURCE,1)) :-
    result(OUTCOME,add(ENTITY)),
    resourceLogic(RESOURCE,count(ENTITY)).
    
    
requiredBy(OUTCOME,ENTITY) :-
    precondition(collides(ENTITY,ENTITY_B,POLARITY),OUTCOME).
    
requiredBy(OUTCOME,ENTITY) :-
    precondition(collides(ENTITY_B,ENTITY,POLARITY),OUTCOME).
    
enables(OUTCOME,OUTCOME2) :-
    result(OUTCOME,add(ENTITY)), 
    requiredBy(OUTCOME2,ENTITY),
    OUTCOME != OUTCOME2 .
 
hinders(OUTCOME,OUTCOME2) :-
    result(OUTCOME,delete(ENTITY)), 
    requiredBy(OUTCOME2,ENTITY),
    OUTCOME != OUTCOME2 .   
    
enables(OUTCOME,OUTCOME2) :- 
    result(OUTCOME,decreases(RESOURCE,AMOUNT)), 
    precondition(below(RESOURCE,THRESHOLD),OUTCOME2),
    OUTCOME != OUTCOME2 .
    
enables(OUTCOME,OUTCOME2) :- 
    result(OUTCOME,increases(RESOURCE,AMOUNT)), 
    precondition(above(RESOURCE,THRESHOLD),OUTCOME2),
    OUTCOME != OUTCOME2 .
    
hinders(OUTCOME,OUTCOME2) :- 
    result(OUTCOME,increases(RESOURCE,AMOUNT)), 
    precondition(below(RESOURCE,THRESHOLD),OUTCOME2),
    OUTCOME != OUTCOME2 .
    
hinders(OUTCOME,OUTCOME2) :- 
    result(OUTCOME,decreases(RESOURCE,AMOUNT)), 
    precondition(above(RESOURCE,THRESHOLD),OUTCOME2),
    OUTCOME != OUTCOME2 .
    
enables(OUTCOME,OUTCOME3) :-
    enables(OUTCOME,OUTCOME2),
    enables(OUTCOME2,OUTCOME3).
    
hinders(OUTCOME,OUTCOME3) :-
    enables(OUTCOME,OUTCOME2),
    hinders(OUTCOME2,OUTCOME3),
    OUTCOME != OUTCOME3.
    
hinders(OUTCOME,OUTCOME3) :-
    hinders(OUTCOME,OUTCOME2),
    enables(OUTCOME2,OUTCOME3),
    OUTCOME != OUTCOME3.
    
enables(OUTCOME,OUTCOME3) :-
    hinders(OUTCOME,OUTCOME2),
    hinders(OUTCOME2,OUTCOME3),
    OUTCOME != OUTCOME3.


subGoal(prevent(OUTCOME_PRIME),1) :-
    enables(OUTCOME_PRIME,OUTCOME),
    goal(prevent(OUTCOME)). 
    
subGoal(achieve(OUTCOME_PRIME),1) :-
    hinders(OUTCOME_PRIME,OUTCOME),
    goal(prevent(OUTCOME)).
    


subGoal(prevent(OUTCOME_PRIME),I+1) :-
    enables(OUTCOME_PRIME,OUTCOME),
    subGoal(prevent(OUTCOME),I). 
    
subGoal(achieve(OUTCOME_PRIME),I+1) :-
    hinders(OUTCOME_PRIME,OUTCOME),
    goal(prevent(OUTCOME),I).
    

goal(relates(OUTCOME)) :- 
    goal(achieve(OUTCOME)).
    
goal(relates(OUTCOME)) :-
    goal(prevent(OUTCOME)).

goal(relates(OUTCOME)) :- 
    subGoal(achieve(OUTCOME),DEPTH).
    
goal(relates(OUTCOME)) :-
    subGoal(prevent(OUTCOME),DEPTH).
    
timingChallengeGoal :- 
    goal(relates(OUTCOME)),
    precondition(control_event(PLAYER_ACTION),OUTCOME),
    timingChallenge(PLAYER_ACTION).
    
    
goal(maintain(RESOURCE)) :-
    precondition(below(RESOURCE,THRESHOLD),OUTCOME),
    goal(prevent(OUTCOME)).
 
goal(eliminate(RESOURCE)) :-
    precondition(below(RESOURCE,THRESHOLD),OUTCOME),
    goal(achieve(OUTCOME)).
   

isEasy :-
    goal(achieve(OUTCOME)),
    easy(OUTCOME).
    
nonMonotonic(RESOURCE) :-
    result(OUTCOME1,decreases(RESOURCE,AMOUNT)),
    result(OUTCOME2, increases(RESOURCE,AMOUNT)).
    
monotonicallyDecreases(RESOURCE) :- 
    result(OUTCOME1,decreases(RESOURCE,AMOUNT)),
    not nonMonotonic(RESOURCE).
 
monotonicallyIncreases(RESOURCE) :- 
    result(OUTCOME1,increases(RESOURCE,AMOUNT)),
    not nonMonotonic(RESOURCE).
    
      
entity(ENTITY) :- 
    graphicalLogic(ENTITY,STATE).
   
unrestrictedEntity(ENTITY) :-
    not result(OUTCOME,applyRestitution(ENTITY)),
    outcome(OUTCOME),
    physicsLogic(ENTITY,controlLogic(PHYSICS_CONTROL)).
    
restrictedCondition(collides(ENTITY_A,ENTITY_B,POLARITY)) :-
    precondition(collides(ENTITY_A,ENTITY_B,POLARITY),OUTCOME),
    not unrestrictedEntity(ENTITY_A),
    not unrestrictedEntity(ENTITY_B).

unrestrictedCondition(collides(ENTITY_A,ENTITY_B,POLARITY)) :-
    precondition(collides(ENTITY_A,ENTITY_B,POLARITY),OUTCOME),
    not restrictedCondition(collides(ENTITY_A,ENTITY_B,POLARITY)).
    
restricted(OUTCOME) :-
    precondition(CONDITION, OUTCOME),
    not unrestrictedCondition(CONDITION).
  
    
unrestricted(OUTCOME) :-
    outcome(OUTCOME),
    not restricted(OUTCOME).

unrestrictedCondition(below(RESOURCE,THRESHOLD)) :-
    monotonicallyDecreases(RESOURCE),
    precondition(below(RESOURCE,THRESHOLD),SOME_OUTCOME),
    result(OUTCOME,decreases(RESOURCE,AMOUNT)),
    unrestricted(OUTCOME).
  

    
unrestrictedCondition(above(RESOURCE,THRESHOLD)) :-
    monotonicallyIncreases(RESOURCE),
    precondition(above(RESOURCE,THRESHOLD),SOME_OUTCOME),
    result(OUTCOME,increases(RESOURCE,AMOUNT)),
    unrestricted(OUTCOME).

gradual(OUTCOME) :-
    precondition(time,OUTCOME).
    
gradual(OUTCOME_PRIME) :-
    gradual(OUTCOME),
    enables(OUTCOME,OUTCOME_PRIME).
  
    
allocation(RESOURCE) :-
    precondition(above(RESOURCE,THRESHOLD),OUTCOME_STEP),
    result(OUTCOME_STEP,decreases(RESOURCE,AMOUNT)),
    enables(OUTCOME_STEP,OUTCOME),
    goal(achieve(OUTCOME)).
    
    
arbitrage(RESOURCE)  :-
    result(OUTCOME1,increases(RESOURCE,AMOUNT1)),
    result(OUTCOME2,decreases(RESOURCE,AMOUNT2)),
    AMOUNT1 > AMOUNT2,
    enables(OUTCOME2,OUTCOME1).
    
unlimited(RESOURCE) :-
    result(OUTCOME,increases(RESOURCE,AMOUNT)),
    unrestricted(OUTCOME).

limited(RESOURCE) :-
    result(OUTCOME,decreases(RESOURCE,AMOUNT)),
    not unlimited(RESOURCE),
    not arbitrage(RESOURCE),
    enables(OUTCOME,GOAL_OUTCOME),
    goal(achieve(GOAL_OUTCOME)).
    
    
limited(RESOURCE) :-
    result(OUTCOME,increases(RESOURCE,AMOUNT)),
    not unlimited(RESOURCE),
    not arbitrage(RESOURCE),
    hinders(OUTCOME,GOAL_OUTCOME),
    goal(prevent(GOAL_OUTCOME)).
    
medium_stakes :-
    enables(GOOD_STEP,GOAL_OUTCOME),
    goal(achieve(GOAL_OUTCOME)),
    hinders(BAD_STEP,GOOD_STEP),
    gradual(GOOD_STEP).
    
thoughtful :-
    medium_stakes,
    allocation(RESOURCE),
    limited(RESOURCE).
% %% KNOWLEGE BASE

unrestrictedCondition(control_event(click)). %player can always click
unrestrictedCondition(time).
unrestrictedGame :- 
    unrestricted(OUTCOME),
    result(OUTCOME,story_progression).
unrestrictedGame :- 
    unrestricted(OUTCOME),
    result(OUTCOME,game_win).