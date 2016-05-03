#const min_entities = 2.
#const max_entities = 2.
#const min_resources = 1.
#const max_resources = 1.
#const min_outcomes = 3.
#const max_outcomes = 5.

%%% Want to say:
% 
% Exists O1, Entity, Amount.
% 
% Forall Direction,
% 
% precondition(O1, control_event(arrow(Direction), pressed)),
% precondition(O1, vacant(cell_to(Direction, Entity))).
% result(O1, moves(Entity, Direction, Amount)).
% 
% movement(discrete).

%% Maybe as high-level predicates:
%% "Arrow keys do things"
% control(arrow_keys).
%% "Things that move move in the same amount every time"
% movement(discrete).
%% "Position is communicated by a map of discrete tiles that
%%  can be adjacent to one another."
% map(small_tiles).

