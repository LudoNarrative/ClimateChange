label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),stress).
label(entity(e_2_XX_),e(2)).
label(entity(e_3_XX_),e(3)).
label(resource(r_2_XX_),r(2)).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).
many(entity(e_3_XX_)).

initialize(set_static(entity(e_2_XX_),true)).
initialize(add(entity(e_1_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,center))).
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

timer_logic(timer(t_1_XX_),scalar(3),loop).
timer_logic(timer(t_2_XX_),scalar(2),loop).
timer_logic(timer(patrol_entity_e_3_XX__XX__XX_),scalar(2),loop).

initialize(set_value(resource(r_1_XX_),scalar(4))).
initialize(set_value(resource(r_2_XX_),scalar(2))).

precondition(timer_elapsed(t_2_XX_),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase(resource(r_1_XX_),scalar(1))).
result(outcome(o_1_XX_),add(entity(e_3_XX_),scalar(1),location(middle,left))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
precondition(le(resource(r_2_XX_),scalar(9)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),delete(entity(e_1_XX_))).
result(outcome(o_2_XX_),add(entity(e_3_XX_),scalar(1),location(middle,right))).

precondition(control_event(button(mouse,held)),outcome(o_3_XX_)).
precondition(ge(resource(r_1_XX_),scalar(0)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),move_towards(entity(e_1_XX_),cursor,scalar(3))).
result(outcome(o_3_XX_),increase_over_time(resource(r_2_XX_),scalar(1))).

precondition(timer_elapsed(t_1_XX_),outcome(o_4_XX_)).
result(outcome(o_4_XX_),decrease(resource(r_2_XX_),scalar(7))).

precondition(ge(resource(r_1_XX_),scalar(6)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),mode_change(game_loss)).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_6_XX_)).
precondition(le(resource(r_2_XX_),scalar(4)),outcome(o_6_XX_)).
result(outcome(o_6_XX_),decrease(resource(r_1_XX_),scalar(9))).
result(outcome(o_6_XX_),delete(entity(e_3_XX_))).
result(outcome(o_6_XX_),add(entity(e_1_XX_),scalar(1),location(bottom,right))).

precondition(timer_elapsed(patrol_entity_e_3_XX__XX__XX_),outcome(patrol_entity_e_3_XX__XX__XX_)).
result(outcome(patrol_entity_e_3_XX__XX__XX_),rotates(entity(e_3_XX_),cw,scalar(10))).

precondition(tick,tick).
result(tick,moves(entity(e_3_XX_),forward,scalar(3))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).

reading(bad,outcome(o_1_XX_)).
reading(bad,resource(r_1_XX_)).
reading(good,outcome(o_6_XX_)).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_1_XX_)).
reading(produces,relation(location(middle,left),entity(e_3_XX_))).
reading(produces,relation(location(middle,right),entity(e_3_XX_))).
reading(consumes,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_3_XX_),resource(r_1_XX_))).
reading(goal(reduce),resource(r_1_XX_)).
reading(hurt,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(chases,relation(entity(e_1_XX_),cursor)).
reading(stakes(low),resource(r_1_XX_)).
reading(stakes(low),resource(r_2_XX_)).
reading(outcome_helps,relation(outcome(o_6_XX_),resource(r_1_XX_))).

==========
<ul>
<li>The goal is to reduce stress</li>

<li>The player will do this by<ul>
<li>
attempting to make a [[blue|circle]] and [[red|circle]] touch
	 at the same time as
compare(le,resource(r(2)))
</li>
<li>
	 holding the mouse button
	 at the same time as
compare(ge,resource(r(1)))
</li>
<li>
attempting to make a [[green|circle]] and [[red|circle]] touch
	 at the same time as
compare(le,resource(r(2)))
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>	the [[red|circle]] moves towards the cursor</li>
<li>
	holding the mouse button
</li>
</ul></ul>