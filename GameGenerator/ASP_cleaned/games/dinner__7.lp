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
initialize(set_static(entity(e_2_XX_),true)).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).

timer_logic(timer(t_1_XX_),scalar(2),loop).

initialize(set_value(resource(r_1_XX_),scalar(6))).
initialize(set_value(resource(r_2_XX_),scalar(8))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_1_XX_)).
precondition(le(resource(r_1_XX_),scalar(9)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease(resource(r_2_XX_),scalar(8))).
result(outcome(o_1_XX_),add(entity(e_1_XX_),scalar(1),location(middle,right))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_2_XX_)).
precondition(le(resource(r_1_XX_),scalar(9)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_2_XX_),scalar(1))).

precondition(timer_elapsed(t_1_XX_),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(o_3_XX_),decrease(resource(r_2_XX_),scalar(4))).
result(outcome(o_3_XX_),add(entity(e_1_XX_),scalar(1),location(bottom,right))).

precondition(le(resource(r_2_XX_),scalar(2)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),move_towards(entity(e_1_XX_),cursor,scalar(3))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_5_XX_)).
result(outcome(o_5_XX_),increase(resource(r_1_XX_),scalar(1))).
result(outcome(o_5_XX_),delete(entity(e_1_XX_))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_6_XX_)).
result(outcome(o_6_XX_),mode_change(narrative_gating)).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).

reading(bad,outcome(o_3_XX_)).
reading(good,resource(r_1_XX_)).
reading(good,outcome(o_5_XX_)).
reading(sharing,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(maintenance,resource(r_1_XX_)).
reading(goal(produce),resource(r_1_XX_)).
reading(produces,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(consts,relation(entity(e_1_XX_),resource(r_2_XX_))).

==========
<ul>
<li>The goal is to produce satiation</li>

<li>The player will do this by<ul>
<li>
	clicking on a [[blue|circle]]
	 at the same time as
compare(le,resource(r(1)))
</li>
<li>
	clicking on a [[red|circle]]
	 at the same time as
compare(le,resource(r(1)))
</li>
<li>
compare(le,resource(r(2)))
</li>
<li>
attempting to make a [[blue|circle]] and [[red|circle]] touch
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>	the [[red|circle]] moves towards the cursor</li>
<li>
	clicking on a [[red|circle]]
</li>
<li>
	clicking on a [[blue|circle]]
</li>
</ul></ul>