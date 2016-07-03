#const min_entities = 2.
#const max_entities = 2.
#const min_resources = 1.
#const max_resources = 2.
#const min_outcomes = 0.
#const max_outcomes = 7.

#const min_end_outcomes = 1.
#const max_end_outcomes = 1.
#const max_resource_change_per = 2.
#const max_conditions_per = 2.

:- not good(r1).
:- not worseWithTime(r1).
:- not nonMonotonic(r1).
:- effect(mode_change(game_win)).
:- not effect(mode_change(game_loss)).

% :- not exists_counterforce(r1).

%:- not condition(tick).

%:- not timingChallengeGoal.

% :- physicsLogic(e1,mapping(control_event(left_arrow,pressed),east,low)).

% % Something something cultural knowledge about confidence
% face communicates confidence


