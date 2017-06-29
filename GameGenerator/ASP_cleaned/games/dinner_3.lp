label(resource(r_1_XX_),satiation).
label(entity(e_1_XX_),food).
label(entity(e_2_XX_),friend).
label(resource(r_2_XX_),r(2)).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(set_draggable(entity(e_1_XX_),true)).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).

controlLogic(draggable(entity(e_1_XX_))).

initialize(set_value(resource(r_1_XX_),scalar(3))).
initialize(set_value(resource(r_2_XX_),scalar(4))).

precondition(control_event(click(entity(e_2_XX_))),outcome(click_to_spin_entity_e_2_XX__XX__XX_)).
result(outcome(click_to_spin_entity_e_2_XX__XX__XX_),rotates(entity(e_2_XX_),ccw,scalar(45))).

precondition(ge(resource(r_2_XX_),scalar(6)),outcome(o_1_XX_)).
precondition(overlaps(entity(e_1_XX_),entity(e_1_XX_),true),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase(resource(r_1_XX_),scalar(1))).
result(outcome(o_1_XX_),add(entity(e_1_XX_),scalar(1),location(bottom,right))).
result(outcome(o_1_XX_),delete(entity(e_1_XX_))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(property(entity(e_1_XX_),health),scalar(6))).
result(outcome(o_2_XX_),decrease(resource(r_2_XX_),scalar(9))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),increase(property(entity(e_2_XX_),health),scalar(20))).
result(outcome(o_3_XX_),decrease(resource(r_1_XX_),scalar(24))).
result(outcome(o_3_XX_),delete(entity(e_1_XX_))).

precondition(ge(resource(r_1_XX_),scalar(36)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),mode_change(narrative_gating)).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,moves(entity(e_2_XX_),forward,scalar(3))).
result(tick,decrease_over_time(property(entity(e_1_XX_),health),scalar(1))).
result(tick,increase_over_time(resource(r_1_XX_),scalar(1))).
result(tick,increase_over_time(resource(r_2_XX_),scalar(1))).

reading(good,property(entity(e_2_XX_),health)).
reading(consumes,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(goal(reduce),resource(r_1_XX_)).
reading(bad,resource(r_1_XX_)).
reading(bad,tick).
reading(bad,outcome(o_1_XX_)).
reading(good,outcome(o_3_XX_)).
reading(sharing,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(maintenance,resource(r_1_XX_)).
reading(stakes(low),resource(r_2_XX_)).
==========
<ul>
<li>The goal is to reduce satiation</li>

<li>The player will do this by<ul>
<li>
attempting to make a [[blue|circle]] and [[red|circle]] touch
</li>
</ul></li>
<li>The player will avoid<ul>
<li>
compare(ge,resource(r(2)))
	 at the same time as
	attempting to make a [[red|circle]] and [[red|circle]] touch
</li>
</ul>
<li>The player controls the game by<ul>
<li>
	clicking-and-dragging [[red|circle]]s
</li>
<li>
	clicking on a [[red|circle]]
</li>
<li>
	clicking on a [[blue|circle]]
</li>
</ul></ul>
