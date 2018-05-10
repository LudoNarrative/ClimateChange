#const min_entities = 3.
#const max_entities = 3.
#const min_resources = 0.
#const max_resources = 0.
#const min_outcomes = 2.
#const max_outcomes = 6.
#const min_timers = 0.
#const max_timers = 1.

#const min_end_outcomes = 0.
#const max_end_outcomes = 0.
#const max_resource_change_per = 0.
#const max_conditions_per = 4.

label(entity(e(1)),emma).
label(entity(e(2)),audience).
label(entity(e(3)),objection).
% label(entity(E),dean) :-
  % entity(E),
  % computer_controls(E).

% :- not player_controls(entity(e(1))).

% - arranging or herding
% - "be convincing"
% - finding a path
% - !!eliminate objections!! 
%   - audience creates objections, knock out objections to proceed

% :- reading(bad,_).
% :- many(entity(e(1))).
% :- not many(entity(e(3))).
% :- not player_controls(entity(e(1))).
% Some way that E2 makes a third thing
:- not reading(produces, relation(entity(e(2)), entity(e(3)))).
:- not reading(consumes, relation(entity(e(1)), entity(e(3)))).

% Give special permission to spawn entities at e(2)
entity_spawn_ok_loc(entity(e(2))).

% Give alternative orderings for e2 vs e3 and e1 vs e3 for produce/consume reading
{ reading(consumes,relation(Entity1,Entity2)) } :-
    precondition(overlaps(Entity1,Entity2,true),Outcome),
    result(Outcome,delete(Entity2)).
{ reading(consumes,relation(Entity1,Entity2)) } :-
   precondition(overlaps(Entity1,Entity2,true),Outcome),
   result(Outcome,modify(decrease,property(Entity2,health))).
{ reading(consumes,relation(Entity1,Entity2)) } :-
   precondition(overlaps(Entity2,Entity1,true),Outcome),
   result(Outcome,modify(decrease,property(Entity2,health))).
