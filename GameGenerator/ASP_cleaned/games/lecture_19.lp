label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),concentration,private).
label(entity(e_2_XX_),e(2)).
label(entity(e_3_XX_),e(3)).
label(resource(r_1_XX_),r(1)).
label(resource(r_2_XX_),r(2)).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).
many(entity(e_3_XX_)).

initialize(set_draggable(entity(e_1_XX_),true)).
initialize(set_draggable(entity(e_2_XX_),true)).
initialize(add(entity(e_1_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(middle,center))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_sprite(entity(e_3_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_3_XX_),green)).

controlLogic(draggable(entity(e_1_XX_))).
controlLogic(draggable(entity(e_2_XX_))).

timer_logic(timer(pingpong_entity_e_3_XX__XX__XX_),scalar(3),loop).

initialize(set_value(resource(r_1_XX_),scalar(7))).
initialize(set_value(resource(r_2_XX_),scalar(8))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase(property(entity(e_3_XX_),health),scalar(1))).
result(outcome(o_1_XX_),add(entity(e_1_XX_),scalar(1),location(top,center))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_2_XX_)).
precondition(le(resource(r_2_XX_),scalar(9)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(4))).
result(outcome(o_2_XX_),delete(entity(e_1_XX_))).
result(outcome(o_2_XX_),delete(entity(e_3_XX_))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_3_XX_)).
result(outcome(o_3_XX_),increase(property(entity(e_2_XX_),health),scalar(5))).
result(outcome(o_3_XX_),increase(resource(r_2_XX_),scalar(5))).
result(outcome(o_3_XX_),add(entity(e_3_XX_),scalar(1),location(middle,center))).

precondition(le(resource(r_1_XX_),scalar(20)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),mode_change(game_loss)).

precondition(overlaps(entity(e_2_XX_),entity(e_3_XX_),true),outcome(o_5_XX_)).
precondition(le(resource(r_1_XX_),scalar(32)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),delete(entity(e_2_XX_))).

precondition(timer_elapsed(pingpong_entity_e_3_XX__XX__XX_),outcome(pingpong_entity_e_3_XX__XX__XX_)).
result(outcome(pingpong_entity_e_3_XX__XX__XX_),rotates(entity(e_3_XX_),cw,scalar(180))).
result(outcome(pingpong_entity_e_3_XX__XX__XX_),add(entity(e_2_XX_),scalar(1),location(top,left))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_3_XX_),forward,scalar(3))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
result(tick,decrease_over_time(resource(r_2_XX_),scalar(5))).
result(tick,moves(entity(e_3_XX_),left,scalar(3))).
result(tick,look_at(entity(e_3_XX_),entity(e_2_XX_),furthest)).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(location(top,left),entity(e_2_XX_))).
reading(produces,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(produces,relation(entity(e_3_XX_),resource(r_1_XX_))).
reading(bad,tick).
reading(good,outcome(o_2_XX_)).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_1_XX_)).
reading(help,relation(entity(e_3_XX_),player)).
reading(stakes(low),resource(r_2_XX_)).
==========
<ul>
<li>The goal is to produce r(1)</li>

<li>The player will do this by<ul>
<li>
attempting to make a [[green|circle]] and [[red|circle]] touch
	 at the same time as
compare(le,resource(r(2)))
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>
	clicking-and-dragging [[red|circle]]s
</li>
<li>
	clicking-and-dragging [[blue|circle]]s
</li>
<li>
	clicking on a [[red|circle]]
</li>
<li>
	clicking on a [[blue|circle]]
</li>
</ul></ul>
