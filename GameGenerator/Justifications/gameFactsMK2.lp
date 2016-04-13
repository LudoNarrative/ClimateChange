
physicsLogic(ball,spring).
graphicalLogic(ball,visible).
graphicalLogic(square,visible).
collisionLogic(ball,square).
controlLogic(click).


precondition(time,drain).
result(drain,decreases(confidence)).

precondition(control_event(click),gain).
precondition(collides(ball,square,true),gain).
result(gain,increases(confidence)).

precondition(control_event(click),loss).
precondition(collides(ball,square,false),loss).
result(loss,decreases(confidence)).

precondition(below(confidence,0), lose).
result(lose,game_loss).

% graphicalLogic(hand,visible).
% graphicalLogic(sand,visible).
% resourceLogic(sandAmount,count(sand)).
% physicsLogic(hand,controlLogic(cursor_movement)).
% controlLogic(click).
% controlLogic(cursor_movement).
% narrativeLogic(story_progression).

% precondition(control_event(click),removeSand).
% precondition(collides(hand,sand,true),removeSand).


% result(removeSand,select(sand,inCollision)).
% result(removeSand,delete(sand)).

% precondition(below(sandAmount),story).
% result(story,story_progression).