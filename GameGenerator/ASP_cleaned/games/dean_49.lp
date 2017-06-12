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

timer_logic(timer(patrol_entity_e_1_XX__XX__XX_),scalar(2),loop).
timer_logic(timer(wander_entity_e_1_XX__XX__XX_),scalar(2),loop).

initialize(set_value(resource(r_1_XX_),scalar(7))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(narrative_progress)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(1))).
result(outcome(o_2_XX_),add(entity(e_3_XX_),scalar(1),location(bottom,center))).
result(outcome(o_2_XX_),delete(entity(e_2_XX_))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(resource(r_1_XX_),scalar(4))).
result(outcome(o_3_XX_),add(entity(e_2_XX_),scalar(1),location(top,left))).
result(outcome(o_3_XX_),delete(entity(e_3_XX_))).

precondition(control_event(button(mouse,held)),outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),decrease_over_time(property(entity(e_2_XX_),health),scalar(8))).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),left,scalar(3))).

precondition(timer_elapsed(patrol_entity_e_1_XX__XX__XX_),outcome(patrol_entity_e_1_XX__XX__XX_)).
result(outcome(patrol_entity_e_1_XX__XX__XX_),rotates(entity(e_1_XX_),cw,scalar(90))).

precondition(timer_elapsed(wander_entity_e_1_XX__XX__XX_),outcome(wander_entity_e_1_XX__XX__XX_)).
result(outcome(wander_entity_e_1_XX__XX__XX_),rotate_to(entity(e_1_XX_),random_int(scalar(0),scalar(360)))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_1_XX_),forward,scalar(3))).
result(tick,moves(entity(e_2_XX_),backward,scalar(2))).
result(tick,moves(entity(e_3_XX_),backward,scalar(2))).
result(tick,decrease_over_time(property(entity(e_1_XX_),health),scalar(4))).
result(tick,decrease_over_time(property(entity(e_3_XX_),health),scalar(9))).
result(tick,increase_over_time(property(entity(e_1_XX_),health),scalar(1))).
result(tick,increase_over_time(property(entity(e_3_XX_),health),scalar(1))).
result(tick,increase_over_time(resource(r_1_XX_),scalar(3))).
result(tick,moves(entity(e_3_XX_),right,scalar(2))).
result(tick,moves(entity(e_2_XX_),right,scalar(2))).
result(tick,look_at(entity(e_3_XX_),entity(e_1_XX_),nearest)).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

reading(produces,relation(location(top,left),entity(e_2_XX_))).
reading(produces,relation(location(bottom,center),entity(e_3_XX_))).
reading(consumes,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_3_XX_),resource(r_1_XX_))).
reading(goal(reduce),resource(r_1_XX_)).
reading(bad,resource(r_1_XX_)).
reading(bad,tick).
reading(bad,outcome(o_3_XX_)).
reading(bad,outcome(o_2_XX_)).
reading(good,outcome(o_3_XX_)).
reading(good,outcome(o_2_XX_)).
reading(good,entity(e_1_XX_)).
reading(good,entity(e_3_XX_)).
reading(good,location(bottom,center)).
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
reading(help,relation(entity(e_3_XX_),player)).
reading(tradeoff,outcome(o_3_XX_)).
reading(tradeoff,outcome(o_2_XX_)).
reading(costs,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(hand_eye_coordination,game).
reading(stakes(high),property(entity(e_1_XX_),health)).
reading(stakes(high),property(entity(e_2_XX_),health)).
reading(stakes(high),property(entity(e_3_XX_),health)).
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_hurts,relation(outcome(o_2_XX_),resource(r_1_XX_))).
reading(risk,outcome(o_3_XX_)).
reading(grinding,property(entity(e_2_XX_),health)).
reading(outcome_helps,relation(outcome(o_3_XX_),resource(r_1_XX_))).
==========
<ul>
<li>The goal is to reduce composure</li>
<li>The player controls the game by<ul>
<li>
	holding the mouse button
</li>
</ul></ul>
