
good(RESOURCE) :-     
    precondition(
        below(RESOURCE, THRESHOLD), OUTCOME),
    result(OUTCOME,game_loss).
    
bad(RESOURCE) :- 
    precondition(
        above(RESOURCE, THRESHOLD), OUTCOME),
    result(OUTCOME,game_loss).

bad(RESOURCE) :-     
    precondition(
        below(RESOURCE,THRESHOLD), OUTCOME),
    result(OUTCOME,game_win).
    
good(RESOURCE) :- 
    precondition(
        above(RESOURCE,THRESHOLD), OUTCOME),
    result(OUTCOME,game_win).
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
    result(OUTCOME,decreases(RESOURCE)).
worseWithTime(RESOURCE) :- 
    bad(RESOURCE),
    precondition(time,OUTCOME), 
    onlyOnePrecondition(OUTCOME),
    result(OUTCOME,increases(RESOURCE)).

betterWithTime(RESOURCE) :- 
    bad(RESOURCE),
    precondition(time,OUTCOME), 
    onlyOnePrecondition(OUTCOME),
    result(OUTCOME,decreases(RESOURCE)).
betterWithTime(RESOURCE) :- 
    good(RESOURCE),
    precondition(time,OUTCOME), 
    onlyOnePrecondition(OUTCOME),
    result(OUTCOME,increases(RESOURCE)).
    
    
playerActionHelps(PLAYER_ACTION,RESOURCE) :-
    good(RESOURCE),
    precondition(control_event(PLAYER_ACTION),OUTCOME),
    result(OUTCOME,increases(RESOURCE)).

playerActionHelps(PLAYER_ACTION,RESOURCE) :-
    bad(RESOURCE),
    precondition(control_event(PLAYER_ACTION),OUTCOME),
    result(OUTCOME,decreases(RESOURCE)).
    
playerActionHurts(PLAYER_ACTION,RESOURCE) :-
    bad(RESOURCE),
    precondition(control_event(PLAYER_ACTION),OUTCOME),
    result(OUTCOME,increases(RESOURCE)).

playerActionHurts(PLAYER_ACTION,RESOURCE) :-
    good(RESOURCE),
    precondition(control_event(PLAYER_ACTION),OUTCOME),
    result(OUTCOME,decreases(RESOURCE)).

    
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
    
    
timingAffects(ENTITY) :- 
    physicsLogic(ENTITY,PHYSICS_TYPE),
    timingBasedPhysics(PHYSICS_TYPE).


timingAffects(PLAYER_ACTION) :- 
    precondition(control_event(PLAYER_ACTION),OUTCOME),
    precondition(collides(ENTITY_A,ENTITY_B,POLARITY),OUTCOME),
    timingAffects(ENTITY_A).

timingAffects(PLAYER_ACTION) :- 
    precondition(control_event(PLAYER_ACTION),OUTCOME),
    precondition(collides(ENTITY_A,ENTITY_B,POLARITY),OUTCOME),
    timingAffects(ENTITY_B).

    
timingChallenge(PLAYER_ACTION) :- 
    actionHasRiskReward(PLAYER_ACTION),
    timingAffects(PLAYER_ACTION).

goal(achieve(OUTCOME)) :-
    result(OUTCOME, game_win).
    
goal(prevent(OUTCOME)) :-
    result(OUTCOME, game_loss).
    
enables(OUTCOME,OUTCOME2) :- result(OUTCOME,decreases(RESOURCE)), precondition(below(RESOURCE,THRESHOLD),OUTCOME2).
    
enables(OUTCOME,OUTCOME2) :- result(OUTCOME,increases(RESOURCE)), precondition(above(RESOURCE,THRESHOLD),OUTCOME2).
    
hinders(OUTCOME,OUTCOME2) :- result(OUTCOME,increases(RESOURCE)), precondition(below(RESOURCE,THRESHOLD),OUTCOME2).
    
hinders(OUTCOME,OUTCOME2) :- result(OUTCOME,decreases(RESOURCE)), precondition(above(RESOURCE,THRESHOLD),OUTCOME2).

enables(OUTCOME,OUTCOME3) :- hinders(OUTCOME,OUTCOME2), hinders(OUTCOME2,OUTCOME3).
enables(OUTCOME,OUTCOME3) :- enables(OUTCOME,OUTCOME2), enables(OUTCOME2,OUTCOME3).

