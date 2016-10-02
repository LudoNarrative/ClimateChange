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
#const max_outcomes = 5.
#const min_end_outcomes = 1.
#const max_end_outcomes = 1.
#const max_resource_change_per = 3.
#const max_conditions_per = 3.



has_sharing :- sharing(O1, O2).
:- not has_sharing.
sharing_required :- sharing(O1,O2),
		    1 {
			    outcome_enables(O1,increase(R));
			    outcome_enables(O2,increase(R))},
		    precondition(le(R),O3),
		    result(O3,mode_change(narrative_gating)).
:- not sharing_required.

:- precondition(le(R),O3),
   result(O3,mode_change(narrative_gating)),
   2 {result(_,increase(R))}.
:- not effect(mode_change(narrative_gating)).
:- effect(mode_change(narrative_progress)).
:- effect(mode_change(game_win)).
:- effect(mode_change(game_loss)). % shouldn't be a way to lose
:- not decreasesOverTime(r1).
:- not nonMonotonic(r1).

%At least one entity is static
:- not  static(e1).


%At most 2 control events
:- {condition(control_event(X))} 2.

%
non_discrete_game :- playerInfluences(O), every_frame(O).
:- non_discrete_game.

