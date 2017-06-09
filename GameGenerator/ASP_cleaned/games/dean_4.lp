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
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,center))).
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
timer_logic(timer(t_2_XX_),scalar(4),loop).

initialize(set_value(resource(r_1_XX_),scalar(7))).
initialize(set_value(resource(r_2_XX_),scalar(4))).
initialize(set_value(resource(r_3_XX_),scalar(0))).

precondition(control_event(button(mouse,pressed)),outcome(o_1_XX_)).
precondition(overlaps(entity(e_2_XX_),entity(e_2_XX_),false),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase(resource(r_1_XX_),scalar(2))).
result(outcome(o_1_XX_),add(entity(e_3_XX_),scalar(1),location(bottom,left))).

precondition(timer_elapsed(t_2_XX_),outcome(o_2_XX_)).
result(outcome(o_2_XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(o_2_XX_),increase(resource(r_2_XX_),scalar(2))).
result(outcome(o_2_XX_),add(entity(e_3_XX_),scalar(1),location(top,left))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_3_XX_)).
precondition(ge(resource(r_3_XX_),scalar(7)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),add(entity(e_3_XX_),scalar(1),location(middle,right))).
result(outcome(o_3_XX_),delete(entity(e_3_XX_))).

precondition(control_event(button(mouse,pressed)),outcome(o_4_XX_)).
precondition(ge(resource(r_2_XX_),scalar(9)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),increase(resource(r_3_XX_),scalar(2))).
result(outcome(o_4_XX_),add(entity(e_3_XX_),scalar(1),location(bottom,left))).

precondition(timer_elapsed(t_1_XX_),outcome(o_5_XX_)).
result(outcome(o_5_XX_),apply_impulse(entity(e_2_XX_),direction(towards,entity(e_2_XX_)),scalar(4))).
result(outcome(o_5_XX_),increase(resource(r_2_XX_),scalar(1))).
result(outcome(o_5_XX_),add(entity(e_3_XX_),scalar(1),location(middle,center))).

precondition(overlaps(entity(e_2_XX_),entity(e_2_XX_),true),outcome(o_6_XX_)).
precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_6_XX_)).
result(outcome(o_6_XX_),mode_change(narrative_gating)).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,move(entity(e_2_XX_),look_at(entity(e_2_XX_),entity(e_3_XX_)))).
result(tick,move_away(entity(e_2_XX_),entity(e_3_XX_),scalar(4))).
result(tick,moves(entity(e_2_XX_),left,scalar(4))).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(bad,outcome(o_2_XX_)).
reading(good,outcome(o_1_XX_)).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_3_XX_),player)).
reading(hurt,relation(entity(e_1_XX_),entity(e_3_XX_))).
reading(defend_against,entity(e_3_XX_)).
reading(survive,entity(e_3_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(stakes(low),resource(r_1_XX_)).
reading(stakes(low),resource(r_2_XX_)).
reading(stakes(low),resource(r_3_XX_)).
==========
<ul>
<li>The goal is to produce composure</li>

<li>The player will do this by<ul>
<li>
	 pressing the mouse button
	 at the same time as
	attempting to keep a [[blue|circle]] and [[blue|circle]] from touching
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>
	clicking-and-dragging [[red|circle]]s
</li>
<li>
	pressing the mouse button
</li>
</ul></ul>
