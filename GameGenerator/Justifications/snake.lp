
entity(snake). singular(snake).
resource(property(snake, length)).
resource(score).

goal(gain(score)).

entity(wall(Direction))
  :- dir(Direction).
dir(up). dir(down). dir(left). dir(right).

initialize(set(snake, trajectory(left))).

entity(food).

%% Colliding with self or wall ends the game.
precondition(collide(snake, snake), collide_with_self).
result(collide_with_self, mode_change(game_loss)).

precondition(collide(snake, wall), collide_with_wall).
result(collide_with_wall, mode_change(game_loss)).

%% Eating makes you longer
precondition(collide(snake, food), eat).
result(eat, increase(property(snake, length), low)).
result(eat, increase(score, low)).
result(eat, delete(food)).

%% When food is absent, can add another one in any direction.
precondition(absent(food), add_food(Dir)) :- dir(Dir).
result(add_food(Dir), add(food)) :- dir(Dir).
result(add_food(Dir), dir_from(snake, Dir, food)) :- dir(Dir).

%% Move every step
precondition(tick, move(Direction)) :- dir(Direction).
precondition(set(snake, trajectory(Direction)), move(Direction))
  :- dir(Direction).
result(move(snake, Direction), moves(snake, Direction, low))
  :- dir(Direction).

%% Turn on player's cue
precondition(control_event(arrow(Direction)), turn(Direction))
  :- dir(Direction).
result(turn(Direction), set_to(snake, trajectory(Direction)))
  :- dir(Direction). 


%% New OL stuff %%

%% Increasing something's length makes it more likely to collide with itself
result_enables_condition(increase(property(X, length), Amount), collide(X, X)) 
    :- condition(collide(E1, E2)),
       result(_, increase(property(X, length), Amount)).

%% set_to causes set
result_enables_condition(set_to(Entity, Assignment), set(Entity, Assignment))
    :- condition(set(Entity, Assignment)),
       result(_, set_to(Entity, Assignment)).

%% Moving can cause collision with stuff
result_enables_condition(moves(Entity, Direction, Amount), collide(Entity, X))
    :- condition(collide(Entity, X)),
       result(_, moves(Entity, Direction, Amount)),
       can_happen(dir_from(Entity, Direction, X)).

can_happen(Result)
    :- initialize(Result).

can_happen(Result)
    :- result(_, Result).

%% Presence and absence
% delete causes absense
result_enables_condition(delete(Entity), absent(Entity))
    :- condition(absent(Entity)), result(_, delete(Entity)).
