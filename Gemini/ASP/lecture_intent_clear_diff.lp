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
:- not action(clear(_)).

initialize(set_value(resource(r(1)),scalar(0))).

required(hand_eye_coordination).
:- not reading(hand_eye_coordination,game).

%required(risk_reward).
%:- not reading(risk_reward,control_event(_)).

out_of_players_control(R) :- reading(R,outcome(O)),
			     not player_controls_outcome(outcome(O)).

:- not out_of_players_control(bad).

label(entity(e(1)),e1).

:- not action(mode_change(game_loss)).
:- 2 {action(mode_change(N))}.

:- not action(draw(entity(e(2)),_)).
:- not computer_controls(entity(e(2))).

% :- precondition(overlaps(_,_),O),
  % result(O,clear(_)).
% :- precondition(overlaps(_,_,_),O),
  % result(O,clear(_)).
:- not result(_,clear(_)).

lose_if_too_high :- precondition(compare(ge,amount(_),scalar(9)),O),
		   result(O,mode_change(game_loss)).
:- not lose_if_too_high.

:- not synced(resource(r(1)),amount(clear)).

allowed(frivolous(resource(r(1)))).

% make it real different

% TODO: this won't really work as is because even trivial differences will be different enough.  What I'd really prefer is "no query/action operator pair regardless of arguments" but, you know...
% :- 2{same_cause_effect(_,_)}.
% :- 3{same_init(_)}.
% :- 3{same_tick(_)}.

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

old_initialize(set_value(resource(r_1_XX_),scalar(0))).
old_initialize(set_draggable(entity(e_1_XX_),true)).
old_initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
old_initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
old_initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
old_initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
old_initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
old_initialize(set_color(entity(e_1_XX_),red)).
old_initialize(set_sprite(entity(e_1_XX_),triangle)).
old_initialize(set_sprite(entity(e_2_XX_),triangle)).
old_initialize(set_color(entity(e_2_XX_),blue)).
old_controlLogic(draggable(entity(e_1_XX_))).
old_timer_logic(timer(t_1_XX_),scalar(5),loop).
old_pool(entity(e_1_XX_),location(top,left),ordered,random).
old_pool(entity(e_1_XX_),location(top,center),ordered,random).
old_pool(entity(e_1_XX_),location(top,right),ordered,random).
old_pool(entity(e_1_XX_),location(middle,left),ordered,random).
old_pool(entity(e_1_XX_),location(middle,center),ordered,random).
old_pool(entity(e_1_XX_),location(middle,right),ordered,random).
old_pool(entity(e_1_XX_),location(bottom,left),ordered,random).
old_pool(entity(e_1_XX_),location(bottom,center),ordered,random).
old_pool(entity(e_1_XX_),location(bottom,right),ordered,random).
old_pool(entity(e_2_XX_),location(top,left),ordered,random).
old_pool(entity(e_2_XX_),location(top,center),ordered,random).
old_pool(entity(e_2_XX_),location(top,right),ordered,random).
old_pool(entity(e_2_XX_),location(middle,left),ordered,random).
old_pool(entity(e_2_XX_),location(middle,center),ordered,random).
old_pool(entity(e_2_XX_),location(middle,right),ordered,random).
old_pool(entity(e_2_XX_),location(bottom,left),ordered,random).
old_pool(entity(e_2_XX_),location(bottom,center),ordered,random).
old_pool(entity(e_2_XX_),location(bottom,right),ordered,random).
old_boundary(closed).
old_initialize(set_value(resource(r_1_XX_),scalar(0))).
old_initialize(set_value(resource(r_1_XX_),scalar(7))).
old_precondition(ge(amount(blue),scalar(9)),outcome(o_1_XX_)).
old_result(outcome(o_1_XX_),mode_change(game_loss)).
old_precondition(control_event(button(mouse,held)),outcome(o_2_XX_)).
old_result(outcome(o_2_XX_),set_value(resource(r_1_XX_),amount(clear))).
old_result(outcome(o_2_XX_),increase_over_time(property(entity(e_2_XX_),health),scalar(10))).
old_precondition(timer_elapsed(t_1_XX_),outcome(o_3_XX_)).
old_result(outcome(o_3_XX_),draw(entity(e_2_XX_),blue)).
old_result(outcome(o_3_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).
old_precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_4_XX_)).
old_result(outcome(o_4_XX_),clear(entity(e_1_XX_))).
old_result(outcome(o_4_XX_),delete(entity(e_2_XX_))).
old_precondition(overlaps(entity(e_1_XX_),entity(e_1_XX_),true),outcome(o_5_XX_)).
old_result(outcome(o_5_XX_),set_value(resource(r_1_XX_),amount(clear))).
old_result(outcome(o_5_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).
old_result(outcome(o_5_XX_),delete(entity(e_1_XX_))).
old_precondition(tick,tick).
old_result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
old_result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
old_result(tick,set_value(resource(r_1_XX_),amount(clear))).
old_result(tick,decrease_over_time(property(entity(e_1_XX_),health),scalar(1))).
old_result(tick,decrease_over_time(property(entity(e_2_XX_),health),scalar(10))).
old_result(tick,moves(entity(e_2_XX_),left,scalar(3))).
old_result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).
