#const min_entities = 3.
#const max_entities = 3.
#const min_resources = 1.
#const max_resources = 1.
#const min_outcomes = 2.
#const max_outcomes = 6.
#const min_timers = 0.
#const max_timers = 1.

#const min_end_outcomes = 0.
#const max_end_outcomes = 0.
#const max_resource_change_per = 1.
#const max_conditions_per = 4.

label(entity(e(1)),emma).
label(entity(e(2)),audience).
label(entity(e(3)),objection).
label(resource(r(1)),confidence,write).
:- not resource(_).
% label(entity(E),dean) :-
  % entity(E),
  % computer_controls(E).

% SUSPECT:
required(maintenance).

% - arranging or herding
% - "be convincing"
% - finding a path
% - !!eliminate objections!! 
%   - audience creates objections, knock out objections to proceed

% :- not reading(good,resource(r(1))).
:- many(entity(e(1))).
% :- not many(entity(e(3))).
:- not player_controls(entity(e(1))).
:- player_controls(entity(e(2))).
:- player_controls(entity(e(3))).
:- outcome(O),
  result(O,add(Entity2,_,_)),
  player_controls_outcome(O).
:- outcome(O),
  result(O,add(Entity3,_,_)),
  player_controls_outcome(O).

% Some way that E2 makes a third thing
:- not reading(produces, relation(entity(e(2)), entity(e(3)))).
:- not reading(consumes, relation(entity(e(1)), entity(e(3)))).

% Give special permission to spawn entities at e(2)
entity_spawn_ok_loc(entity(e(2))).

:- frivolous(resource(r(1))).

% Give alternative orderings for e2 vs e3 and e1 vs e3 for produce/consume reading
{ reading(consumes,relation(Entity1,Entity2)) } :-
    precondition(overlaps(Entity1,Entity2,true),Outcome),
    result(Outcome,delete(Entity2)).

:- result(_,modify(_,property(_,health))).
:- outcome(outcome(orbit_the_cursor(_))).
:- controlScheme(_,orbit_the_cursor).
:- outcome(O),
  precondition(control_event(click(entity(e(2)))),O),
  result(O,modify(decrease,resource(r(2)))).

:- result(O,delete(entity(e(3)))),
  precondition(le(resource(r(1)),_),O).

% :- not reading(good,resource(r(1))).

:- precondition(control_event(_),O),
  result(O,modify(decrease,resource(r(1)))).

:- precondition(control_event(_),O),
  result(O,modify(increase,resource(r(1)))).
