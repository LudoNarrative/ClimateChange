%%% Rules I want to encode
 % repeatable
 % limited/unlimited
 %

lowThreshold(lt(Resource, Thresh), Resource) :-
    resource(Resource),
    threshold(Thresh).

lowThreshold(le(Resource, Thresh), Resource) :-
    resource(Resource),
    threshold(Thresh).

highThreshold(gt(Resource, Thresh), Resource) :-
    resource(Resource),
    threshold(Thresh).

highThreshold(ge(Resource, Thresh), Resource) :-
    resource(Resource),
    threshold(Thresh).


%% Good and bad results

goodResult(mode_change(game_win)).
badResult(mode_change(game_end)). % ?
badResult(mode_change(game_loss)).

goodResult(increase(Resource, Amount)) :-
    result(_, increase(Resource, Amount)),
    good(Resource).

goodResult(decrease(Resource, Amount)) :-
    result(_, decrease(Resource, Amount)),
    bad(Resource).

badResult(increase(Resource, Amount)) :-
    result(_, increase(Resource, Amount)),
    bad(Resource).

badResult(decrease(Resource, Amount)) :-
    result(_, decrease(Resource, Amount)),
    good(Resource).

%% Good and bad outcomes

outcomeFavorable(Outcome) :-
    result(Outcome, Result),
    goodResult(Result).

outcomeUnfavorable(Outcome) :-
    result(Outcome, Result),
    badResult(Result).

hasTradeoff(Outcome) :-
    outcomeFavorable(Outcome),
    outcomeUnfavorable(Outcome).

%% Relating outcomes and resources

needsLow(Outcome, Resource) :- 
    precondition(Pre, Outcome),
    lowThreshold(Pre, Resource).

needsHigh(Outcome, Resource) :-
    precondition(Pre, Outcome),
    highThreshold(Pre, Resource).


%% Good and bad resources

good(Resource) :-
    needsHigh(Outcome, Resource),
    outcomeFavorable(Outcome).
    
bad(Resource) :- 
    needsHigh(Outcome, Resource),
    outcomeUnfavorable(Outcome).
    
good(Resource) :- 
    needsLow(Outcome, Resource),
    outcomeUnfavorable(Outcome).

bad(Resource) :-     
    needsLow(Outcome, Resource),
    outcomeFavorable(Outcome).
   

good(Resource) :-
    goal(maintain(Resource)).

bad(Resource) :-
    goal(eliminate(Resource)).

bad(Resource) :-
    goal(limit(Resource)).


    
resourceAffects(Resource, Outcome) :-
    needsHigh(Outcome, Resource).
resourceAffects(Resource, Outcome) :-
    needsLow(Outcome, Resource).


outcomeAffects(Resource, Outcome, positive) :-
    result(Outcome, increase(Resource, Amount)).

outcomeAffects(Resource, Outcome, negative) :-
    result(Outcome, decrease(Resource, Amount)).

amplifies(Amplifier, Resource) :-
    result(Outcome1, increase(Resource, Amplifier)),
    resource(Amplifier).

attenuates(Attenuator, Resource) :-
    result(Outcome1, decrease(Resource, Attenuator)),
    resource(Attenuator).

outcomeAffects(Resource, Outcome, positive) :-
    result(Outcome, increase(Amplifier, Amount)),
    amplifies(Amplifier, Resource).

outcomeAffects(Resource, Outcome, negative) :-
    result(Outcome, increase(Attenuator, Amount)),
    attenuates(Attenuator, Resource).

outcomeAffects(Resource, Outcome, positive) :-
    result(Outcome, increase(Resource, Amount)).
outcomeAffects(Resource, Outcome, negative) :-
    result(Outcome, decrease(Resource, Amount)).

outcomeFavorable(Outcome) :-
    outcomeAffects(Resource, Outcome, positive),
    good(Resource).

outcomeFavorable(Outcome) :-
    outcomeAffects(Resource, Outcome, negative),
    bad(Resource).

outcomeUnfavorable(Outcome) :-
    outcomeAffects(Outcome, Resource, positive),
    bad(Resource).
outcomeUnfavorable(Outcome) :-
    outcomeAffects(Outcome, Resource, negative),
    good(Resource).

