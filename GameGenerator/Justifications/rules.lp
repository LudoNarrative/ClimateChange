
good(RESOURCE) :- 
    precondition(below_0(RESOURCE), 
    modeLogic(game_loss)).
good(RESOURCE) :- 
    precondition(below_thresh(RESOURCE,THRESHOLD), 
    modeLogic(game_loss)).
bad(RESOURCE) :- 
    precondition(above_thresh(RESOURCE,THRESHOLD), 
    modeLogic(game_loss)).

bad(RESOURCE) :- 
    precondition(below_0(RESOURCE), 
    modeLogic(game_win)).
bad(RESOURCE) :- 
    precondition(below_thresh(RESOURCE,THRESHOLD), 
    modeLogic(game_win)).
good(RESOURCE) :- 
    precondition(above_thresh(RESOURCE,THRESHOLD), 
    modeLogic(game_win)).


worseWithTime(RESOURCE) :- 
    good(RESOURCE),
    precondition(time,resourceLogic(RESOURCE,decreases,AMOUNT)).
worseWithTime(RESOURCE) :- 
    bad(RESOURCE),
    precondition(time,resourceLogic(RESOURCE,increases,AMOUNT)).

betterWithTime(RESOURCE) :- 
    bad(RESOURCE),
    precondition(time,resourceLogic(RESOURCE,decreases,AMOUNT)).
betterWithTime(RESOURCE) :- 
    good(RESOURCE),
    precondition(time,resourceLogic(RESOURCE,increases,AMOUNT)).
    

playerActionHelps(PLAYER_ACTION,RESOURCE) :-
    good(RESOURCE),
    precondition(controlLogic(PLAYER_ACTION),resourceLogic(RESOURCE,increases,AMOUNT)).
    
playerActionHurts(PLAYER_ACTION,RESOURCE) :-
    good(RESOURCE),
    precondition(controlLogic(PLAYER_ACTION),resourceLogic(RESOURCE,decreases,AMOUNT)).
    
playerActionAffects(PLAYER_ACTION,RESOURCE) :-
    playerActionHurts(PLAYER_ACTION,RESOURCE).
    
playerActionAffects(PLAYER_ACTION,RESOURCE) :-
    playerActionHelps(PLAYER_ACTION,RESOURCE).
    
    
actionHasRiskReward(PLAYER_ACTION,RESOURCE) :- 
    playerActionHelps(PLAYER_ACTION,RESOURCE),
    playerActionHurts(PLAYER_ACTION,RESOURCE).

actionNeededForMaintenance(PLAYER_ACTION,RESOURCE) :-
    playerActionHelps(PLAYER_ACTION,RESOURCE),
    worseWithTime(RESOURCE).
    

timingAffects(ENTITY) :- physicsLogic(ENTITY,PHYSICS_TYPE).


timingAffects(PLAYER_ACTION,RESOURCE) :- 
    precondition(
        controlLogic(PLAYER_ACTION),
        resourceLogic(RESOURCE,DIRECTION,AMOUNT)),
    precondition(
        collisionLogic(ENTITY_A,ENTITY_B,YES_NO),
        resourceLogic(RESOURCE,DIRECTION,AMOUNT)),
    timingAffects(ENTITY_A).

timingAffects(PLAYER_ACTION,RESOURCE) :- 
    precondition(
        controlLogic(PLAYER_ACTION),
        resourceLogic(RESOURCE,DIRECTION,AMOUNT)),
    precondition(
        collisionLogic(ENTITY_A,ENTITY_B,YES_NO),
        resourceLogic(RESOURCE,DIRECTION,AMOUNT)),
    timingAffects(ENTITY_B).
    
timingChallenge(RESOURCE) :- 
    actionHasRiskReward(PLAYER_ACTION,RESOURCE),
    timingAffects(PLAYER_ACTION,RESOURCE).

    
goal(maintain,RESOURCE) :- 
    precondition(below_0(RESOURCE), 
    modeLogic(game_loss)).
    
goal(eliminate,RESOURCE) :- 
    precondition(below_0(RESOURCE), 
    modeLogic(game_win)).
goal(LOGIC) :- 
    precondition(LOGIC, 
    modeLogic(game_win)).
goal(LOGIC) :- 
    precondition(LOGIC, 
    narrativeLogic(story_progression)).

goalIsEasy(goal(LOGIC)) :-
    easy(LOGIC).
    
timingChallengeToMaintain(RESOURCE) :- 
    goal(maintain,RESOURCE),
    timingChallenge(RESOURCE).
 
possibleStates(STATE) :- 
    canHappen(graphicalLogic(ENTITY,STATE,ACTION)).
     
canHappen(LOGIC) :- 
    precondition(ANYTHING , LOGIC).
canHappen(LOGIC) :- 
    precondition(LOGIC , ANYTHING).

monotonicallyDecreases(ENTITY) :- 
    canHappen(graphicalLogic(ENTITY,STATE,removed)), 
    not canHappen(graphicalLogic(ENTITY,OTHER_STATE,added)), 
    possibleStates(OTHER_STATE).
 
entities(ENTITY) :- 
    canHappen(graphicalLogic(ENTITY,STATE,ACTION)).
entities(ENTITY) :-
    graphicalLogic(ENTITY,STATE).
    
unrestricted(ENTITY) :- 
    physicsLogic(ENTITY,controlLogic(LOGIC)),
    not collisionLogic(ENTITY,ENTITY_B,blocked),
    entities(ENTITY_B).
    
unrestricted(ENTITY) :- 
    physicsLogic(ENTITY,controlLogic(LOGIC)),
    not collisionLogic(ENTITY_B,ENTITY,blocked),
    entities(ENTITY_B).

unrestricted(collisionLogic(ENTITY,ENTITY_B,TYPE)) :-
    unrestricted(ENTITY),
    canHappen(collisionLogic(ENTITY,ENTITY_B,TYPE)).

unrestricted(collisionLogic(ENTITY,ENTITY_B,TYPE)) :-
    unrestricted(ENTITY_B),
    canHappen(collisionLogic(ENTITY,ENTITY_B,TYPE)).    

restricted(LOGIC) :-
    precondition(RESTRICTED,LOGIC),
    not unrestricted(RESTRICTED).
unrestricted(LOGIC) :-
    precondition(UNRESTRICTED,LOGIC),
    unrestricted(UNRESTRICTED).
%All such preconditions must be unrestricted?
unrestricted(graphicalLogic(ENTITY,ACTION)) :- 
    unrestricted(graphicalLogic(ENTITY,STATE,ACTION)).

easy(graphicalLogic(ENTITY,removed)) :-
    unrestricted(graphicalLogic(ENTITY,removed)),
    monotonicallyDecreases(ENTITY).

easy(LOGIC) :- 
    precondition(EASY,LOGIC),
    easy(EASY).

%% KNOWLEGE BASE

unrestricted(controlLogic(click)). %player can always click

