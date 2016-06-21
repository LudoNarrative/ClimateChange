#const min_entities = 1.
#const max_entities = 4.
#const min_resources = 1.
#const max_resources = 3.
#const min_outcomes = 1.
#const max_outcomes = 3.
#const min_end_outcomes = 1.
#const max_end_outcomes = 2.
#const max_resource_change_per = 2.
#const max_conditions_per = 2.


%% Prose version:
% Should be an easy/background task game
% Should be about sharing

% Should gate the narrative, i.e. mode_change(narrative_progress) should exist.

% :- not unrestrictedGame.
:- not narrative_gating.
:- not hasSharing.
% :- not result(o1, decrease(r1, low)).
% :- not consumedBy(r1, tick).
% :- not result(tick, decrease(r1, low)).
