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

timer_logic(timer(t_1_XX_),scalar(3),loop).

initialize(set_value(resource(r_1_XX_),scalar(2))).
initialize(set_value(resource(r_2_XX_),scalar(2))).
initialize(set_value(resource(r_3_XX_),scalar(4))).

precondition(control_event(button(mouse,pressed)),outcome(click_to_move_entity_e_2_XX__XX__XX_)).
precondition(overlaps(entity(e_2_XX_),entity(e_2_XX_),false),outcome(click_to_move_entity_e_2_XX__XX__XX_)).
result(outcome(click_to_move_entity_e_2_XX__XX__XX_),increase(resource(r_1_XX_),scalar(3))).
result(outcome(click_to_move_entity_e_2_XX__XX__XX_),increase(resource(r_2_XX_),scalar(8))).
result(outcome(click_to_move_entity_e_2_XX__XX__XX_),apply_impulse(entity(e_2_XX_),direction(forward),scalar(4))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_1_XX_)).
precondition(ge(resource(r_2_XX_),scalar(9)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),delete(entity(e_3_XX_))).

precondition(control_event(button(mouse,pressed)),outcome(o_2_XX_)).
precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),false),outcome(o_2_XX_)).
result(outcome(o_2_XX_),apply_impulse(entity(e_2_XX_),direction(towards,entity(e_3_XX_)),scalar(3))).
result(outcome(o_2_XX_),increase(resource(r_3_XX_),scalar(4))).
result(outcome(o_2_XX_),add(entity(e_3_XX_),scalar(1),location(bottom,right))).

precondition(overlaps(entity(e_2_XX_),entity(e_2_XX_),true),outcome(o_3_XX_)).
precondition(ge(resource(r_3_XX_),scalar(0)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(property(health,entity(e_1_XX_)),scalar(9))).
result(outcome(o_3_XX_),add(entity(e_2_XX_),scalar(1),location(bottom,left))).
result(outcome(o_3_XX_),delete(entity(e_2_XX_))).

precondition(timer_elapsed(t_1_XX_),outcome(o_4_XX_)).
result(outcome(o_4_XX_),apply_impulse(entity(e_2_XX_),direction(towards,entity(e_2_XX_)),scalar(3))).
result(outcome(o_4_XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(o_4_XX_),add(entity(e_2_XX_),scalar(1),location(bottom,center))).

precondition(overlaps(entity(e_2_XX_),entity(e_2_XX_),true),outcome(o_5_XX_)).
precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),mode_change(game_loss)).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_3_XX_))).
result(tick,move_towards(entity(e_1_XX_),cursor,scalar(4))).
result(tick,rotates(entity(e_2_XX_),cw,scalar(1))).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(bad,outcome(o_4_XX_)).
reading(good,outcome(click_to_move_entity_e_2_XX__XX__XX_)).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_3_XX_),player)).
reading(hurt,relation(entity(e_1_XX_),entity(e_3_XX_))).
reading(defend_against,entity(e_3_XX_)).
reading(survive,entity(e_3_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(chases,relation(entity(e_1_XX_),cursor)).
reading(stakes(low),resource(r_1_XX_)).
reading(stakes(low),resource(r_2_XX_)).
reading(stakes(low),resource(r_3_XX_)).
reading(outcome_helps,relation(outcome(click_to_move_entity_e_2_XX__XX__XX_),resource(r_1_XX_))).
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
<li>	the [[red|circle]] moves towards the cursor</li>
<li>
	pressing the mouse button
</li>
</ul></ul>
