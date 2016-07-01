%% Prose version:
% Should be an easy/background task game
% Should be about sharing
% Resource r1 should represent patience
% -- supplants 'decreases with time'


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

% At most 2 control events
:- {condition(control_event(X))} 2.

% :- not unrestrictedGame.

:- not narrative_gating.
% :- not hasSharing.
:- not hasEntitySharing.
:- many(E).

:- effect(mode_change(game_loss)). % shouldn't be a way to lose
:- not slowlyDrains(r1).

%% hacky things that should maybe be generalized
:- effect(increase(X, X)).

%% no buttons except mouse
nonMouseControls
  :- condition(control_event(button(B, Action))), B != mouse_button.

:- nonMouseControls.

%% At least one entity is static
:- not static(_).


