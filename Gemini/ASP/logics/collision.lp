logic(L) :- collision_logic(L).

% Validity
:- collider(L, _), not collision_logic(L).

% blocking relations must be initialized
% "guess a default but admit overriding with explicit facts"
1{init(L, blocking(C1, C2, B)) : bool(B)}1 :-
  collision_logic(L),
  collider(C1),
  collider(C2).
:- collision_logic(L),
  collider(C1),
  collider(C2),
  not 1{init(L, blocking(C1, C2, B)):bool(B)}1.

% For now, collision checkability is fixed

% * (Alter/Check) which entities could be said to collide with which other entities or regions of space (e.g. collision layers or flags, or hurt vs hit boxes)
%   Skip for now

% * Check if two entities or regions are overlapping or touching
q_op(L, touching(C1, C2, B)) :-
  collision_logic(L),
  collider(L, C1),
  collider(L, C2),
  bool(B).

{feedback(L, touching(C1, C2, B), LocOrGlob) :
  collision_logic(L),
  feedback_site(LocOrGlob),
  q_op(L, touching(C1, C2, B))}.

% * (Alter/Check) the region of space taken up by an entity (e.g. grow or shrink an entity or change its collision polygon)
%   Implicit
% * Enumerate the entities or regions overlapping or touching an entity or region
%   Implicit
% * Separate the positions of two or more entities or regions such that they touch but do not intersect
%   Phrased as "A and B block each other's movement sometimes/always"

q_op(L, blocking(C1, C2, B)) :-
  collision_logic(L),
  collider(L, C1),
  collider(L, C2),
  bool(B).

{feedback(L, blocking(C1, C2, B), local) :
  collision_logic(L),
  q_op(L, blocking(C1, C2, B))}.

a_op(L, set_blocking(C1, C2, B)) :-
  collision_logic(L),
  collider(L, C1),
  collider(L, C2),
  bool(B).

{feedback(L, set_blocking(C1, C2, B), local) :
  collision_logic(L),
  a_op(L, set_blocking(C1, C2, B))}.


% * Determine how far an entity could move towards another entity or region without touching or causing an overlap
%   Sort-of:
q_op(L, proximity(C1, C2, Threshold, B)) :-
  collision_logic(L),
  collider(L, C1),
  collider(L, C2),
  distance(Threshold),
  bool(B).

% * Whenever a combination of the above checks becomes true (or remains true, or becomes false), perform some abstract operation of this or another operational logic involving the objects considered in those checks
%   Implicit in Gemini
