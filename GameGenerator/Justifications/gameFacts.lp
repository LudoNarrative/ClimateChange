
% LECTURE GAME
% physicsLogic(ball,spring).
% graphicalLogic(ball,visible).
% graphicalLogic(square,visible).
% collisionLogic(ball,square,true).
% collisionLogic(ball,square,false).
% controlLogic(click).
% %values(1..5).

% precondition(time,resourceLogic(confidence,decreases,a)).

% precondition(controlLogic(click),resourceLogic(confidence,increases,b)).
% precondition(collisionLogic(ball,square,true),resourceLogic(confidence,increases,b)).

% precondition(controlLogic(click),resourceLogic(confidence,decreases,c)).
% precondition(collisionLogic(ball,square,false),resourceLogic(confidence,decreases,c)).

% precondition(below_0(confidence), modeLogic(game_loss)).

% goal(maintain,confidence).


graphicalLogic(hand,visible).
graphicalLogic(sand,visible).
physicsLogic(hand,controlLogic(cursor_movement)).
controlLogic(click).
controlLogic(cursor_movement).
precondition(controlLogic(click),graphicalLogic(sand,inCollision,removed)).
precondition(collisionLogic(hand,sand,true),graphicalLogic(sand,inCollision,removed)).

precondition(graphicalLogic(sand,removed),narrativeLogic(story_progression)).