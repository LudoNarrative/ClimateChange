logic_g3(L) :- collision_logic_g3(L).

% Validity
:- collider_g3(L, _), not collision_logic_g3(L).

% blocking relations must be initialized
% "guess a default but admit overriding with explicit facts"
1{init_g3(L, blocking(C1, C2, B)) : bool_g3(B)}1 :-
  collision_logic_g3(L),
  collider_g3(L, C1),
  collider_g3(L, C2).
:- collision_logic_g3(L),
  collider_g3(L, C1),
  collider_g3(L, C2),
  not 1{init_g3(L, blocking(C1, C2, B)):bool_g3(B)}1.

% For now, collision checkability is fixed

1{init_g3(L, at(C, Loc)):loc_g3(L, Loc)}1 :-
  collision_logic_g3(L),
  collider_g3(L, C).
:- collision_logic_g3(L),
  collider_g3(L, C),
  not 1{init_g3(L, at(C, Loc)):loc_g3(L, Loc)}1.

% feedback_g3(L, at_loc(C, Loc)) :-
%   collision_logic_g3(L),
%   collider_g3(L, C),
%   loc_g3(L, Loc).

% * (Alter/Check) which entities could be said to collide with which other entities or regions of space (e.g. collision layers or flags, or hurt vs hit boxes)
%   Skip for now

% * Check if two entities or regions are overlapping or touching
q_op_g3(L, touching(C1, C2, B)) :-
  collision_logic_g3(L),
  collider_g3(L, C1),
  collider_g3(L, C2),
  bool_g3(B).

% feedback_g3(L, touching(C1, C2, B)) :-
%   collision_logic_g3(L),
%   q_op_g3(L, touching(C1, C2, B)).

q_op_g3(L, at_loc(C, Loc, B)) :-
  collision_logic_g3(L),
  collider_g3(L, C),
  loc_g3(L, Loc),
  bool_g3(B).

% * (Alter/Check) the region of space taken up by an entity (e.g. grow or shrink an entity or change its collision polygon)
%   Implicit
% * Enumerate the entities or regions overlapping or touching an entity or region
%   Implicit
% * Separate the positions of two or more entities or regions such that they touch but do not intersect
%   Phrased as "A and B block each other's movement sometimes/always"

q_op_g3(L, blocking(C1, C2, B)) :-
  collision_logic_g3(L),
  collider_g3(L, C1),
  collider_g3(L, C2),
  bool_g3(B).

% feedback_g3(L, blocking(C1, C2, B)) :-
%   collision_logic_g3(L),
%   q_op_g3(L, blocking(C1, C2, B)).

a_op_g3(L, set_blocking(C1, C2, B)) :-
  collision_logic_g3(L),
  collider_g3(L, C1),
  collider_g3(L, C2),
  bool_g3(B).

% feedback_g3(L, set_blocking(C1, C2, B)) :-
%   collision_logic_g3(L),
%   a_op_g3(L, set_blocking(C1, C2, B)).


% * Determine how far an entity could move towards another entity or region without touching or causing an overlap
%   Sort-of:
q_op_g3(L, proximity(C1, C2, Threshold, B)) :-
  collision_logic_g3(L),
  collider_g3(L, C1),
  collider_g3(L, C2),
  distance_g3(L, Threshold),
  bool_g3(B).

a_op_g3(L, move_to(C, Loc)) :-
  collision_logic_g3(L),
  collider_g3(L, C),
  loc_g3(L, Loc).

prerequisite_g3(L, move_to(C1, Loc), L, at_loc(C2, Loc, false)) :-
  collision_logic_g3(L),
  collider_g3(L, C1),
  loc_g3(L, Loc),
  collider_g3(L, C2).

% * Whenever a combination of the above checks becomes true (or remains true, or becomes false), perform some abstract operation of this or another operational logic involving the objects considered in those checks
%   Implicit in Gemini

% Add a collider of type C at Loc
a_op_g3(L, add_collider(C, Loc)) :-
  collision_logic_g3(L),
  collider_g3(L, C),
  loc_g3(L, Loc).

% Remove a particular collider of some type, implicit from context (awkward)
a_op_g3(L, remove_collider(C)) :-
  collision_logic_g3(L),
  collider_g3(L, C).