condition(CONDITION) :- precondition(CONDITION,Outcome).
outcome(Outcome) :- precondition(_, Outcome).

moreThanOnePrecondition(Outcome) :- 
    2 {precondition(CONDITION,Outcome) : condition(CONDITION)} , 
    outcome(Outcome).
onlyOnePrecondition(Outcome) :- 
    1 {precondition(CONDITION,Outcome) : condition(CONDITION)} 1 , 
    outcome(Outcome).

worseWithTime(RESOURCE) :- 
    good(RESOURCE),
    precondition(tick,Outcome), 
    onlyOnePrecondition(Outcome),
    result(Outcome,decrease(RESOURCE,AMOUNT)).

worseWithTime(RESOURCE) :- 
    bad(RESOURCE),
    precondition(tick,Outcome), 
    onlyOnePrecondition(Outcome),
    result(Outcome,increase(RESOURCE,AMOUNT)).

betterWithTime(RESOURCE) :- 
    bad(RESOURCE),
    precondition(tick,Outcome), 
    onlyOnePrecondition(Outcome),
    result(Outcome,decrease(RESOURCE,AMOUNT)).

betterWithTime(RESOURCE) :- 
    good(RESOURCE),
    precondition(tick,Outcome), 
    onlyOnePrecondition(Outcome),
    result(Outcome,increase(RESOURCE,AMOUNT)).
    
 

thing(Outcome,ENTITY,POLARITY) :- 
    result(Outcome,select(ENTITY,POLARITY)).


% XXX rewrite these to involve more generality than buttons
playerActionHelps(ControlEvent, Resource) :-
    good(Resource),
    precondition(control_event(ControlEvent), Outcome),
    result(Outcome, increase(Resource, Amount)).

playerActionHelps(ControlEvent, Resource) :-
    bad(Resource),
    precondition(control_event(ControlEvent), Outcome),
    result(Outcome, decrease(Resource, Amount)).
    
playerActionHurts(ControlEvent, Resource) :-
    bad(Resource),
    precondition(control_event(ControlEvent), Outcome),
    result(Outcome, increase(Resource, Amount)).

playerActionHurts(ControlEvent, Resource) :-
    good(Resource),
    precondition(control_event(ControlEvent), Outcome),
    result(Outcome, decrease(Resource, Amount)).

    
playerActionAffects(ControlEvent, Resource) :-
    playerActionHurts(ControlEvent, Resource).
    
playerActionAffects(ControlEvent, Resource) :-
    playerActionHelps(ControlEvent, Resource).
    
playerInfluences(Outcome) :-
    playerActionAffects(_, _, Resource),
    resourceAffects(Resource, Outcome).

%% XXX TODO: clean up below.
    
actionHasRiskReward(ControlEvent) :- 
    playerActionHelps(ControlEvent, Resource1),
    playerActionHurts(ControlEvent, Resource2).
    
actionNeededForMaintenance(ControlEvent, Resource) :-
    playerActionHelps(ControlEvent, Resource),
    worseWithTime(Resource).
    
correlated(Resource1,Resource2,positive) :-
    result(Outcome,increase(Resource1, Amount1)),
    result(Outcome,increase(Resource2, Amount2)),
    Resource1 != Resource2.
    
correlated(Resource1,Resource2,positive) :-
    result(Outcome,decrease(Resource1, Amount1)),
    result(Outcome,decrease(Resource2, Amount2)),
    Resource1 != Resource2.
    
correlated(Resource1,Resource2,negative) :-
    result(Outcome,decrease(Resource1, Amount1)),
    result(Outcome,increase(Resource2, Amount2)).
        
timingAffectsEntity(Entity) :- 
    physicsLogic(Entity, PhysicsType),
    timingBasedPhysics(PhysicsType).

    
consumedBy(Resource, Outcome) :-
    precondition(Condition, Outcome),
    highThreshold(Condition, Resource),
    result(Outcome,decrease(Resource, _)).
    

timingAffectsAction(BUTTON,BUTTON_STATE) :- 
    precondition(control_event(BUTTON,BUTTON_STATE),Outcome),
    precondition(overlaps(ENTITY_A,ENTITY_B,POLARITY),Outcome),
    timingAffectsEntity(ENTITY_A).