hinders(OUTCOME,OUTCOME3) :- hinders(OUTCOME,OUTCOME2), enables(OUTCOME2,OUTCOME3).
hinders(OUTCOME,OUTCOME3) :- enables(OUTCOME,OUTCOME2), hinders(OUTCOME2,OUTCOME3).



subGoal(prevent(OUTCOME_PRIME),1) :-
    enables(OUTCOME_PRIME,OUTCOME),
    goal(prevent(OUTCOME)). 
    
subGoal(achieve(OUTCOME_PRIME),1) :-
    hinders(OUTCOME_PRIME,OUTCOME),
    goal(prevent(OUTCOME)).

goal(relates(OUTCOME)) :- 
    goal(achieve(OUTCOME)).
    
goal(relates(OUTCOME)) :-
    goal(prevent(OUTCOME)).

goal(relates(OUTCOME)) :- 
    subGgoal(achieve(OUTCOME),DEPTH).
    
goal(relates(OUTCOME)) :-
    subGoal(prevent(OUTCOME),DEPTH).
    
timingChallengeGoal :- 
    goal(relates(OUTCOME)),
    precondition(control_event(PLAYER_ACTION),OUTCOME),
    timingChallenge(PLAYER_ACTION).

% goal(maintain,RESOURCE) :- 
    % precondition(below_0(RESOURCE), 
    % modeLogic(game_loss)).
    
% goal(eliminate,RESOURCE) :- 
    % precondition(below_0(RESOURCE), 
    % modeLogic(game_win)).
% goal(LOGIC) :- 
    % precondition(LOGIC, 
    % modeLogic(game_win)).
% goal(LOGIC) :- 
    % precondition(LOGIC, 
    % narrativeLogic(story_progression)).

% goalIsEasy(goal(LOGIC)) :-
    % easy(LOGIC).
    
% timingChallengeToMaintain(RESOURCE) :- 
    % goal(maintain,RESOURCE),
    % timingChallenge(RESOURCE).
 
% possibleStates(STATE) :- 
    % canHappen(graphicalLogic(ENTITY,STATE,ACTION)).
     
% canHappen(LOGIC) :- 
    % precondition(ANYTHING , LOGIC).
% canHappen(LOGIC) :- 
    % precondition(LOGIC , ANYTHING).

% monotonicallyDecreases(ENTITY) :- 
    % canHappen(graphicalLogic(ENTITY,STATE,removed)), 
    % not canHappen(graphicalLogic(ENTITY,OTHER_STATE,added)), 
    % possibleStates(OTHER_STATE).
 
% entities(ENTITY) :- 
    % canHappen(graphicalLogic(ENTITY,STATE,ACTION)).
% entities(ENTITY) :-
    % graphicalLogic(ENTITY,STATE).
    
% unrestricted(ENTITY) :- 
    % physicsLogic(ENTITY,controlLogic(LOGIC)),
    % not collisionLogic(ENTITY,ENTITY_B,blocked),
    % entities(ENTITY_B).
    
% unrestricted(ENTITY) :- 
    % physicsLogic(ENTITY,controlLogic(LOGIC)),
    % not collisionLogic(ENTITY_B,ENTITY,blocked),
    % entities(ENTITY_B).

% unrestricted(collisionLogic(ENTITY,ENTITY_B,TYPE)) :-
    % unrestricted(ENTITY),
    % canHappen(collisionLogic(ENTITY,ENTITY_B,TYPE)).

% unrestricted(collisionLogic(ENTITY,ENTITY_B,TYPE)) :-
    % unrestricted(ENTITY_B),
    % canHappen(collisionLogic(ENTITY,ENTITY_B,TYPE)).    

% restricted(LOGIC) :-
    % precondition(RESTRICTED,LOGIC),
    % not unrestricted(RESTRICTED).
% unrestricted(LOGIC) :-
    % precondition(UNRESTRICTED,LOGIC),
    % unrestricted(UNRESTRICTED).
% %All such preconditions must be unrestricted?
% unrestricted(graphicalLogic(ENTITY,ACTION)) :- 
    % unrestricted(graphicalLogic(ENTITY,STATE,ACTION)).

% easy(graphicalLogic(ENTITY,removed)) :-
    % unrestricted(graphicalLogic(ENTITY,removed)),
    % monotonicallyDecreases(ENTITY).

% easy(LOGIC) :- 
    % precondition(EASY,LOGIC),
    % easy(EASY).

% %% KNOWLEGE BASE

% unrestricted(controlLogic(click)). %player can always click

