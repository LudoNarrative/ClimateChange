label(resource(r_1_XX_),composure).
label(entity(e_1_XX_),yourself).
label(entity(e_2_XX_),help).
label(entity(e_3_XX_),harm).
label(resource(r_2_XX_),r(2)).
label(resource(r_3_XX_),r(3)).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

resource(r_1_XX_).
resource(r_2_XX_).
resource(r_3_XX_).

singular(entity(e_1_XX_)).

many(entity(e_2_XX_)).
many(entity(e_3_XX_)).

initialize(set_static(entity(e_3_XX_),true)).
initialize(set_draggable(entity(e_1_XX_),true)).
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

controlLogic(draggable(entity(e_1_XX_))).

timer_logic(timer(t_1_XX_),scalar(4),loop).
timer_logic(timer(t_2_XX_),scalar(3),loop).
timer_logic(timer(patrol_entity_e_2_XX__XX__XX_),scalar(2),loop).

initialize(set_value(resource(r_1_XX_),scalar(6))).
initialize(set_value(resource(r_2_XX_),scalar(10))).
initialize(set_value(resource(r_3_XX_),scalar(7))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_1_XX_)).
precondition(le(resource(r_3_XX_),scalar(1)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease(resource(r_1_XX_),scalar(2))).
result(outcome(o_1_XX_),delete(entity(e_3_XX_))).

precondition(le(resource(r_1_XX_),scalar(0)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),mode_change(narrative_progress)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),false),outcome(o_3_XX_)).
precondition(le(resource(r_3_XX_),scalar(6)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease_over_time(resource(r_1_XX_),scalar(5))).

precondition(timer_elapsed(patrol_entity_e_2_XX__XX__XX_),outcome(o_4_XX_)).
result(outcome(o_4_XX_),decrease(resource(r_3_XX_),scalar(3))).
result(outcome(o_4_XX_),increase(resource(r_1_XX_),scalar(1))).
result(outcome(o_4_XX_),add(entity(e_3_XX_),scalar(1),location(top,center))).

precondition(timer_elapsed(t_1_XX_),outcome(o_5_XX_)).
result(outcome(o_5_XX_),add(entity(e_3_XX_),scalar(1),location(top,center))).

precondition(control_event(button(mouse,pressed)),outcome(o_6_XX_)).
precondition(le(resource(r_2_XX_),scalar(9)),outcome(o_6_XX_)).
result(outcome(o_6_XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(o_6_XX_),decrease(resource(r_3_XX_),scalar(9))).
result(outcome(o_6_XX_),add(entity(e_3_XX_),scalar(1),location(top,center))).

precondition(control_event(button(mouse,held)),outcome(o_7_XX_)).
precondition(le(resource(r_2_XX_),scalar(4)),outcome(o_7_XX_)).
result(outcome(o_7_XX_),decrease_over_time(resource(r_1_XX_),scalar(2))).

precondition(timer_elapsed(t_2_XX_),outcome(o_8_XX_)).
result(outcome(o_8_XX_),decrease(resource(r_2_XX_),scalar(3))).
result(outcome(o_8_XX_),add(entity(e_3_XX_),scalar(1),location(top,center))).

precondition(le(resource(r_3_XX_),scalar(3)),outcome(patrol_entity_e_2_XX__XX__XX_)).
result(outcome(patrol_entity_e_2_XX__XX__XX_),rotates(entity(e_2_XX_),ccw,scalar(45))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,moves(entity(e_2_XX_),forward,scalar(4))).

reading(produces,relation(location(top,center),entity(e_3_XX_))).
reading(consumes,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_3_XX_),resource(r_1_XX_))).
reading(goal(reduce),resource(r_1_XX_)).
reading(bad,resource(r_1_XX_)).
reading(bad,outcome(o_4_XX_)).
reading(good,outcome(o_7_XX_)).
reading(good,outcome(o_6_XX_)).
reading(good,outcome(o_3_XX_)).
reading(good,outcome(o_1_XX_)).
reading(good,entity(e_1_XX_)).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_3_XX_),player)).
reading(hurt,relation(entity(e_1_XX_),entity(e_3_XX_))).
reading(defend_against,entity(e_3_XX_)).
reading(survive,entity(e_3_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(consts,relation(entity(e_3_XX_),resource(r_1_XX_))).
reading(consts,relation(entity(e_3_XX_),resource(r_2_XX_))).
reading(consts,relation(entity(e_3_XX_),resource(r_3_XX_))).
reading(costs,relation(entity(e_3_XX_),resource(r_1_XX_))).
reading(costs,relation(entity(e_3_XX_),resource(r_2_XX_))).
reading(hand_eye_coordination,game).
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_helps,relation(outcome(o_7_XX_),resource(r_1_XX_))).
reading(outcome_helps,relation(outcome(o_6_XX_),resource(r_1_XX_))).
reading(outcome_helps,relation(outcome(o_3_XX_),resource(r_1_XX_))).
reading(outcome_helps,relation(outcome(o_1_XX_),resource(r_1_XX_))).
==========
<ul>
<li>The goal is to reduce composure</li>

<li>The player will do this by<ul>
<li>
	 holding the mouse button
	 at the same time as
compare(le,resource(r(2)))
</li>
<li>
	 pressing the mouse button
	 at the same time as
compare(le,resource(r(2)))
</li>
<li>
	attempting to keep a [[blue|circle]] and [[red|circle]] from touching
	 at the same time as
compare(le,resource(r(3)))
</li>
<li>
attempting to make a [[green|circle]] and [[red|circle]] touch
	 at the same time as
compare(le,resource(r(3)))
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>
	clicking-and-dragging [[red|circle]]s
</li>
<li>
	pressing the mouse button
</li>
<li>
	holding the mouse button
</li>
</ul></ul>
