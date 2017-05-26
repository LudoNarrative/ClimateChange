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

initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).

initialize(set_value(resource(r_1_XX_),scalar(2))).
initialize(set_value(resource(r_2_XX_),scalar(7))).

precondition(overlaps(entity(e_2_XX_),entity(e_2_XX_),false),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase_over_time(resource(r_2_XX_),scalar(2))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(2))).
result(outcome(o_2_XX_),delete(entity(e_1_XX_))).

precondition(overlaps(entity(e_2_XX_),entity(e_2_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease_over_time(resource(r_2_XX_),scalar(2))).

precondition(control_event(button(mouse,pressed)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),add(entity(e_1_XX_),scalar(1),location(middle,center))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),mode_change(narrative_gating)).

precondition(control_event(button(mouse,held)),outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),move_away(entity(e_1_XX_),cursor,scalar(3))).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),move_towards(entity(e_2_XX_),entity(e_2_XX_),scalar(4))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).

reading(bad,tick).
reading(good,resource(r_1_XX_)).
reading(good,outcome(o_2_XX_)).
reading(sharing,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(maintenance,resource(r_1_XX_)).
reading(goal(produce),resource(r_1_XX_)).
reading(consumes,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(consumes,relation(entity(e_2_XX_),resource(r_2_XX_))).
reading(outcome_helps,relation(outcome(o_2_XX_),resource(r_1_XX_))).

==========
<ul>
<li>The goal is to produce satiation</li>

<li>The player will do this by<ul>
<li>
attempting to make a [[blue|circle]] and [[red|circle]] touch
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>	the [[red|circle]] moves away from the cursor</li>
<li>
	pressing the mouse button
</li>
<li>
	holding the mouse button
</li>
</ul></ul>