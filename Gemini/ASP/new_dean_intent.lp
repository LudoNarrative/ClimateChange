#const min_entities = 1.
#const max_entities = 2.
#const min_resources = 2.
#const max_resources = 2.
#const min_outcomes = 2.
#const max_outcomes = 6.
#const min_timers = 0.
#const max_timers = 2.

#const min_end_outcomes = 0.
#const max_end_outcomes = 0.
#const max_resource_change_per = 1.
#const max_conditions_per = 3.

label(resource(r(1)),tension,read_only).
label(resource(r(2)),power,write).
% label(entity(e(1)),emma).
% label(entity(E),dean) :-
  % entity(E),
  % computer_controls(E).

:- not reading(difficulty, resource(r(1))).
:- not result(_, modify(increase,resource(r(2)))).
:- not result(_, modify(decrease,resource(r(2)))).

% :- not player_controls(entity(e(1))).

% a priori assert that there is a goal to produce r2.
% this is implied by the wrapping game (story, etc),
% since it will make options available or unavailable
% (soft win/lose).
reading(goal(produce),resource(r(2))).
% This should imply that r2 is good
% :- not reading(good,resource(r(2))).
