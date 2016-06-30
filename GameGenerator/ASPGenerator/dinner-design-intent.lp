#const min_entities = 1.
#const max_entities = 3.
#const min_resources = 1.
#const max_resources = 1.
#const min_outcomes = 0.
#const max_outcomes = 3.
#const min_end_outcomes = 1.
#const max_end_outcomes = 1.
#const max_resource_change_per = 2.
#const max_conditions_per = 2.


%% Prose version:
% Should be an easy/background task game
% Should be about sharing
% Resource r1 should represent patience
% -- supplants 'decreases with time'

% Should gate the narrative, i.e. mode_change(narrative_progress) should exist.

% :- not unrestrictedGame.

:- not narrative_gating.
% :- not hasSharing.

% XXX why is this inconsistent?
:- not effect(delete(e1)).

% :- effect(mode_change(game_loss)). % shouldn't be a way to lose
% :- not result(tick, decrease(r1, low)).
% :- not effect(increase(r1, _)).

