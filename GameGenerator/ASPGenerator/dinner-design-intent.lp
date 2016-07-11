%% Prose version:
% Should be an easy/background task game
% Should be an action that corresponds to sharing, which increases camaraderie
% Resource r1 should represent camaraderie
% Camaraderie decreases with time


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


% There is an event that represents sharing and the player influences it
% playerSharing(O) :- playerInfluences(O), representsSharing(O). 

% Sharing should increase a camaraderie resource.
% sharingAndCamaraderie :-
% playerSharing(O), representsCamaraderie(C), increases(O, C).

% representsCamaraderie(C) :- resource(C).

% :- not sharingAndCamaraderie.

has_sharing :- sharing(_, _).
:- not has_sharing.

:- not narrative_gating.

:- effect(mode_change(game_loss)). % shouldn't be a way to lose
:- not slowlyDrains(r1).

%% hacky things that should maybe be generalized
:- effect(increase(X, X)).


%% At least one entity is static
:- not static(_).


% At most 2 control events
% :- {condition(control_event(X))} 2.
% :- not unrestrictedGame.
