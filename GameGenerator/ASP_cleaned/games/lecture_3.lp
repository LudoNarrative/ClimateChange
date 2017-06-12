label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),stress).
label(entity(e_2_XX_),e(2)).
label(entity(e_3_XX_),e(3)).
label(resource(r_2_XX_),r(2)).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).
many(entity(e_3_XX_)).

initialize(set_draggable(entity(e_1_XX_),true)).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_sprite(entity(e_3_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_3_XX_),green)).

controlLogic(draggable(entity(e_1_XX_))).

timer_logic(timer(t_1_XX_),scalar(3),loop).
timer_logic(timer(t_2_XX_),scalar(2),loop).

initialize(set_value(resource(r_1_XX_),scalar(1))).
initialize(set_value(resource(r_2_XX_),scalar(0))).

precondition(control_event(button(mouse,held)),outcome(drawn_to_cursor_entity_e_2_XX__XX__XX_)).
result(outcome(drawn_to_cursor_entity_e_2_XX__XX__XX_),decrease_over_time(resource(r_2_XX_),scalar(3))).
result(outcome(drawn_to_cursor_entity_e_2_XX__XX__XX_),look_at(entity(e_2_XX_),cursor,nearest)).
result(outcome(drawn_to_cursor_entity_e_2_XX__XX__XX_),moves(entity(e_2_XX_),forward,scalar(3))).

precondition(timer_elapsed(t_2_XX_),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease(property(entity(e_2_XX_),health),scalar(9))).
result(outcome(o_1_XX_),increase(resource(r_1_XX_),scalar(2))).
result(outcome(o_1_XX_),add(entity(e_1_XX_),scalar(1),location(middle,center))).

precondition(ge(resource(r_1_XX_),scalar(9)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),mode_change(game_loss)).

precondition(overlaps(entity(e_2_XX_),entity(e_3_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(resource(r_1_XX_),scalar(2))).
result(outcome(o_3_XX_),add(entity(e_3_XX_),scalar(1),location(middle,center))).
result(outcome(o_3_XX_),delete(entity(e_3_XX_))).

precondition(overlaps(entity(e_2_XX_),entity(e_2_XX_),false),outcome(o_4_XX_)).
precondition(ge(resource(r_2_XX_),scalar(1)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),increase_over_time(property(entity(e_2_XX_),health),scalar(9))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_5_XX_)).
result(outcome(o_5_XX_),increase(property(entity(e_2_XX_),health),scalar(3))).
result(outcome(o_5_XX_),add(entity(e_1_XX_),scalar(1),location(top,right))).
result(outcome(o_5_XX_),delete(entity(e_1_XX_))).

precondition(timer_elapsed(t_1_XX_),outcome(o_6_XX_)).
result(outcome(o_6_XX_),increase(resource(r_1_XX_),scalar(2))).
result(outcome(o_6_XX_),increase(resource(r_2_XX_),scalar(1))).
result(outcome(o_6_XX_),add(entity(e_3_XX_),scalar(1),location(bottom,right))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_2_XX_),forward,scalar(4))).
result(tick,moves(entity(e_3_XX_),forward,scalar(4))).
result(tick,moves(entity(e_3_XX_),backward,scalar(4))).
result(tick,decrease_over_time(property(entity(e_1_XX_),health),scalar(8))).
result(tick,decrease_over_time(property(entity(e_3_XX_),health),scalar(2))).
result(tick,increase_over_time(property(entity(e_1_XX_),health),scalar(4))).
result(tick,increase_over_time(property(entity(e_3_XX_),health),scalar(4))).
result(tick,increase_over_time(resource(r_1_XX_),scalar(1))).
result(tick,increase_over_time(resource(r_2_XX_),scalar(1))).
result(tick,moves(entity(e_2_XX_),right,scalar(4))).
result(tick,look_at(entity(e_3_XX_),entity(e_2_XX_),nearest)).
result(tick,look_at(entity(e_3_XX_),entity(e_1_XX_),nearest)).
result(tick,look_at(entity(e_2_XX_),entity(e_3_XX_),random)).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),random)).

reading(produces,relation(location(top,right),entity(e_1_XX_))).
reading(produces,relation(location(middle,center),entity(e_1_XX_))).
reading(produces,relation(location(middle,center),entity(e_3_XX_))).
reading(produces,relation(location(bottom,right),entity(e_3_XX_))).
reading(produces,relation(entity(e_1_XX_),property(entity(e_2_XX_),health))).
reading(produces,relation(entity(e_2_XX_),property(entity(e_2_XX_),health))).
reading(consumes,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(consumes,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_3_XX_),resource(r_1_XX_))).
reading(goal(reduce),resource(r_1_XX_)).
reading(bad,resource(r_1_XX_)).
reading(bad,tick).
reading(bad,outcome(o_6_XX_)).
reading(bad,outcome(o_1_XX_)).
reading(good,outcome(o_3_XX_)).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_1_XX_),player)).
reading(hurt,relation(entity(e_2_XX_),player)).
reading(hurt,relation(entity(e_3_XX_),player)).
reading(hurt,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(hurt,relation(entity(e_2_XX_),entity(e_3_XX_))).
reading(hurt,relation(player,player)).
reading(defend_against,entity(e_1_XX_)).
reading(defend_against,entity(e_3_XX_)).
reading(survive,entity(e_1_XX_)).
reading(survive,entity(e_3_XX_)).
reading(help,relation(entity(e_1_XX_),player)).
reading(help,relation(entity(e_2_XX_),player)).
reading(help,relation(entity(e_3_XX_),player)).
reading(help,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(help,relation(player,player)).
reading(consts,relation(entity(e_1_XX_),property(entity(e_2_XX_),health))).
reading(consts,relation(entity(e_3_XX_),resource(r_1_XX_))).
reading(costs,relation(entity(e_1_XX_),property(entity(e_2_XX_),health))).
reading(costs,relation(entity(e_3_XX_),resource(r_1_XX_))).
reading(stakes(high),resource(r_1_XX_)).
reading(stakes(high),property(entity(e_1_XX_),health)).
reading(stakes(high),property(entity(e_2_XX_),health)).
reading(stakes(high),property(entity(e_3_XX_),health)).
reading(stakes(low),resource(r_2_XX_)).
reading(outcome_helps,relation(outcome(o_3_XX_),resource(r_1_XX_))).
==========
<ul>
<li>The goal is to reduce stress</li>

<li>The player will do this by<ul>
<li>
attempting to make a [[green|circle]] and [[blue|circle]] touch
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>
	clicking-and-dragging [[red|circle]]s
</li>
<li>
	holding the mouse button
</li>
</ul></ul>
