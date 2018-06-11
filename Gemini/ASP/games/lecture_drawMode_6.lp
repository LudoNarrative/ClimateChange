label(resource(r_1_XX_),concentration,write).
label(entity(e_1_XX_),e1).
label(entity(e_2_XX_),e(2)).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).

singular(entity(e_1_XX_)).

many(entity(e_2_XX_)).

initialize(set_value(resource(r_1_XX_),scalar(10))).
initialize(set_draggable(entity(e_1_XX_),true)).
initialize(fill(all,blue)).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

controlLogic(draggable(entity(e_1_XX_))).

pool(entity(e_2_XX_),location(top,center),random,ordered).
pool(entity(e_2_XX_),location(top,right),random,ordered).
pool(entity(e_2_XX_),location(middle,left),random,ordered).
pool(entity(e_2_XX_),location(middle,right),random,ordered).
pool(entity(e_2_XX_),location(bottom,left),random,ordered).
pool(entity(e_2_XX_),location(bottom,right),random,ordered).
pool(entity(e_1_XX_),location(top,left),ordered,random).
pool(entity(e_1_XX_),location(top,center),ordered,random).
pool(entity(e_1_XX_),location(top,right),ordered,random).
pool(entity(e_1_XX_),location(middle,left),ordered,random).
pool(entity(e_1_XX_),location(middle,center),ordered,random).
pool(entity(e_1_XX_),location(middle,right),ordered,random).
pool(entity(e_1_XX_),location(bottom,left),ordered,random).
pool(entity(e_1_XX_),location(bottom,center),ordered,random).
pool(entity(e_1_XX_),location(bottom,right),ordered,random).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(10))).
initialize(set_value(resource(r_1_XX_),scalar(10))).

precondition(control_event(button(mouse,pressed)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease(property(entity(e_2_XX_),health),scalar(10))).
result(outcome(o_1_XX_),increase(property(entity(e_2_XX_),health),scalar(2))).
result(outcome(o_1_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).

precondition(ge(distance(entity(e_2_XX_),entity(e_1_XX_),nearest),scalar(120)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),moves(entity(e_2_XX_),backward,scalar(5))).
result(outcome(o_2_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

precondition(le(amount(blue),scalar(1)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),mode_change(game_loss)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_4_XX_)).
result(outcome(o_4_XX_),clear(entity(e_2_XX_))).
result(outcome(o_4_XX_),delete(entity(e_2_XX_))).

precondition(le(distance(entity(e_2_XX_),entity(e_1_XX_),nearest),scalar(120)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),moves(entity(e_2_XX_),left,scalar(5))).
result(outcome(o_5_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_2_XX_))).
result(tick,set_value(resource(r_1_XX_),amount(blue))).
result(tick,draw(entity(e_1_XX_),blue)).

reading(goal(produce),amount(blue)).
reading(goal(produce),blue).
reading(good,amount(blue)).
reading(good,blue).
reading(bad,outcome(o_4_XX_)).
reading(good,tick).
reading(hurt,relation(entity(e_2_XX_),player)).
reading(hurt,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(defend_against,entity(e_2_XX_)).
reading(dodge,entity(e_2_XX_)).
reading(survive,entity(e_2_XX_)).
reading(costs,relation(entity(e_2_XX_),property(entity(e_2_XX_),health))).
reading(difficulty,5).
reading(difficulty,scalar(1)).
reading(stakes(low),resource(r_1_XX_)).
==========
<ul>
<li>games/lecture_drawMode_6.lp</li>
<li>GOAL:<ul>
<li>Produce blue</li>
</ul></li>
<li>AVOID:<ul>
<li>
	attempting to make a [[blue|triangle]] and [[red|triangle]] touch
</li>
</ul>
<li>CONTROLS:<ul>
</ul></ul>
