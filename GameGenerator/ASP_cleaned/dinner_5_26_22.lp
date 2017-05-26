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

timer_logic(timer(pingpong_entity_e_1_XX__XX__XX_),scalar(2),loop).

initialize(set_value(resource(r_1_XX_),scalar(9))).
initialize(set_value(resource(r_2_XX_),scalar(10))).

precondition(control_event(button(mouse,pressed)),outcome(o_1_XX_)).
precondition(le(resource(r_2_XX_),scalar(1)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),add(entity(e_1_XX_),scalar(1),location(bottom,left))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),mode_change(narrative_gating)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_3_XX_)).
precondition(le(resource(r_2_XX_),scalar(6)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),increase(resource(r_1_XX_),scalar(1))).
result(outcome(o_3_XX_),increase(resource(r_2_XX_),scalar(1))).
result(outcome(o_3_XX_),delete(entity(e_1_XX_))).

precondition(control_event(button(mouse,held)),outcome(o_4_XX_)).
precondition(ge(resource(r_1_XX_),scalar(3)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),move_towards(entity(e_1_XX_),entity(e_1_XX_),scalar(2))).

precondition(timer_elapsed(pingpong_entity_e_1_XX__XX__XX_),outcome(pingpong_entity_e_1_XX__XX__XX_)).
result(outcome(pingpong_entity_e_1_XX__XX__XX_),rotates(entity(e_1_XX_),cw,scalar(180))).
result(outcome(pingpong_entity_e_1_XX__XX__XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(pingpong_entity_e_1_XX__XX__XX_),decrease(resource(r_2_XX_),scalar(10))).

precondition(tick,tick).
result(tick,moves(entity(e_1_XX_),forward,scalar(2))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).

reading(bad,outcome(pingpong_entity_e_1_XX__XX__XX_)).
reading(good,resource(r_1_XX_)).
reading(good,outcome(o_3_XX_)).
reading(sharing,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(maintenance,resource(r_1_XX_)).
reading(goal(produce),resource(r_1_XX_)).
reading(produces,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(produces,relation(entity(e_2_XX_),resource(r_2_XX_))).
reading(consumes,relation(entity(e_2_XX_),entity(e_1_XX_))).

==========
<ul>
<li>The goal is to produce satiation</li>

<li>The player will do this by<ul>
<li>
attempting to make a [[blue|circle]] and [[red|circle]] touch
	 at the same time as
compare(le,resource(r(2)))
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>
	pressing the mouse button
</li>
<li>
	holding the mouse button
</li>
</ul></ul>