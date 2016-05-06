%%% Rules I want to encode
 % repeatable
 % limited/unlimited
 %



good(RESOURCE) :-     
    precondition(
        lt(RESOURCE,THRESHOLD), OUTCOME),
    result(OUTCOME,mode_change(game_loss)).
    
good(RESOURCE) :-     
    precondition(
        le(RESOURCE,THRESHOLD), OUTCOME),
    result(OUTCOME,mode_change(game_loss)).
    
bad(RESOURCE) :- 
    precondition(
        gt(RESOURCE,THRESHOLD), OUTCOME),
    result(OUTCOME,mode_change(game_loss)).
    
bad(RESOURCE) :- 
    precondition(
        ge(RESOURCE,THRESHOLD), OUTCOME),
    result(OUTCOME,mode_change(game_loss)).

bad(RESOURCE) :-     
    precondition(
        lt(RESOURCE,THRESHOLD), OUTCOME),
    result(OUTCOME,mode_change(game_win)).
    
good(RESOURCE) :- 
    precondition(
        gt(RESOURCE,THRESHOLD), OUTCOME),
    result(OUTCOME,mode_change(game_win)).
    

bad(RESOURCE) :-     
    precondition(
        lt(RESOURCE,THRESHOLD), OUTCOME),
    result(OUTCOME,mode_change(game_end)).
    
good(RESOURCE) :- 
    precondition(
        gt(RESOURCE,THRESHOLD), OUTCOME),
    result(OUTCOME,mode_change(game_end)).
    
    
    
bad(RESOURCE) :-     
    precondition(
        le(RESOURCE,THRESHOLD), OUTCOME),
    result(OUTCOME,mode_change(game_win)).
    
good(RESOURCE) :- 
    precondition(
        ge(RESOURCE,THRESHOLD), OUTCOME),
    result(OUTCOME,mode_change(game_win)).
    

bad(RESOURCE) :-     
    precondition(
        le(RESOURCE,THRESHOLD), OUTCOME),
    result(OUTCOME,mode_change(game_end)).
    
good(RESOURCE) :- 
    precondition(
        ge(RESOURCE,THRESHOLD), OUTCOME),
    result(OUTCOME,mode_change(game_end)).
    

condition(CONDITION) :- precondition(CONDITION,OUTCOME).

moreThanOnePrecondition(OUTCOME) :- 
    2 {precondition(CONDITION,OUTCOME) : condition(CONDITION)} , 
    outcome(OUTCOME).
onlyOnePrecondition(OUTCOME) :- 
    1 {precondition(CONDITION,OUTCOME) : condition(CONDITION)} 1 , 
    outcome(OUTCOME).

worseWithTime(RESOURCE) :- 
    good(RESOURCE),
    precondition(tick,OUTCOME), 
    onlyOnePrecondition(OUTCOME),
    result(OUTCOME,decreases(RESOURCE,AMOUNT)).
worseWithTime(RESOURCE) :- 
    bad(RESOURCE),
    precondition(tick,OUTCOME), 
    onlyOnePrecondition(OUTCOME),
    result(OUTCOME,increases(RESOURCE,AMOUNT)).

betterWithTime(RESOURCE) :- 
    bad(RESOURCE),
    precondition(tick,OUTCOME), 
    onlyOnePrecondition(OUTCOME),
    result(OUTCOME,decreases(RESOURCE,AMOUNT)).
betterWithTime(RESOURCE) :- 
    good(RESOURCE),
    precondition(tick,OUTCOME), 
    onlyOnePrecondition(OUTCOME),
    result(OUTCOME,increases(RESOURCE,AMOUNT)).
    
 

thing(OUTCOME,ENTITY,POLARITY) :- 
    result(OUTCOME,select(ENTITY,POLARITY)).


playerActionHelps(BUTTON,BUTTON_STATE,RESOURCE) :-
    good(RESOURCE),
    precondition(control_event(BUTTON,BUTTON_STATE),OUTCOME),
    result(OUTCOME,increases(RESOURCE,AMOUNT)).

