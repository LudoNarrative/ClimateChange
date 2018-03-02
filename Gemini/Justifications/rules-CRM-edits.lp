%% Predicates (new)
%   good(Resource)
%   bad(Resource)
%


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
    precondition(time, Outcome),
    result(Outcome, resourceLogic(RESOURCE,decreases,AMOUNT)).
worseWithTime(RESOURCE) :- 
    bad(RESOURCE),
    onlyPrecondition(time, Outcome), %% TODO: how to specify this?
    result(Outcome, resourceLogic(RESOURCE,increases,AMOUNT)).

betterWithTime(RESOURCE) :- 
    bad(RESOURCE),
    precondition(time, Outcome),
    result(Outcome, resourceLogic(RESOURCE,decreases,AMOUNT)).
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
    
% TODO Revisit - specify in terms of outcomes?    
actionHasRiskReward(PLAYER_ACTION) :- 
    playerActionHelps(PLAYER_ACTION,RESOURCE1),
    playerActionHurts(PLAYER_ACTION,RESOURCE2).


actionNeededForMaintenance(PLAYER_ACTION,RESOURCE) :-
    playerActionHelps(PLAYER_ACTION,RESOURCE),
    worseWithTime(RESOURCE).
    

% TODO: think about physics and time relationship
timingAffects(ENTITY) :- physicsLogic(ENTITY,PHYSICS_TYPE).


timingAffects(PLAYER_ACTION) :- 
    precondition(controlLogic(PLAYER_ACTION), Outcome),
    precondition(collisionLogic(ENTITY_A,ENTITY_B,YES_NO), Outcome),
    timingAffects(ENTITY_A).

timingAffects(PLAYER_ACTION) :- 
    precondition(controlLogic(PLAYER_ACTION), Outcome),
    precondition(collisionLogic(ENTITY_A,ENTITY_B,YES_NO), Outcome),
    timingAffects(ENTITY_B).
    
timingChallenge(PLAYER_ACTION) :- 
    actionHasRiskReward(PLAYER_ACTION),
    timingAffects(PLAYER_ACTION).


%% Goal terms:
%   maintain(RESOURCE)
%   eliminate(RESOURCE)
%   achieve(Outcome)

goal(achieve(Outcome)) :-
  result(Outcome, modeLogic(game_win)).

goal(prevent(Outcome)) :-
  result(Outcome, modeLogic(game_loss)).

goal(maintain(Resource)) :-
  goal(prevent(Outcome)),
  precondition(below_0(Resource), Outcome).

%% TODO: rewrite below
goal(maintain(RESOURCE)) :- 
    precondition(below_0(RESOURCE), 
                modeLogic(game_loss)).
    
goal(eliminate,RESOURCE) :- 
    precondition(below_0(RESOURCE), 
                modeLogic(game_win)).
goal(LOGIC) :- 
    precondition(LOGIC, Outcome),
    result(Outcome, modeLogic(game_win)).
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

%% TODO: maybe some of this is useful?
canHappen(Outcome) :-
  initially(State),
  onlyPrecondition(State, Outcome).
% + recursive case
% n.b. will most likely be an approximation.

monotonicallyDecreases(ENTITY) :- 
    canHappen(graphicalLogic(ENTITY,STATE,removed)), 
    not canHappen(graphicalLogic(ENTITY,OTHER_STATE,added)), 
    possibleStates(OTHER_STATE).
 
entities(ENTITY) :- 
    canHappen(graphicalLogic(ENTITY,STATE,ACTION)).
entities(ENTITY) :-
    graphicalLogic(ENTITY,STATE).
    
% TODO: formulate "blocking" as a higher-level inference?
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

