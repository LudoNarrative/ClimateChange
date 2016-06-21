%%% Rules to encode
 % limited/unlimited

notImmediatelyRepeatable(O) :-
  result(O, R),
  result_hinders(R, O).

exists_counterforce(Resource) :-
  notImmediatelyRepeatable(O),
  outcomeFavorable(O),
  outcomeAffect(Resource, O, positive),
  good(Resource).

  
screen(screen_top;screen_left;screen_bottom;screen_right).
% entity(E) :- screen(E).
oppositeSides(screen_top,screen_bottom).
oppositeSides(screen_left,screen_right).
oppositeSides(A,B) :- oppositeSides(B,A).

lowThreshold(lt(Resource, Thresh), Resource,Thresh) :-
    resource(Resource),
    threshold(Thresh).

lowThreshold(le(Resource, Thresh), Resource,Thresh) :-
    resource(Resource),
    threshold(Thresh).


highThreshold(gt(Resource, Thresh), Resource, Thresh) :-
    resource(Resource),
    threshold(Thresh).

highThreshold(ge(Resource, Thresh), Resource,Thresh) :-
    resource(Resource),
    threshold(Thresh).

lhThreshold(COND,Resource,Thresh) :-
    lowThreshold(COND,Resource,Thresh).

lhThreshold(COND,Resource,Thresh) :-
    highThreshold(COND,Resource,Thresh).

resource(Resource) :-
    resource(Resource,Entity).


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

badResult(add(Entity)) :-
    result(_, add(Entity)),
    harmful(Entity).

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
    lowThreshold(Pre, Resource,Thresh).

needsHigh(Outcome, Resource) :-
    precondition(Pre, Outcome),
    highThreshold(Pre, Resource,Thresh).


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
    highThreshold(Condition, Resource, Thresh),
    result(Outcome, decrease(Resource, _)).
    

timingAffectsAction(control_event(Control)) :- 
    precondition(control_event(Control),Outcome),
    precondition(overlaps(ENTITY_A,ENTITY_B,POLARITY),Outcome),
    timingAffectsEntity(ENTITY_A).

timingAffectsAction(control_event(Control)) :- 
    precondition(control_event(Control),Outcome),
    precondition(overlaps(ENTITY_A,ENTITY_B,POLARITY),Outcome),
    timingAffectsEntity(ENTITY_B).
  
timingChallenge(control_event(Control)) :- 
    actionHasRiskReward(Control),
    timingAffectsAction(control_event(Control)).


    
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
    
requiredBy(Outcome, Entity) :-
    precondition(control_event(click(Entity)),Outcome).

requiredBy(Outcome, Entity) :-
    precondition(near(Entity,EntityB),Outcome).
requiredBy(Outcome, Entity) :-
    precondition(near(EntityB,Entity),Outcome).
requiredBy(Outcome, Entity) :-
    precondition(near(EntityB,Entity),Outcome).

requiredBy(Outcome, Entity) :-
    lowThreshold(Condition, Resource,Thresh),
    precondition(Condition,Outcome),
    resourceLogic(Resource, count(Entity)).
requiredBy(Outcome, Entity) :-
    highThreshold(Condition, Resource,Thresh),
    precondition(Condition,Outcome),
    resourceLogic(Resource, count(Entity)).

%% Relationships between outcomes

enables(Enabler, Enabled) :-
    outcome_enables(Enabler, Result),
    result_enables(Result, Enabled),
    Enabler != Enabled.


sharedResource(R, Outcome1, Outcome2) :-
    consumedBy(R, Outcome1),
    consumedBy(R, Outcome2),
    % outcome(Outcome1), outcome(Outcome2), resource(R),
    Outcome1 != Outcome2.

sharedEntity(E, Outcome1, Outcome2) :-
    requiredBy(Outcome1, E),
    requiredBy(Outcome2, E),
    result(_, delete(E)).

sharing(O1, O2) :-
    sharedResource(R, O1, O2).
sharing(O1, O2) :-
    sharedEntity(E, O1, O2).

hasSharing :- sharing(O1, O2).

%% XXX rewrite the below.
enables(Outcome, Outcome2) :-
    result(Outcome, add(Entity)), 
    requiredBy(Outcome2, Entity),
    Outcome != Outcome2 .
 
hinders(Outcome, Outcome2) :-
    result(Outcome, delete(Entity)), 
    requiredBy(Outcome2, Entity),
    Outcome != Outcome2.   
 
tiedToDifficulty(Resource) :-
    result(Outcome,moves(Entity,Direction,Resource)),
    antagonist(Entity).

increasingDifficulty :-
    tiedToDifficulty(Resource),
    monotonicallyIncreases(Resource).

futileOutcome :-
    increasingDifficulty,
    not decreasingDifficulty.


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
    :- highThreshold(Condition, Resource,Thresh).

