label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),concentration).
label(entity(e_2_XX_),e(2)).
label(resource(r_2_XX_),r(2)).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,center))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).

timer_logic(timer(pingpong_entity_e_2_XX__XX__XX_),scalar(2),loop).
timer_logic(timer(wander_entity_e_2_XX__XX__XX_),scalar(4),loop).

initialize(set_value(resource(r_1_XX_),scalar(6))).
initialize(set_value(resource(r_2_XX_),scalar(8))).

precondition(control_event(button(mouse,held)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),move_away(entity(e_1_XX_),cursor,scalar(4))).

precondition(control_event(button(mouse,pressed)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),add(entity(e_1_XX_),scalar(1),location(bottom,left))).

precondition(overlaps(entity(e_1_XX_),entity(e_1_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),delete(entity(e_1_XX_))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),mode_change(game_loss)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_5_XX_)).
result(outcome(o_5_XX_),increase_over_time(resource(r_1_XX_),scalar(1))).

precondition(timer_elapsed(pingpong_entity_e_2_XX__XX__XX_),outcome(pingpong_entity_e_2_XX__XX__XX_)).
result(outcome(pingpong_entity_e_2_XX__XX__XX_),rotates(entity(e_2_XX_),cw,scalar(180))).
result(outcome(pingpong_entity_e_2_XX__XX__XX_),decrease(resource(r_1_XX_),scalar(1))).

precondition(timer_elapsed(wander_entity_e_2_XX__XX__XX_),outcome(wander_entity_e_2_XX__XX__XX_)).
result(outcome(wander_entity_e_2_XX__XX__XX_),rotate_to(entity(e_2_XX_),random_int(scalar(0),scalar(360)))).

precondition(tick,tick).
result(tick,moves(entity(e_2_XX_),forward,scalar(2))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).

reading(bad,outcome(pingpong_entity_e_2_XX__XX__XX_)).
reading(good,resource(r_1_XX_)).
reading(good,outcome(o_5_XX_)).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_1_XX_)).
reading(goal(produce),resource(r_1_XX_)).
reading(produces,relation(location(bottom,left),entity(e_1_XX_))).
reading(produces,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(produces,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_1_XX_),entity(e_1_XX_))).
reading(hurt,relation(entity(e_1_XX_),entity(e_1_XX_))).
reading(flees,relation(entity(e_1_XX_),cursor)).
reading(stakes(low),resource(r_1_XX_)).
reading(stakes(low),resource(r_2_XX_)).
reading(outcome_helps,relation(outcome(o_5_XX_),resource(r_1_XX_))).

==========
<ul>
<li>The goal is to produce concentration</li>

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