timingAffectsAction(BUTTON,BUTTON_STATE) :- 
    precondition(control_event(BUTTON,BUTTON_STATE),Outcome),
    precondition(overlaps(ENTITY_A,ENTITY_B,POLARITY),Outcome),
    timingAffectsEntity(ENTITY_B).
  
timingChallenge(BUTTON,BUTTON_STATE) :- 
    actionHasRiskReward(BUTTON,BUTTON_STATE),
    timingAffectsAction(BUTTON,BUTTON_STATE).


    
goal(achieve(Outcome)) :-
    result(Outcome, mode_change(game_win)).
goal(achieve(Outcome)) :-
    result(Outcome, mode_change(game_end)).
    
goal(prevent(Outcome)) :-
    result(Outcome, mode_change(game_loss)).

result(Outcome, decrease(Resource, 1)) :-
    result(Outcome, delete(Entity)),
    resourceLogic(Resource, count(Entity)).
    
result(Outcome, increase(Resource,1)) :-
    result(Outcome,add(Entity)),
    resourceLogic(Resource,count(Entity)).
    
    
requiredBy(Outcome, Entity) :-
    precondition(overlaps(Entity,Entity_B,POLARITY),Outcome).
    
requiredBy(Outcome, Entity) :-
    precondition(overlaps(Entity_B,Entity,POLARITY),Outcome).
    

%% Relationships between outcomes

enables(Enabler, Enabled) :-
    outcome_enables(Enabler, Result),
    result_enables(Result, Enabled),
    Enabler != Enabled.


%% XXX rewrite the below.
enables(Outcome,Outcome2) :-
    result(Outcome,add(ENTITY)), 
    requiredBy(Outcome2,ENTITY),
    Outcome != Outcome2 .
 
hinders(Outcome,Outcome2) :-
    result(Outcome,delete(ENTITY)), 
    requiredBy(Outcome2,ENTITY),
    Outcome != Outcome2 .   
    
% XXX duplicated by result_enables, I think?
% enables(Outcome1, Outcome2) :- 
%     result(Outcome1, decrease(Resource, Amound)), 
%     precondition(Condition, Outcome2),
%     highThreshold(Conditon, Resource),
%     Outcome1 != Outcome2.
%     
% enables(Outcome,Outcome2) :- 
%     result(Outcome,increase(RESOURCE,AMOUNT)), 
%     precondition(gt(RESOURCE,THRESHOLD),Outcome2),
%     Outcome != Outcome2 .
% 
% enables(Outcome,Outcome2) :- 
%     result(Outcome,decrease(RESOURCE,AMOUNT)), 
%     precondition(le(RESOURCE,THRESHOLD),Outcome2),
%     Outcome != Outcome2 .
%  
% enables(Outcome1, Outcome2) :- 
%     result(Outcome1, increase(Resource, Amount)),
%     precondition(C, Outcome2),
%     highThreshold(C, Resource),
%     Outcome1 != Outcome2).
   
    
hinders(Outcome,Outcome2) :- 
    result(Outcome,increase(RESOURCE,AMOUNT)), 
    precondition(lt(RESOURCE,THRESHOLD),Outcome2),
    Outcome != Outcome2 .
    
hinders(Outcome,Outcome2) :- 
    result(Outcome,decrease(RESOURCE,AMOUNT)), 
    precondition(gt(RESOURCE,THRESHOLD),Outcome2),
    Outcome != Outcome2 .
    
    
hinders(Outcome,Outcome2) :- 
    result(Outcome,increase(RESOURCE,AMOUNT)), 
    precondition(le(RESOURCE,THRESHOLD),Outcome2),
    Outcome != Outcome2 .
    
hinders(Outcome,Outcome2) :- 
    result(Outcome,decrease(RESOURCE,AMOUNT)), 
    precondition(ge(RESOURCE,THRESHOLD),Outcome2),
    Outcome != Outcome2 .

%% Collision and movement
collide_precond(E1, E2, Outcome)
  :- precondition(collide(E1, E2), Outcome).
collide_precond(E2, E1, Outcome)
  :- precondition(collide(E1, E2), Outcome).