playerActionHelps(BUTTON,BUTTON_STATE,RESOURCE) :-
    bad(RESOURCE),
    precondition(control_event(BUTTON,BUTTON_STATE),OUTCOME),
    result(OUTCOME,decreases(RESOURCE,AMOUNT)).
    
playerActionHurts(BUTTON,BUTTON_STATE,RESOURCE) :-
    bad(RESOURCE),
    precondition(control_event(BUTTON,BUTTON_STATE),OUTCOME),
    result(OUTCOME,increases(RESOURCE,AMOUNT)).

playerActionHurts(BUTTON,BUTTON_STATE,RESOURCE) :-
    good(RESOURCE),
    precondition(control_event(BUTTON,BUTTON_STATE),OUTCOME),
    result(OUTCOME,decreases(RESOURCE,AMOUNT)).

    
playerActionAffects(BUTTON,BUTTON_STATE,RESOURCE) :-
    playerActionHurts(BUTTON,BUTTON_STATE,RESOURCE).
    
playerActionAffects(BUTTON,BUTTON_STATE,RESOURCE) :-
    playerActionHelps(BUTTON,BUTTON_STATE,RESOURCE).
    
    
actionHasRiskReward(BUTTON,BUTTON_STATE) :- 
    playerActionHelps(BUTTON,BUTTON_STATE,RESOURCE1),
    playerActionHurts(BUTTON,BUTTON_STATE,RESOURCE2).
    
actionNeededForMaintenance(BUTTON,BUTTON_STATE,RESOURCE) :-
    playerActionHelps(BUTTON,BUTTON_STATE,RESOURCE),
    worseWithTime(RESOURCE).
    
timingBasedPhysics(spring;pendulum;chase;random;random_chase;flee;random_flee).

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

    
consumedBy(RESOURCE,OUTCOME) :-
    precondition(gt(RESOURCE,THRESHOLD),OUTCOME),
    result(OUTCOME,decreases(RESOURCE,AMOUNT)).
    
consumedBy(RESOURCE,OUTCOME) :-
    precondition(ge(RESOURCE,THRESHOLD),OUTCOME),
    result(OUTCOME,decreases(RESOURCE,AMOUNT)).

timingAffectsAction(BUTTON,BUTTON_STATE) :- 
    precondition(control_event(BUTTON,BUTTON_STATE),OUTCOME),
    precondition(overlaps(ENTITY_A,ENTITY_B,POLARITY),OUTCOME),
    timingAffectsEntity(ENTITY_A).

timingAffectsAction(BUTTON,BUTTON_STATE) :- 
    precondition(control_event(BUTTON,BUTTON_STATE),OUTCOME),
    precondition(overlaps(ENTITY_A,ENTITY_B,POLARITY),OUTCOME),
    timingAffectsEntity(ENTITY_B).
  
timingChallenge(BUTTON,BUTTON_STATE) :- 
    actionHasRiskReward(BUTTON,BUTTON_STATE),
    timingAffectsAction(BUTTON,BUTTON_STATE).


    
goal(achieve(OUTCOME)) :-
    result(OUTCOME, mode_change(game_win)).
goal(achieve(OUTCOME)) :-
    result(OUTCOME, mode_change(game_end)).
    
goal(prevent(OUTCOME)) :-
    result(OUTCOME, mode_change(game_loss)).

result(OUTCOME,decreases(RESOURCE,1)) :-
    result(OUTCOME,delete(ENTITY)),
    resourceLogic(RESOURCE,count(ENTITY)).
    
result(OUTCOME,increases(RESOURCE,1)) :-
    result(OUTCOME,add(ENTITY)),
    resourceLogic(RESOURCE,count(ENTITY)).
    
    
requiredBy(OUTCOME,ENTITY) :-
    precondition(overlaps(ENTITY,ENTITY_B,POLARITY),OUTCOME).
    
