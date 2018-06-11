label(entity(e_1_XX_),e1).
label(entity(e_2_XX_),e(2)).
label(resource(r_1_XX_),r(1),private).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(set_value(resource(r_1_XX_),scalar(0))).
initialize(set_draggable(entity(e_1_XX_),true)).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

controlLogic(draggable(entity(e_1_XX_))).

timer_logic(timer(t_1_XX_),scalar(7),loop).

pool(entity(e_1_XX_),location(top,center),ordered,ordered).
pool(entity(e_1_XX_),location(top,right),ordered,ordered).
pool(entity(e_1_XX_),location(middle,left),ordered,ordered).
pool(entity(e_1_XX_),location(middle,center),ordered,ordered).
pool(entity(e_1_XX_),location(middle,right),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,center),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,right),ordered,ordered).
pool(entity(e_2_XX_),location(top,center),ordered,ordered).
pool(entity(e_2_XX_),location(top,right),ordered,ordered).
pool(entity(e_2_XX_),location(middle,left),ordered,ordered).
pool(entity(e_2_XX_),location(middle,right),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,center),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,right),ordered,ordered).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(0))).
initialize(set_value(resource(r_1_XX_),scalar(7))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_1_XX_)).
result(outcome(o_1_XX_),clear(entity(e_1_XX_))).
result(outcome(o_1_XX_),delete(entity(e_1_XX_))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_2_XX_)).
result(outcome(o_2_XX_),set_value(resource(r_1_XX_),amount(clear))).

precondition(timer_elapsed(t_1_XX_),outcome(o_3_XX_)).
result(outcome(o_3_XX_),draw(entity(e_2_XX_),blue)).
result(outcome(o_3_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

precondition(ge(amount(blue),scalar(9)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),mode_change(game_loss)).

precondition(control_event(button(mouse,held)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),set_value(resource(r_1_XX_),amount(clear))).
result(outcome(o_5_XX_),decrease_over_time(property(entity(e_1_XX_),health),scalar(10))).
result(outcome(o_5_XX_),increase_over_time(property(entity(e_1_XX_),health),scalar(10))).
result(outcome(o_5_XX_),clear(entity(e_1_XX_))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,set_value(resource(r_1_XX_),amount(clear))).
result(tick,moves(entity(e_2_XX_),right,scalar(5))).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

reading(produces,relation(pool(entity(e_1_XX_)),entity(e_1_XX_))).
reading(consumes,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(goal(reduce),blue).
reading(bad,blue).
reading(bad,outcome(o_3_XX_)).
reading(good,outcome(o_5_XX_)).
reading(good,outcome(o_1_XX_)).
reading(hand_eye_coordination,game).
reading(hurt,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(difficulty,5).
reading(stakes(low),resource(r_1_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(sharing,relation(entity(e_1_XX_),entity(e_2_XX_))).
==========
<ul>
<li>games/lecture_scrubMode_29.lp</li>
<li>GOAL:<ul>
<li>Reduce blue</li>
</ul></li>

<li>SUBGOALS:<ul>
<li>
	holding the mouse button
</li>
<li>
attempting to make a [[blue|triangle]] and [[red|triangle]] touch
</li>
</ul></li>
<li>CONTROLS:<ul>
</ul></ul>
