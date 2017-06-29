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
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).

timer_logic(timer(t_1_XX_),scalar(5),loop).

initialize(set_value(resource(r_1_XX_),scalar(8))).
initialize(set_value(resource(r_2_XX_),scalar(6))).

precondition(control_event(click(entity(e_1_XX_))),outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),increase(resource(r_2_XX_),scalar(3))).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),rotates(entity(e_1_XX_),cw,scalar(30))).

precondition(timer_elapsed(t_1_XX_),outcome(o_1_XX_)).
result(outcome(o_1_XX_),add(entity(e_1_XX_),scalar(1),location(bottom,right))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(property(entity(e_1_XX_),health),scalar(4))).
result(outcome(o_2_XX_),decrease(resource(r_2_XX_),scalar(1))).

precondition(le(resource(r_2_XX_),scalar(3)),outcome(o_3_XX_)).
precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),increase(property(entity(e_2_XX_),health),scalar(8))).
result(outcome(o_3_XX_),increase(resource(r_1_XX_),scalar(4))).
result(outcome(o_3_XX_),delete(entity(e_1_XX_))).

precondition(le(resource(r_1_XX_),scalar(4)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),mode_change(narrative_gating)).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,moves(entity(e_1_XX_),forward,scalar(5))).
result(tick,decrease_over_time(property(entity(e_1_XX_),health),scalar(6))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
result(tick,decrease_over_time(resource(r_2_XX_),scalar(8))).
result(tick,moves(entity(e_2_XX_),right,scalar(3))).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),furthest)).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(consumes,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(bad,tick).
reading(good,outcome(o_3_XX_)).
reading(sharing,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(maintenance,resource(r_1_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(stakes(low),resource(r_2_XX_)).
==========
<ul>
<li>The goal is to produce satiation</li>

<li>The player will do this by<ul>
<li>
compare(le,resource(r(2)))
	 at the same time as
attempting to make a [[blue|circle]] and [[red|circle]] touch
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>
	clicking on a [[red|circle]]
</li>
<li>
	clicking on a [[blue|circle]]
</li>
</ul></ul>
