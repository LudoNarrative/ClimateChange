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

singular(entity(e_2_XX_)).

many(entity(e_1_XX_)).
many(entity(e_3_XX_)).

initialize(set_draggable(entity(e_1_XX_),true)).
initialize(add(entity(e_1_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_sprite(entity(e_3_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_3_XX_),green)).

controlLogic(draggable(entity(e_1_XX_))).

initialize(set_value(resource(r_1_XX_),scalar(9))).
initialize(set_value(resource(r_2_XX_),scalar(7))).

precondition(control_event(button(mouse,held)),outcome(drawn_to_cursor_entity_e_2_XX__XX__XX_)).
result(outcome(drawn_to_cursor_entity_e_2_XX__XX__XX_),increase_over_time(resource(r_2_XX_),scalar(1))).
result(outcome(drawn_to_cursor_entity_e_2_XX__XX__XX_),look_at(entity(e_2_XX_),cursor,nearest)).
result(outcome(drawn_to_cursor_entity_e_2_XX__XX__XX_),moves(entity(e_2_XX_),forward,scalar(7))).

precondition(overlaps(entity(e_2_XX_),entity(e_3_XX_),true),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase(resource(r_1_XX_),scalar(4))).
result(outcome(o_1_XX_),add(entity(e_3_XX_),scalar(1),location(bottom,right))).
result(outcome(o_1_XX_),delete(entity(e_3_XX_))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_2_XX_)).
precondition(le(resource(r_2_XX_),scalar(10)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_2_XX_),scalar(1))).
result(outcome(o_2_XX_),add(entity(e_3_XX_),scalar(1),location(top,left))).
result(outcome(o_2_XX_),delete(entity(e_1_XX_))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_3_XX_)).
result(outcome(o_3_XX_),increase(property(entity(e_2_XX_),health),scalar(9))).
result(outcome(o_3_XX_),decrease(resource(r_2_XX_),scalar(9))).
result(outcome(o_3_XX_),add(entity(e_3_XX_),scalar(1),location(top,left))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_4_XX_)).
result(outcome(o_4_XX_),increase(resource(r_2_XX_),scalar(1))).
result(outcome(o_4_XX_),add(entity(e_1_XX_),scalar(1),location(bottom,center))).
result(outcome(o_4_XX_),delete(entity(e_1_XX_))).

precondition(le(resource(r_1_XX_),scalar(4)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),mode_change(game_loss)).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_3_XX_),backward,scalar(3))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
result(tick,moves(entity(e_3_XX_),right,scalar(3))).
result(tick,look_at(entity(e_3_XX_),entity(e_1_XX_),nearest)).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(entity(e_1_XX_),resource(r_2_XX_))).
reading(produces,relation(entity(e_3_XX_),resource(r_1_XX_))).
reading(produces,relation(entity(e_3_XX_),resource(r_2_XX_))).
reading(consumes,relation(entity(e_3_XX_),entity(e_1_XX_))).
reading(bad,tick).
reading(good,outcome(o_1_XX_)).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_3_XX_),player)).
reading(hurt,relation(entity(e_3_XX_),entity(e_1_XX_))).
reading(hurt,relation(entity(e_2_XX_),entity(e_3_XX_))).
reading(defend_against,entity(e_3_XX_)).
reading(survive,entity(e_3_XX_)).
reading(help,relation(entity(e_3_XX_),player)).
==========
<ul>
<li>The goal is to produce r(1)</li>

<li>The player will do this by<ul>
<li>
attempting to make a [[green|circle]] and [[blue|circle]] touch
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>
	clicking-and-dragging [[red|circle]]s
</li>
<li>
	clicking on a [[red|circle]]
</li>
<li>
	holding the mouse button
</li>
</ul></ul>
