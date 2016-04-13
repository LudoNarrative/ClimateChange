
%% Facts
%   physicsLogic(Entity, PhysicsModel). - Entity obeys PhysicsModel as its
%     physics logic.
%   graphicalLogic(Entity, GraphicalProperty).
%   collisionLogic(Entity, Entity) - We care about collisions between the
%     two entities.
%   precondition(Action, Outcome).
%   result(Outcome, Action).
%   goal(Goal). 
%   initially(State).
% 
% Terms
% outcome names, e.g. successfulClick
% concrete actions
%   colliding(Entity, Entity, bool)
%   increases
%   clicking
% goals (??? e.g. - maintain confidence.)
%
% 


% LECTURE GAME
physicsLogic(ball,spring).
graphicalLogic(ball,visible).
graphicalLogic(square,visible).
controlLogic(click).
%values(1..5).

result(time, resourceLogic(confidence, decreases)).

precondition(controlLogic(click), successfulClick).
precondition(collisionLogic(ball,square,true), successfulClick).
result(successfulClick, resourceLogic(confidence,increases)).

precondition(controlLogic(click), unsuccessfulClick).
precondition(collisionLogic(ball,square,false), unsuccessfulClick).
result(unsuccessfulClick, resourceLogic(confidence, decreases)).

precondition(resourceLogic(confidence, below(0)), lose).
result(lose, modeLogic(game_loss)).

goal(maintain,confidence).


% graphicalLogic(hand,visible).
% graphicalLogic(sand,visible).
% physicsLogic(hand,controlLogic(cursor_movement)).
% controlLogic(click).
% controlLogic(cursor_movement).
%
% precondition(controlLogic(click), scrub).
% precondition(collisionLogic(hand,sand,true), scrub).
% result(scrub, graphicalLogic(sand,inCollision,removed)).
% 
% precondition(graphicalLogic(sand,removed), progress).
% result(progress, narrativeLogic(story_progression)).
%
% % ??? TODO
% initially(graphicalLogic(sand, visible), many).
%
