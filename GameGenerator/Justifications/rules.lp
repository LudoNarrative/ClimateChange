
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
    precondition(below_0(RESOURCE), modeLogic(game_loss)).

timingChallengeToMaintain(RESOURCE) :- 
    goal(maintain,RESOURCE),
    timingChallenge(RESOURCE).