requiredBy(OUTCOME,ENTITY) :-
    precondition(overlaps(ENTITY_B,ENTITY,POLARITY),OUTCOME).
    
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
    precondition(lt(RESOURCE,THRESHOLD),OUTCOME2),
    OUTCOME != OUTCOME2 .
    
enables(OUTCOME,OUTCOME2) :- 
    result(OUTCOME,increases(RESOURCE,AMOUNT)), 
    precondition(gt(RESOURCE,THRESHOLD),OUTCOME2),
    OUTCOME != OUTCOME2 .
    
hinders(OUTCOME,OUTCOME2) :- 
    result(OUTCOME,increases(RESOURCE,AMOUNT)), 
    precondition(lt(RESOURCE,THRESHOLD),OUTCOME2),
    OUTCOME != OUTCOME2 .
    
hinders(OUTCOME,OUTCOME2) :- 
    result(OUTCOME,decreases(RESOURCE,AMOUNT)), 
    precondition(gt(RESOURCE,THRESHOLD),OUTCOME2),
    OUTCOME != OUTCOME2 .
    
       
enables(OUTCOME,OUTCOME2) :- 
    result(OUTCOME,decreases(RESOURCE,AMOUNT)), 
    precondition(le(RESOURCE,THRESHOLD),OUTCOME2),
    OUTCOME != OUTCOME2 .
    
enables(OUTCOME,OUTCOME2) :- 
    result(OUTCOME,increases(RESOURCE,AMOUNT)), 
    precondition(ge(RESOURCE,THRESHOLD),OUTCOME2),
    OUTCOME != OUTCOME2 .
    
hinders(OUTCOME,OUTCOME2) :- 
    result(OUTCOME,increases(RESOURCE,AMOUNT)), 
    precondition(le(RESOURCE,THRESHOLD),OUTCOME2),
    OUTCOME != OUTCOME2 .
    
hinders(OUTCOME,OUTCOME2) :- 
    result(OUTCOME,decreases(RESOURCE,AMOUNT)), 
    precondition(ge(RESOURCE,THRESHOLD),OUTCOME2),
    OUTCOME != OUTCOME2 .
    
enables(OUTCOME,OUTCOME3) :-
    enables(OUTCOME,OUTCOME2),
    enables(OUTCOME2,OUTCOME3).
 
selection(OUTCOME) :-
    result(OUTCOME,select(ENTITY,CONDITION)).

allocation(RESOURCE) :- 
    consumedBy(RESOURCE,OUTCOME),
    selection(OUTCOME).
    
    
subGoal(prevent(OUTCOME_PRIME),1) :-
    enables(OUTCOME_PRIME,OUTCOME),
    goal(prevent(OUTCOME)),
    not subGoal(achieve(OUTCOME_PRIME),1),
    humanAffected(OUTCOME_PRIME). 
    
subGoal(achieve(OUTCOME_PRIME),1) :-
    hinders(OUTCOME_PRIME,OUTCOME),
    goal(prevent(OUTCOME)),
    humanAffected(OUTCOME_PRIME).
    

subGoal(achieve(OUTCOME_PRIME),1) :-
    enables(OUTCOME_PRIME,OUTCOME),
    goal(achieve(OUTCOME)),
    humanAffected(OUTCOME_PRIME).

subGoal(prevent(OUTCOME_PRIME),I+1) :-
    enables(OUTCOME_PRIME,OUTCOME),
    subGoal(prevent(OUTCOME),I),
    humanAffected(OUTCOME_PRIME),
    I < 1. 
    
subGoal(achieve(OUTCOME_PRIME),I+1) :-
    hinders(OUTCOME_PRIME,OUTCOME),
    goal(prevent(OUTCOME),I),
    humanAffected(OUTCOME_PRIME),
    I < 1.
    

goal(relates(OUTCOME)) :- 
    goal(achieve(OUTCOME)).
    
goal(relates(OUTCOME)) :-
    goal(prevent(OUTCOME)).

goal(achieve(OUTCOME)) :- 
    subGoal(achieve(OUTCOME),DEPTH).
    
goal(prevent(OUTCOME)) :-
    subGoal(prevent(OUTCOME),DEPTH).
    
