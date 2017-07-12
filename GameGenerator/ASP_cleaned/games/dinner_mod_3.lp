label(entity(e_1_XX_),food).
label(entity(e_2_XX_),friend).
label(resource(r_1_XX_),satiation,write).
label(resource(r_2_XX_),r(2),private).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
initialize(set_draggable(entity(e_1_XX_),true)).
initialize(set_draggable(entity(e_2_XX_),true)).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).

controlLogic(draggable(entity(e_1_XX_))).
controlLogic(draggable(entity(e_2_XX_))).

initialize(set_value(resource(r_1_XX_),scalar(6))).
initialize(set_value(resource(r_2_XX_),scalar(1))).

precondition(le(resource(r_1_XX_),scalar(0)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(narrative_gating)).

precondition(overlaps(entity(e_2_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase_over_time(property(entity(e_1_XX_),health),scalar(10))).
result(outcome(o_2_XX_),decrease_over_time(resource(r_1_XX_),scalar(1))).
result(outcome(o_2_XX_),decrease_over_time(resource(r_2_XX_),scalar(3))).

precondition(control_event(button(mouse,pressed)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(o_3_XX_),decrease(resource(r_2_XX_),scalar(8))).

precondition(le(resource(r_2_XX_),scalar(10)),outcome(o_4_XX_)).
precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_4_XX_)).
result(outcome(o_4_XX_),increase(resource(r_1_XX_),scalar(4))).
result(outcome(o_4_XX_),add(entity(e_1_XX_),scalar(1),location(middle,center))).
result(outcome(o_4_XX_),delete(entity(e_1_XX_))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(bad,tick).
reading(bad,outcome(o_3_XX_)).
reading(bad,outcome(o_2_XX_)).
reading(good,outcome(o_4_XX_)).
reading(good,entity(e_2_XX_)).
reading(sharing,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(maintenance,resource(r_1_XX_)).
reading(grinding,resource(r_2_XX_)).
==========
<ul>
<li>games/dinner_mod_3.lp</li>
<li>The goal is to produce satiation</li>
<li>The player controls the game by<ul>
<li>
	clicking-and-dragging [[red|circle]]s
</li>
<li>
	clicking-and-dragging [[blue|circle]]s
</li>
<li>
	pressing the mouse button
</li>
</ul></ul>