result_enables_condition(decrease(Resource), Condition)
    :- lowThreshold(Condition, Resource,Thresh).



result_enables(Result, Outcome) :-
    result_enables_condition(Result, Condition),
    precondition(Condition, Outcome).

result_amplifies(increase(Amplifier), Outcome) :-
    result_enables(increase(Resource),Outcome),
    amplifies(Amplifier, Resource).

%% Prevents/inhibits/hinders

learnedCondition(C)
  :- condition(C).
learnedCondition(C)
  :- learnedCondition(C'),
     implies(C', C).

implies(collide(E1, E2), overlaps(E1, E2))
  :- condition(collide(E1, E2)).

implies(overlaps(E1, E2), present(E1))
  :- learnedCondition(overlaps(E1, E2)).

implies(overlaps(E1, E2), present(E2))
  :- learnedCondition(overlaps(E1, E2)).

implies(X, Z)
  :- implies(X, Y),
     implies(Y, Z).
implies(X, X)
  :- condition(X).

inhibits(Result, Condition) :-
  negates(Result, Condition'),
  implies(Condition, Condition').

negates(delete(E), present(E))
  :- result(_, delete(E)),
     learnedCondition(present(E)).

result_hinders(R, O) :-
  inhibits(R, Condition),
  precondition(Condition, O).


% XXX rewrite with thresholds.
increasing_costs(Outcome,Cost) :-
    precondition(ge(Money,Cost), Outcome),
    result(Outcome, increase(Cost, Amount)).

increasing_costs(Outcome,Cost) :-
    precondition(gt(Money,Cost), Outcome),
    result(Outcome, increase(Cost, Amount)).

decreasing_costs(Outcome,Cost) :-
    precondition(ge(Money,Cost), Outcome),
    result(Outcome, decrease(Cost, Amount)).

decreasing_costs(Outcome,Cost) :-
    precondition(gt(Money,Cost), Outcome),
    result(Outcome, decrease(Cost, Amount)).




positive_feedback(Resource) :-
    result_amplifies(increase(Resource),Outcome),
    result(Outcome,increase(Resource,Amount)).

outcome_enablesN(Outcome, Result,0) :-
    result(Outcome, Result).

outcome_enablesN(Outcome, Result,N+1) :-
    result(Outcome, Result'),
    result_enables(Result', Outcome'),
    outcome_enablesN(Outcome', Result,N),
    N < 1.

outcome_enables(C,O) :-
    outcome_enablesN(C,O,N).
    
conditionEnables(C,O) :-
    conditionEnablesN(C,O,N).
conditionEnablesN(C, O,0) :-
    precondition(C, O).

conditionEnablesN(C, O,N+1) :-
    conditionEnablesN(C, O',N),
    enables(O', O),
    N < 1.
conditionEnables(C,O) :-
    conditionEnablesN(C,O,N).
%% Transitivity of enablement
% enables(Outcome1, Outcome3) :-
    % enables(Outcome1, Outcome2),
    % enables(Outcome2, Outcome3).

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


destroys(Destroyer,Destroyed) :-
    precondition(overlaps(Destroyed, Destroyer), Outcome),
    result(Outcome, delete(Destroyed)).

destroys(Destroyer,Destroyed) :-
    precondition(overlaps(Destroyer, Destroyed), Outcome),
    result(Outcome, delete(Destroyed)).

antagonist(Destroyer) :-
    destroys(Destroyer,Destroyed),
    requiredBy(Outcome,Destroyed),
    playerWillDo(Condition,Outcome).


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
    highThreshold(Condition, Resource,Thresh),
    goal(prevent(Outcome)).
    
goal(maintain(Resource)) :-
    precondition(Condition, Outcome),
    lowThreshold(Condition, Resource,Thresh),
    goal(prevent(Outcome)).

good(Resource) :- goal(gain(Resource)).
 
goal(gain(Resource)) :-
    precondition(Condition, Outcome),
    highThreshold(Condition, Resource,Thresh),
    goal(achieve(Outcome)).

goal(eliminate(Resource)) :-
    precondition(Condition, Outcome),
    lowThreshold(Condition, Resource,Thresh),
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

constant(Resource) :-
    resource(Resource),
    not nonMonotonic(Resource),
    not monotonicallyDecreases(Resource),
    not monotonicallyIncreases(Resource).
    

    

%% XXX revisit these

humanAffected(Outcome) :-
    precondition(control_event(BUTTON,STATE),Outcome).
    
    
humanControlled(ENTITY) :-        
     physicsLogic(ENTITY, mapping(control_event(_), DIR, AMOUNT)).
    
    
humanControlled(Entity) :-        
     playerAgency(Entity).
     
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
    
unrestrictedCondition(control_event(BUTTON,STATE)) :-
    precondition(control_event(BUTTON,STATE),Outcome) .
    
    
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

    
playerAgency(ENTITY) :-    
    precondition(control_event(BUTTON,STATE),OUTCOME),
    result(OUTCOME,moves(ENTITY,  DIRECTION , AMOUNT)).
    
    
%% Entity influence and determination
entityInfluences(Entity, Outcome) :-
    precondition(near(Entity, _), Outcome).

entityInfluences(Entity, Outcome) :-
    precondition(overlaps(Entity, _), Outcome).
entityInfluences(Entity, Outcome) :-
    precondition(overlaps(_,Entity), Outcome).
entityInfluences(Entity, Outcome) :-
    precondition(timerElapsed(Entity,_), Outcome).
% XXX there should be more rules here for more entity preconditions

entityDetermines(Entity, Outcome) :-
    entityInfluences(Entity, Outcome),
    onlyOnePrecondition(Outcome).
    
entityInfluencesOther(EntityA,EntityB) :-
    precondition(overlaps(EntityA,EntityB),OUTCOME),
    result(OUTCOME,reflect_velocity(EntityB,Normal)).

entityInfluencesOther(EntityA,EntityB) :-
    precondition(overlaps(EntityB,EntityA),OUTCOME),
    result(OUTCOME,reflect_velocity(EntityB,Normal)).

    
entityInfluencesOther(EntityA,EntityB) :-
    precondition(overlaps(EntityA,EntityB),OUTCOME),
    result(OUTCOME,delete(EntityB)).

entityInfluencesOther(EntityA,EntityB) :-
    precondition(overlaps(EntityB,EntityA),OUTCOME),
    result(OUTCOME,delete(EntityB)).
% entityInfluences(Entity,Outcome) :-
    % entityInfluencesOther(Entity,Entity'),
    % entityInfluences(Entity',Outcome).
    
    
%% Player influence and determination

playerCreatesCondition(control_event(E)) :-
    precondition(control_event(E), Outcome).

playerCreatesCondition(control_event(B,S)) :-
    precondition(control_event(B,S), Outcome).
    
playerCreatesCondition(near(Entity, Other)) :-
    playerAgency(Entity),
    precondition(near(Entity, Other), Outcome).

playerInfluences(Outcome) :-
    playerCreatesCondition(C),
    precondition(C, Outcome).

playerInfluences(Outcome) :-
    playerAgency(Entity),
    entityInfluences(Entity, Outcome).


systemInfluences(Outcome) :-
    not playerCreatesCondition(C),
    precondition(C, Outcome).

systemInfluences(Outcome) :-
    not playerAgency(Entity),
    entityInfluences(Entity, Outcome).
    
playerDetermines(Outcome) :-
    playerInfluences(Outcome),
    not systemInfluences(Outcome).
    
% XXX: to make this more general we should have some way of stating
% that all preconditions have some property.


%% Player prediction/lightweight modeling

playerWillDo(Cond, Outcome) :-
  playerCreatesCondition(Cond),
  conditionEnables(Cond, Outcome),
  outcomeFavorable(Outcome).

playerWillAttemptToCreate(Cond,Outcome) :-
    entityDetermines(Determinant,Outcome),
    entityInfluencesOther(Influencer,Determinant),
    playerAgency(Influencer),
    conditionEnables(Cond, Outcome),
    outcomeFavorable(Outcome).

    

playerWillAttemptToAvoid(Cond,Outcome) :-
    entityDetermines(Determinant,Outcome),
    entityInfluencesOther(Influencer,Determinant),
    playerAgency(Influencer),
    conditionEnables(Cond, Outcome),
    outcomeUnfavorable(Outcome).

harmful(Entity) :- 
    entityDetermines(Entity,Outcome),
    outcomeUnfavorable(Outcome).


outcomeFavorable(Outcome) :-
    harmful(Entity),
    result(Outcome,delete(Entity)).
%% Resource flow modeling

%result(OUTCOME, increase(RESOURCE, RESOURCE_VALUE)),
%result(ENABLING_OUTCOME, increase(RESOURCE_VALUE, VALUE)).

bootstrapping(Bootstrapped,Outcome) :-
    playerDetermines(Bootstrapped),
    result(Bootstrapped,increase(Resource,Amount)),
    result_enables(increase(Resource), Outcome).

allocation_choice(Outcome1,Outcome2,Resource) :-
    playerInfluences(Outcome1),
    playerInfluences(Outcome2),
    Outcome1 != Outcome2,
    highThreshold(Cond1,Resource,Thresh1),
    highThreshold(Cond2,Resource,Thresh2),
    consumedBy(Resource,Outcome1),
    consumedBy(Resource,Outcome2),
    precondition(Cond1,Outcome1),
    precondition(Cond2,Outcome2).

lower_cost(initial,Outcome1,Outcome2) :-
    allocation_choice(Outcome1,Outcome2,Resource),
    highThreshold(Cond1,Resource,Thresh1),
    highThreshold(Cond2,Resource,Thresh2),
    precondition(Cond1,Outcome1),
    precondition(Cond2,Outcome2),
    lower_than(Thresh1,Thresh2).
    
lower_cost(always,Outcome1,Outcome2) :-
    allocation_choice(Outcome1,Outcome2,Resource),
    highThreshold(Cond1,Resource,Thresh1),
    highThreshold(Cond2,Resource,Thresh2),
    precondition(Cond1,Outcome1),
    precondition(Cond2,Outcome2),
    lower_than(Thresh1,Thresh2).

outcome_entity_cost(Outcome,Entity,Thresh) :-
    highThreshold(Cond,Resource,Thresh),
    precondition(Cond,Outcome),
    requiredBy(Outcome,Entity).
    
outcome_costs(Outcome,Resource) :-
    highThreshold(Cond,Resource,Thresh),
    precondition(Cond,Outcome).

lower_cost(initial,Outcome1,Outcome2) :-
    allocation_choice(Outcome1,Outcome2,Resource),
    outcome_entity_cost(Outcome1,Entity1,Thresh1),
    outcome_entity_cost(Outcome2,Entity2,Thresh2),
    initialize(set(Entity1,Thresh1,Value1)),
    initialize(set(Entity2,Thresh2,Value2)),
    lower_than(Value1,Value2).


investment(Outcome) :-
    positive_feedback(Amplifier),
    result(Outcome,increase(Amplifier,Amount)),
    outcome_costs(Outcome,Resource),
    amplifies(Amplifier,Resource).
% %% KNOWLEGE BASE

sameRepresentation(EntityA,EntityB) :-
    initialize(set_sprite(EntityA,Sprite)),
    initialize(set_sprite(EntityB,Sprite)),
    EntityA != EntityB.

symmetricMotion(EntityA,EntityB) :-
    result(OutcomeA,moves(EntityA,  Direction , Amount)),
    result(OutcomeB,moves(EntityB,  Direction , Amount)),
    EntityA != EntityB.

symmetricOutcome(OutcomeA,OutcomeB) :-    
    precondition(ge(ResourceA,Thresh),OutcomeA),
    outcomeFavorable(OutcomeA),
    precondition(ge(ResourceB,Thresh), OutcomeB),
    outcomeUnfavorable(OutcomeB).

screenSymmetric(OutcomeA,OutcomeB) :-
    precondition(overlaps(EntityA,SideA),OutcomeA),
    precondition(overlaps(EntityB,SideB),OutcomeB),
    oppositeSides(SideA,SideB).

symmetricResources(ResourceA,ResourceB) :-
    screenSymmetric(OutcomeA,OutcomeB),
    result(OutcomeA,increase(ResourceA,Amount)),
    result(OutcomeB,increase(ResourceB,Amount)).

symmetricResources(ResourceA,ResourceB) :-
    screenSymmetric(OutcomeA,OutcomeB),
    result(OutcomeA,decrease(ResourceA,Amount)),
    result(OutcomeB,decrease(ResourceB,Amount)).

symmetricOutcome(OutcomeA,OutcomeB) :-    
    precondition(ge(ResourceA,Thresh),OutcomeA),
    outcomeFavorable(OutcomeA),
    precondition(ge(ResourceB,Thresh), OutcomeB),
    outcomeUnfavorable(OutcomeB).

symmetricGoals :-
    goal(limit(ResourceB)),
    goal(gain(ResourceA)),
    symmetricResources(ResourceA,ResourceB).

symmetricCompetition :- 
    sameRepresentation(EntityA,EntityB),
    symmetricMotion(EntityA,EntityB),
    symmetricGoals.
% XXX what is the below needed for?
% unrestrictedCondition(control_event(BUTTON,BUTTON_STATE) :- buttons(BUTTON), buttonStates(BUTTON_STATE).

antagonist(Antagonist) :-
    entityInfluences(Antagonist,Outcome),
    badResult(Result),
    result(Outcome, Result).

unrestrictedCondition(control_event(click(BUTTON))) :- buttons(BUTTON). 

unrestrictedCondition(tick).

unrestrictedGame :- 
    unrestricted(Outcome),
    result(Outcome,mode_change(story_progression)).

unrestrictedGame :- 
    unrestricted(Outcome),
    result(Outcome,mode_change(game_win)).
    

timingBasedPhysics(spring;pendulum;chase;random;random_chase;flee;random_flee).
threshold(0;mid;high;low).

threshold(R) :-
    resource(R).
threshold(R) :-
    resource(E,R).

    
%% Narrative gating

narrative_gating
:-
  result(O, mode_change(narrative_progress)),
  precondition(C, O),
  lowThreshold(C, R, _),
  result(O', decrease(R, _)).

