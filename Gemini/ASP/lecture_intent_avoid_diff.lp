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



required(hand_eye_coordination).
:- not reading(hand_eye_coordination,game).

required(risk_reward).
:- not reading(risk_reward,control_event(_)).


label(resource(r(1)),concentration,write) :- reading(good,resource(r(1))).
:- not reading(good,resource(r(1))).



label(entity(e(1)),e1).

required(maintenance).
:- not reading(maintenance,resource(r(1))).

:- not action(mode_change(game_loss)).
:- 2 {action(mode_change(N))}.

attract_mode :- precondition(overlaps(E1,E2,true),O),
						reading(bad,O).	
						
:- not attract_mode.

:- precondition(control_event(button(mouse,held)),outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_)).
:- precondition(control_event(button(mouse,held)),outcome(repeled_from_cursor_entity_e_2_XX__XX__XX_)).
:- result(_, set_value(_,amount(clear))).
:- result(tick,decrease_over_time(resource(r_1_XX_),_)).

:- precondition(ge(amount(clear),_),_).
:- precondition(le(amount(clear),_),_).
:- condition(ge(amount(clear),_)).
:- condition(le(amount(clear),_)).
:- precondition(ge(amount(clear),_,_),_).
:- precondition(le(amount(clear),_,_),_).

:- 2{same_cause_effect(_,_)}.
:- 3{same_init(_)}.
:- 3{same_tick(_)}.

same_cause_effect(C,E) :-
  precondition(O1, C),
  result(O1, E),
  O1 != tick,
  old_precondition(OOld, C),
  old_result(OOld, C).

same_tick(E) :-
  result(tick, E),
  old_result(tick, E).

same_init(I) :-
  initialize(I),
  old_initialize(I).

old_initialize(add(entity(e_1_XX_),scalar(1),location(top,left))).
old_initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
old_initialize(add(entity(e_1_XX_),scalar(1),location(top,right))).
old_initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
old_initialize(add(entity(e_2_XX_),scalar(1),location(middle,center))).
old_initialize(set_color(entity(e_1_XX_),red)).
old_initialize(set_sprite(entity(e_1_XX_),triangle)).
old_initialize(set_sprite(entity(e_2_XX_),triangle)).
old_initialize(set_color(entity(e_2_XX_),blue)).

old_timer_logic(timer(t_1_XX_),scalar(7),loop).

old_pool(entity(e_1_XX_),location(top,left),random,ordered).
old_pool(entity(e_1_XX_),location(top,center),random,ordered).
old_pool(entity(e_1_XX_),location(top,right),random,ordered).
old_pool(entity(e_1_XX_),location(middle,left),random,ordered).
old_pool(entity(e_1_XX_),location(middle,center),random,ordered).
old_pool(entity(e_1_XX_),location(middle,right),random,ordered).
old_pool(entity(e_1_XX_),location(bottom,left),random,ordered).
old_pool(entity(e_1_XX_),location(bottom,center),random,ordered).
old_pool(entity(e_1_XX_),location(bottom,right),random,ordered).
old_pool(entity(e_2_XX_),location(top,left),random,ordered).
old_pool(entity(e_2_XX_),location(top,center),random,ordered).
old_pool(entity(e_2_XX_),location(top,right),random,ordered).
old_pool(entity(e_2_XX_),location(middle,left),random,ordered).
old_pool(entity(e_2_XX_),location(middle,center),random,ordered).
old_pool(entity(e_2_XX_),location(middle,right),random,ordered).
old_pool(entity(e_2_XX_),location(bottom,left),random,ordered).
old_pool(entity(e_2_XX_),location(bottom,center),random,ordered).
old_pool(entity(e_2_XX_),location(bottom,right),random,ordered).

old_boundary(closed).

old_initialize(set_value(resource(r_1_XX_),scalar(10))).

old_precondition(control_event(button(mouse,pressed)),outcome(o_1_XX_)).
old_result(outcome(o_1_XX_),decrease(property(entity(e_2_XX_),health),scalar(1))).
old_result(outcome(o_1_XX_),increase(property(entity(e_2_XX_),health),scalar(5))).

old_precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_2_XX_)).
old_result(outcome(o_2_XX_),mode_change(game_loss)).

old_precondition(control_event(button(mouse,held)),outcome(o_3_XX_)).
old_precondition(ge(amount(clear),resource(r_1_XX_)),outcome(o_3_XX_)).
old_result(outcome(o_3_XX_),decrease_over_time(property(entity(e_2_XX_),health),scalar(7))).
old_result(outcome(o_3_XX_),increase_over_time(property(entity(e_2_XX_),health),scalar(2))).
old_result(outcome(o_3_XX_),increase_over_time(resource(r_1_XX_),scalar(24))).

old_precondition(timer_elapsed(t_1_XX_),outcome(o_4_XX_)).
old_result(outcome(o_4_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).

old_precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_5_XX_)).
old_result(outcome(o_5_XX_),decrease(resource(r_1_XX_),scalar(1))).
old_result(outcome(o_5_XX_),delete(entity(e_2_XX_))).

old_precondition(control_event(button(mouse,held)),outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_)).
old_result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),decrease_over_time(resource(r_1_XX_),scalar(1))).
old_result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
old_result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),backward,scalar(7))).

old_precondition(tick,tick).
old_result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
old_result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
old_result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
old_result(tick,moves(entity(e_2_XX_),left,scalar(3))).
old_result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).