timingChallengeGoal :- 
    goal(achieve(OUTCOME)),
    precondition(control_event(BUTTON,BUTTON_STATE),OUTCOME),
    timingChallenge(BUTTON,BUTTON_STATE).
    

timingChallengeGoal :- 
    goal(achieve(OUTCOME)),
    precondition(control_event(BUTTON,BUTTON_STATE),OUTCOME),
    timingChallenge(BUTTON,BUTTON_STATE).
    
goal(maintain(RESOURCE)) :-
    precondition(lt(RESOURCE,THRESHOLD),OUTCOME),
    goal(prevent(OUTCOME)).
 
goal(eliminate(RESOURCE)) :-
    precondition(lt(RESOURCE,THRESHOLD),OUTCOME),
    goal(achieve(OUTCOME)).
   
easy(OUTCOME) :-
    unrestricted(OUTCOME).

easy(OUTCOME) :-
    precondition(overlaps(ENTITY_A,ENTITY_B,false),OUTCOME),
    not agent(ENTITY_A),
    not agent(ENTITY_B).
    
goal(maintain(RESOURCE)) :-
    precondition(le(RESOURCE,THRESHOLD),OUTCOME),
    goal(prevent(OUTCOME)).
 
goal(eliminate(RESOURCE)) :-
    precondition(le(RESOURCE,THRESHOLD),OUTCOME),
    goal(achieve(OUTCOME)).
   
isEasy :-
    goal(achieve(OUTCOME)),
    easy(OUTCOME).
    
nonMonotonic(RESOURCE) :-
    result(OUTCOME1,decreases(RESOURCE,AMOUNT1)),
    result(OUTCOME2, increases(RESOURCE,AMOUNT2)).

nonMonotonic(Resource) :-
    result(Outcome, set_to(Resource, Value)).
    
monotonicallyDecreases(RESOURCE) :- 
    result(OUTCOME1,decreases(RESOURCE,AMOUNT)),
    not nonMonotonic(RESOURCE).
 
monotonicallyIncreases(RESOURCE) :- 
    result(OUTCOME1,increases(RESOURCE,AMOUNT)),
    not nonMonotonic(RESOURCE).


    
    

humanAffected(OUTCOME) :-
    precondition(control_event(BUTTON,STATE),OUTCOME).
    
    
humanControlled(ENTITY) :-        
     physicsLogic(ENTITY,mapping(control_event(BUTTON,STATE),DIR,AMOUNT)).
    
humanControlled(ENTITY) :-        
    physicsLogic(ENTITY, follows(cursor)).

humanAffected(OUTCOME) :-
    requiredBy(OUTCOME,ENTITY),
    humanControlled(ENTITY).
    
humanAffected(OUTCOME2) :-
    enables(OUTCOME1,OUTCOME2),
    humanAffected(OUTCOME1).

restrictedEntity(ENTITY) :- 
    entity(ENTITY),
    not humanControlled(ENTITY).
    
restrictedEntity(ENTITY) :-
    result(OUTCOME,applyRestitution(ENTITY)).
    
restrictedEntity(ENTITY) :-
    precondition(overlaps(ENTITY,OTHER,POLARITY),OUTCOME),
    result(OUTCOME,delete(ENTITY)).
    
    
restrictedEntity(ENTITY) :-
    precondition(overlaps(OTHER,ENTITY,POLARITY),OUTCOME),
    result(OUTCOME,delete(ENTITY)).

unrestrictedEntity(ENTITY) :-
    entity(ENTITY), 
    not restrictedEntity(ENTITY).
    
    
restrictedCondition(overlaps(ENTITY_A,ENTITY_B,POLARITY)) :-
    precondition(overlaps(ENTITY_A,ENTITY_B,POLARITY),OUTCOME),
    restrictedEntity(ENTITY_A).

restrictedCondition(overlaps(ENTITY_A,ENTITY_B,POLARITY)) :-
    precondition(overlaps(ENTITY_A,ENTITY_B,POLARITY),OUTCOME),
    restrictedEntity(ENTITY_B).
