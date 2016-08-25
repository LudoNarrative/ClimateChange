#const min_entities = 2.
#const max_entities = 2.
#const min_resources = 1.
#const max_resources = 1.
#const min_outcomes = 0.
#const max_outcomes = 5.

#const min_end_outcomes = 1.
#const max_end_outcomes = 1.
#const max_resource_change_per = 2.
#const max_conditions_per = 2.

:- not good(r1).
:- not worseWithTime(r1).
:- not nonMonotonic(r1).
:- effect(mode_change(game_win)).
:- not effect(mode_change(game_loss)).
:- result(O,mode_change(game_loss)), not resourceAffects(r1,O).
% % :- not exists_counterforce(r1).
riskReward :- actionHasRiskReward(ControlEvent).
:- not riskReward.

% entitiesDoSomething :- precondition(overlaps(E1,E2,POL),O).
% :- not entitiesDoSomething.
:- hinders(O,O2), result(O2,mode_change(game_loss)), easy(O).
