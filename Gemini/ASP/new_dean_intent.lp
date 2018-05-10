#const min_entities = 2.
#const max_entities = 2.
#const min_resources = 2.
#const max_resources = 2.
#const min_outcomes = 2.
#const max_outcomes = 6.
#const min_timers = 0.
#const max_timers = 1.

#const min_end_outcomes = 0.
#const max_end_outcomes = 0.
#const max_resource_change_per = 1.
#const max_conditions_per = 4.

label(resource(r(1)),tension,read_only).
label(resource(r(2)),power,write).
% label(entity(e(1)),emma).
% label(entity(E),dean) :-
  % entity(E),
  % computer_controls(E).

goes_up(R) :-
  result(_,modify(increase,R)).
goes_up(R) :-
  result(_,modify(increase,R),_).
goes_down(R) :-
  result(_,modify(decrease,R)).
goes_down(R) :-
  result(_,modify(decrease,R),_).

:- not reading(difficulty, resource(r(1))).
:- not goes_down(resource(r(2))).
:- not goes_up(resource(r(2))).
:- goes_down(property(_,health)).
:- goes_up(property(_,health)).

:- many(entity(e(1))).
% :- many(entity(e(2))).

:- outcome(orbit_the_cursor(_)).
:- controlScheme(_,orbit_the_cursor).

% :- not player_controls(entity(e(1))).

% a priori assert that there is a goal to produce r2.
% this is implied by the wrapping game (story, etc),
% since it will make options available or unavailable
% (soft win/lose).
reading(goal(produce),resource(r(2))).
% This should imply that r2 is good
:- not reading(good,resource(r(2))).
