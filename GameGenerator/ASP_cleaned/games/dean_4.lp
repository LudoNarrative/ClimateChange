label(resource(r_1_XX_),composure).
label(resource(r(2)),tension).
label(entity(e_1_XX_),yourself).
label(entity(e_2_XX_),help).
label(entity(e_3_XX_),harm).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

resource(r_1_XX_).

singular(entity(e_1_XX_)).

many(entity(e_2_XX_)).
many(entity(e_3_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(middle,right))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,center))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_sprite(entity(e_3_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_3_XX_),green)).

timer_logic(timer(t_1_XX_),scalar(3),loop).
timer_logic(timer(t_2_XX_),scalar(4),loop).

initialize(set_value(resource(r_1_XX_),scalar(8))).

precondition(le(resource(r_1_XX_),scalar(2)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(narrative_progress)).

precondition(timer_elapsed(t_1_XX_),outcome(o_2_XX_)).
result(outcome(o_2_XX_),decrease(property(entity(e_1_XX_),health),scalar(1))).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(1))).
result(outcome(o_2_XX_),add(entity(e_3_XX_),scalar(1),location(bottom,center))).

precondition(timer_elapsed(t_2_XX_),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(property(entity(e_1_XX_),health),scalar(2))).
result(outcome(o_3_XX_),increase(resource(r_1_XX_),scalar(4))).
result(outcome(o_3_XX_),add(entity(e_2_XX_),scalar(1),location(top,left))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_4_XX_)).
result(outcome(o_4_XX_),decrease(resource(r_1_XX_),scalar(2))).
result(outcome(o_4_XX_),add(entity(e_2_XX_),scalar(1),location(bottom,left))).
result(outcome(o_4_XX_),delete(entity(e_2_XX_))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_5_XX_)).
result(outcome(o_5_XX_),increase(resource(r_1_XX_),scalar(4))).
result(outcome(o_5_XX_),add(entity(e_2_XX_),scalar(1),location(bottom,left))).
result(outcome(o_5_XX_),delete(entity(e_3_XX_))).

precondition(control_event(button(mouse,held)),outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),decrease_over_time(property(entity(e_2_XX_),health),scalar(1))).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),left,scalar(3))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_1_XX_),backward,scalar(4))).
result(tick,moves(entity(e_2_XX_),backward,scalar(3))).
result(tick,moves(entity(e_3_XX_),backward,scalar(4))).
result(tick,decrease_over_time(property(entity(e_3_XX_),health),scalar(1))).
result(tick,increase_over_time(property(entity(e_3_XX_),health),scalar(7))).
result(tick,increase_over_time(resource(r_1_XX_),scalar(2))).
result(tick,moves(entity(e_1_XX_),right,scalar(4))).
result(tick,look_at(entity(e_3_XX_),entity(e_1_XX_),random)).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),random)).
result(tick,look_at(entity(e_1_XX_),entity(e_3_XX_),random)).
result(tick,look_at(entity(e_1_XX_),entity(e_2_XX_),furthest)).

reading(good,property(entity(e_1_XX_),health)).
reading(produces,relation(location(top,left),entity(e_2_XX_))).
reading(produces,relation(location(bottom,left),entity(e_2_XX_))).
reading(produces,relation(location(bottom,center),entity(e_3_XX_))).
reading(produces,relation(entity(e_3_XX_),resource(r_1_XX_))).
reading(goal(reduce),resource(r_1_XX_)).
reading(bad,resource(r_1_XX_)).
reading(bad,tick).
reading(bad,outcome(o_5_XX_)).
reading(bad,outcome(o_3_XX_)).
reading(bad,outcome(o_2_XX_)).
reading(good,outcome(o_4_XX_)).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_2_XX_),player)).
reading(hurt,relation(entity(e_3_XX_),player)).
reading(hurt,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(hurt,relation(entity(e_1_XX_),entity(e_3_XX_))).
reading(defend_against,entity(e_2_XX_)).
reading(dodge,entity(e_3_XX_)).
reading(survive,entity(e_2_XX_)).
reading(survive,entity(e_3_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(consts,relation(entity(e_2_XX_),property(entity(e_1_XX_),health))).
reading(consts,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(costs,relation(entity(e_2_XX_),property(entity(e_1_XX_),health))).
reading(costs,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(costs,relation(entity(e_3_XX_),property(entity(e_1_XX_),health))).
reading(hand_eye_coordination,game).
reading(stakes(high),property(entity(e_1_XX_),health)).
reading(stakes(high),property(entity(e_2_XX_),health)).
reading(stakes(high),property(entity(e_3_XX_),health)).
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_hurts,relation(outcome(o_5_XX_),resource(r_1_XX_))).
reading(risk,outcome(o_5_XX_)).
reading(risk,outcome(o_4_XX_)).
reading(grinding,property(entity(e_2_XX_),health)).
reading(outcome_helps,relation(outcome(o_4_XX_),resource(r_1_XX_))).
==========
<ul>
<li>The goal is to reduce composure</li>

<li>The player will do this by<ul>
<li>
attempting to make a [[blue|circle]] and [[red|circle]] touch
</li>
</ul></li>
<li>The player will avoid<ul>
<li>
	attempting to make a [[green|circle]] and [[red|circle]] touch
</li>
</ul>
<li>The player controls the game by<ul>
<li>
	holding the mouse button
</li>
</ul></ul>