unrestrictedCondition(overlaps(ENTITY_A,ENTITY_B,POLARITY)) :-
    precondition(overlaps(ENTITY_A,ENTITY_B,POLARITY),OUTCOME),
    not restrictedCondition(overlaps(ENTITY_A,ENTITY_B,POLARITY)).
    
restricted(OUTCOME) :-
    precondition(CONDITION, OUTCOME),
    not unrestrictedCondition(CONDITION).
  
    
unrestricted(OUTCOME) :-
    outcome(OUTCOME),
    not restricted(OUTCOME).

unrestrictedCondition(lt(RESOURCE,THRESHOLD)) :-
    monotonicallyDecreases(RESOURCE),
    precondition(lt(RESOURCE,THRESHOLD),SOME_OUTCOME),
    result(OUTCOME,decreases(RESOURCE,AMOUNT)),
    unrestricted(OUTCOME).
  

    
unrestrictedCondition(gt(RESOURCE,THRESHOLD)) :-
    monotonicallyIncreases(RESOURCE),
    precondition(gt(RESOURCE,THRESHOLD),SOME_OUTCOME),
    result(OUTCOME,increases(RESOURCE,AMOUNT)),
    unrestricted(OUTCOME).

    
unrestrictedCondition(le(RESOURCE,THRESHOLD)) :-
    monotonicallyDecreases(RESOURCE),
    precondition(le(RESOURCE,THRESHOLD),SOME_OUTCOME),
    result(OUTCOME,decreases(RESOURCE,AMOUNT)),
    unrestricted(OUTCOME).
  

    
unrestrictedCondition(ge(RESOURCE,THRESHOLD)) :-
    monotonicallyIncreases(RESOURCE),
    precondition(ge(RESOURCE,THRESHOLD),SOME_OUTCOME),
    result(OUTCOME,increases(RESOURCE,AMOUNT)),
    unrestricted(OUTCOME).

    
gradual(OUTCOME) :-
    precondition(tick,OUTCOME).
gradual(OUTCOME_PRIME) :-
    gradual(OUTCOME),
    enables(OUTCOME,OUTCOME_PRIME).

amount(AMOUNT) :-
    result(OUTCOME,increases(RESOURCE,AMOUNT)).
amount(AMOUNT) :- 
    result(OUTCOME,decreases(RESOURCE,AMOUNT)).
   
medium_stakes :-
    enables(GOOD_STEP,GOAL_OUTCOME),
    goal(achieve(GOAL_OUTCOME)),
    hinders(BAD_STEP,GOOD_STEP),
    gradual(GOOD_STEP).
    
thoughtful :-
    medium_stakes,
    allocation(RESOURCE),
    limited(RESOURCE).
 

    
replenishible(RESOURCE) :-
    2 {result(OUTCOME1,increases(RESOURCE,AMOUNT1));
    result(OUTCOME2,decreases(RESOURCE,AMOUNT2));
    result(OUTCOME3,set_to(RESOURCE,AMOUNT3))}, resource(RESOURCE).

    

limited(RESOURCE) :-
    not replenishible(RESOURCE),
    result(OUTCOME,decreases(RESOURCE,AMOUNT)).
      
    
playerAgency(ENTITY) :- 
    physicsLogic(ENTITY,follows(cursor)).

playerAgency(ENTITY) :-    
    physicsLogic(ENTITY,mapping(control_event(BUTTON,STATE),DIRECTION,AMOUNT)).
% %% KNOWLEGE BASE

unrestrictedCondition(control_event(BUTTON,BUTTON_STATE)) :- buttons(BUTTON), buttonStates(BUTTON_STATE).
unrestrictedCondition(tick).
unrestrictedGame :- 
    unrestricted(OUTCOME),
    result(OUTCOME,mode_change(story_progression)).
unrestrictedGame :- 
    unrestricted(OUTCOME),
    result(OUTCOME,mode_change(game_win)).
    

    
