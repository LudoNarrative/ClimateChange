#const min_entities = 1.
#const max_entities = 2.
#const min_resources = 1.
#const max_resources = 1.
#const min_outcomes = 2.
#const max_outcomes = 8.
#const min_timers = 0.
#const max_timers = 2.

#const min_end_outcomes = 1.
#const max_end_outcomes = 1.
#const max_resource_change_per = 2.
#const max_conditions_per = 2.

palette(blue).

:- not player_controls(entity(e(1))).
:- not action(clear(entity(e(1)))).

initialize(set_value(resource(r(1)),scalar(0))).

required(hand_eye_coordination).
:- not reading(hand_eye_coordination,game).

required(risk_reward).
:- not reading(risk_reward,control_event(_)).



label(entity(e(1)),e1).

:- not action(mode_change(game_loss)).
:- 2 {action(mode_change(N))}.

:- not action(draw(entity(e(2)),_)).
:- not computer_controls(entity(e(2))).

lose_if_too_high :- precondition(compare(ge,amount(_),scalar(9)),O),
		   result(O,mode_change(game_loss)).
:- not lose_if_too_high.

:- not synced(resource(r(1)),amount(blue)).

allowed(frivolous(resource(r(1)))).