result_enables_condition(move_toward(E1, E2), collide(E1, E2))
    :- condition(collide(E1, E2)),
       result(_, move_toward(E1, E2)).

result_enables_condition(move_toward(E1, E2), collide(E2, E1))
    :- condition(collide(E1, E2)),
       result(_, move_toward(E1, E2)).

result_enables_condition(move_away(E1, E2), collide(E1, E3))
    :- condition(collide(E1, E3)),
       result(_, move_away(E1, E2)).

result_enables_condition(increase(Resource), Condition)
    :- highThreshold(Condition, Resource).

result_enables_condition(decrease(Resource), Condition)
    :- lowThreshold(Condition, Resource).

result_enables(Result, Outcome) :-
    result_enables_condition(Result, Condition),
    precondition(Condition, Outcome).

outcome_enables(Outcome, Result) :-
    result(Outcome, Result).

outcome_enables(Outcome, Result) :-
    result(Outcome, Result'),
    result_enables(Result', Outcome'),
    outcome_enables(Outcome', Result).

conditionEnables(C, O) :-
    precondition(C, O).

conditionEnables(C, O) :-
    conditionEnables(C, O'),
    enables(O', O).

%% Transitivity of enablement
enables(Outcome1, Outcome3) :-
    enables(Outcome1, Outcome2),
    enables(Outcome2, Outcome3).

%% More outcome favorability
outcomeFavorable(Outcome) :-
    enables(Outcome, Outcome'),
    outcomeFavorable(Outcome').

outcomeUnfavorable(Outcome) :-
    enables(Outcome, Outcome'),
    outcomeUnfavorable(Outcome').
 
selection(Outcome) :-
    result(Outcome,select(ENTITY,CONDITION)).

allocation(RESOURCE) :- 
    consumedBy(RESOURCE,Outcome),
    selection(Outcome).
    
    
subGoal(prevent(Outcome_PRIME),1) :-
    enables(Outcome_PRIME,Outcome),
    goal(prevent(Outcome)),
    not subGoal(achieve(Outcome_PRIME),1),
    humanAffected(Outcome_PRIME). 
    
subGoal(achieve(Outcome_PRIME),1) :-
    hinders(Outcome_PRIME,Outcome),
    goal(prevent(Outcome)),
    humanAffected(Outcome_PRIME).
    

subGoal(achieve(Outcome_PRIME),1) :-
    enables(Outcome_PRIME,Outcome),
    goal(achieve(Outcome)),
    humanAffected(Outcome_PRIME).

subGoal(prevent(Outcome_PRIME),I+1) :-
    enables(Outcome_PRIME,Outcome),
    subGoal(prevent(Outcome),I),
    humanAffected(Outcome_PRIME),
    I < 1. 
    
subGoal(achieve(Outcome_PRIME),I+1) :-
    hinders(Outcome_PRIME,Outcome),
    goal(prevent(Outcome),I),
    humanAffected(Outcome_PRIME),
    I < 1.
    

goal(relates(Outcome)) :- 
    goal(achieve(Outcome)).
    
goal(relates(Outcome)) :-
    goal(prevent(Outcome)).

goal(achieve(Outcome)) :- 
    subGoal(achieve(Outcome),DEPTH).
    
goal(prevent(Outcome)) :-
    subGoal(prevent(Outcome),DEPTH).
    
timingChallengeGoal :- 
    goal(achieve(Outcome)),
    precondition(control_event(BUTTON,BUTTON_STATE),Outcome),
    timingChallenge(BUTTON,BUTTON_STATE).
    

timingChallengeGoal :- 
    goal(achieve(Outcome)),
    precondition(control_event(BUTTON,BUTTON_STATE),Outcome),
    timingChallenge(BUTTON,BUTTON_STATE).

goal(limit(Resource)) :-
    precondition(Condition, Outcome),
    highThreshold(Condition, Resource),
    goal(prevent(Outcome)).
    
goal(maintain(Resource)) :-
    precondition(Condition, Outcome),
    lowThreshold(Condition, Resource),
    goal(prevent(Outcome)).
 
goal(eliminate(Resource)) :-
    precondition(Condition, Outcome),
    lowThreshold(Condition, Resource),
    goal(achieve(Outcome)).
   
easy(Outcome) :-
    unrestricted(Outcome).

easy(Outcome) :-
    precondition(overlaps(ENTITY_A,ENTITY_B,false),Outcome),
    not agent(ENTITY_A),
    not agent(ENTITY_B).
    
goal(maintain(RESOURCE)) :-
    precondition(le(RESOURCE,THRESHOLD),Outcome),
    goal(prevent(Outcome)).
 
goal(eliminate(RESOURCE)) :-
    precondition(le(RESOURCE,THRESHOLD),Outcome),
    goal(achieve(Outcome)).
   
isEasy :-
    goal(achieve(Outcome)),
    easy(Outcome).
    
nonMonotonic(Resource) :-
    result(Outcome1, decrease(Resource, _)),
    result(Outcome2, increase(Resource, _)).

nonMonotonic(Resource) :-
    result(Outcome, set_to(Resource, Value)).
    
monotonicallyDecreases(Resource) :- 
    result(Outcome1, decrease(Resource, Amount)),
    not nonMonotonic(Resource).
 
monotonicallyIncreases(Resource) :- 
    result(Outcome1, increase(Resource, Amount)),
    not nonMonotonic(Resource).


    

%% XXX revisit these

humanAffected(Outcome) :-
    precondition(control_event(BUTTON,STATE),Outcome).
    
    
humanControlled(ENTITY) :-        
     physicsLogic(ENTITY, mapping(control_event(_), DIR, AMOUNT)).
    
humanControlled(ENTITY) :-        
    physicsLogic(ENTITY, follows(cursor)).

humanAffected(Outcome) :-
    requiredBy(Outcome,ENTITY),
    humanControlled(ENTITY).
    
humanAffected(Outcome2) :-
    enables(Outcome1,Outcome2),
    humanAffected(Outcome1).

restrictedEntity(ENTITY) :- 
    entity(ENTITY),
    not humanControlled(ENTITY).
    
restrictedEntity(ENTITY) :-
    result(Outcome,applyRestitution(ENTITY)).
    
restrictedEntity(ENTITY) :-
    precondition(overlaps(ENTITY,OTHER,POLARITY),Outcome),
    result(Outcome,delete(ENTITY)).
    
    
restrictedEntity(ENTITY) :-
    precondition(overlaps(OTHER,ENTITY,POLARITY),Outcome),
    result(Outcome,delete(ENTITY)).

unrestrictedEntity(ENTITY) :-
    entity(ENTITY), 
    not restrictedEntity(ENTITY).
    
    
restrictedCondition(overlaps(ENTITY_A,ENTITY_B,POLARITY)) :-
    precondition(overlaps(ENTITY_A,ENTITY_B,POLARITY),Outcome),
    restrictedEntity(ENTITY_A).

restrictedCondition(overlaps(ENTITY_A,ENTITY_B,POLARITY)) :-
    precondition(overlaps(ENTITY_A,ENTITY_B,POLARITY),Outcome),
    restrictedEntity(ENTITY_B).

unrestrictedCondition(overlaps(ENTITY_A,ENTITY_B,POLARITY)) :-
    precondition(overlaps(ENTITY_A,ENTITY_B,POLARITY),Outcome),
    not restrictedCondition(overlaps(ENTITY_A,ENTITY_B,POLARITY)).
    
restricted(Outcome) :-
    precondition(CONDITION, Outcome),
    not unrestrictedCondition(CONDITION).
  
    
unrestricted(Outcome) :-
    outcome(Outcome),
    not restricted(Outcome).

unrestrictedCondition(lt(RESOURCE,THRESHOLD)) :-
    monotonicallyDecreases(RESOURCE),
    precondition(lt(RESOURCE,THRESHOLD),SOME_Outcome),
    result(Outcome,decrease(RESOURCE,AMOUNT)),
    unrestricted(Outcome).
  

    
unrestrictedCondition(gt(RESOURCE,THRESHOLD)) :-
    monotonicallyIncreases(RESOURCE),
    precondition(gt(RESOURCE,THRESHOLD),SOME_Outcome),
    result(Outcome,increase(RESOURCE,AMOUNT)),
    unrestricted(Outcome).

    
unrestrictedCondition(le(RESOURCE,THRESHOLD)) :-
    monotonicallyDecreases(RESOURCE),
    precondition(le(RESOURCE,THRESHOLD),SOME_Outcome),
    result(Outcome,decrease(RESOURCE,AMOUNT)),
    unrestricted(Outcome).
  

    
unrestrictedCondition(ge(RESOURCE,THRESHOLD)) :-
    monotonicallyIncreases(RESOURCE),
    precondition(ge(RESOURCE,THRESHOLD),SOME_Outcome),
    result(Outcome,increase(RESOURCE,AMOUNT)),
    unrestricted(Outcome).

    
gradual(Outcome) :-
    precondition(tick,Outcome).
gradual(Outcome_PRIME) :-
    gradual(Outcome),
    enables(Outcome,Outcome_PRIME).

amount(AMOUNT) :-
    result(Outcome,increase(RESOURCE,AMOUNT)).
amount(AMOUNT) :- 
    result(Outcome,decrease(RESOURCE,AMOUNT)).
   
medium_stakes :-
    enables(GOOD_STEP,GOAL_Outcome),
    goal(achieve(GOAL_Outcome)),
    hinders(BAD_STEP,GOOD_STEP),
    gradual(GOOD_STEP).
    
thoughtful :-
    medium_stakes,
    allocation(RESOURCE),
    limited(RESOURCE).
 

    
replenishible(RESOURCE) :-
    2 {result(Outcome1,increase(RESOURCE,AMOUNT1));
    result(Outcome2,decrease(RESOURCE,AMOUNT2));
    result(Outcome3,set_to(RESOURCE,AMOUNT3))}, resource(RESOURCE).

    

limited(RESOURCE) :-
    not replenishible(RESOURCE),
    result(Outcome,decrease(RESOURCE,AMOUNT)).
      
    
playerAgency(ENTITY) :- 
    physicsLogic(ENTITY,follows(cursor)).

playerAgency(ENTITY) :- 
    physicsLogic(ENTITY,follows(mouse_cursor)).

playerAgency(ENTITY) :-    
    physicsLogic(ENTITY,mapping(control_event(BUTTON,STATE),DIRECTION,AMOUNT)).

%% Entity influence and determination
entityInfluences(Entity, Outcome) :-
    precondition(near(Entity, _), Outcome).

% XXX there should be more rules here for more entity preconditions

entityDetermines(Entity, Outcome) :-
    entityInfluences(Entity, Outcome),
    onlyOnePrecondition(Outcome).



%% Player influence and determination

playerCreatesCondition(control_event(E)) :-
    precondition(control_event(E), Outcome).

playerCreatesCondition(near(Entity, Other)) :-
    playerAgency(Entity),
    precondition(near(Entity, Other), Outcome).

playerInfluences(Outcome) :-
    playerCreatesCondition(C),
    precondition(C, Outcome).

playerInfluences(Outcome) :-
    playerAgency(Entity),
    entityInfluences(Entity, Outcome).

playerDetermines(Outcome) :-
    playerInfluences(Outcome),
    onlyOnePrecondition(Outcome).

% XXX: to make this more general we should have some way of stating
% that all preconditions have some property.


%% Player prediction/lightweight modeling

playerWillDo(Cond, Outcome) :-
  playerCreatesCondition(Cond),
  conditionEnables(Cond, Outcome),
  outcomeFavorable(Outcome).

  

% %% KNOWLEGE BASE

% XXX what is the below needed for?
% unrestrictedCondition(control_event(BUTTON,BUTTON_STATE) :- buttons(BUTTON), buttonStates(BUTTON_STATE).

unrestrictedCondition(control_event(click(BUTTON))) :- buttons(BUTTON). 

unrestrictedCondition(tick).

unrestrictedGame :- 
    unrestricted(Outcome),
    result(Outcome,mode_change(story_progression)).

unrestrictedGame :- 
    unrestricted(Outcome),
    result(Outcome,mode_change(game_win)).
    

timingBasedPhysics(spring;pendulum;chase;random;random_chase;flee;random_flee).
threshold(mid;high;low).
threshold(R) :-
    resource(R).

    
