label(resource(r_1_XX_),concentration,write).
label(entity(e_1_XX_),e1).
label(entity(e_2_XX_),e(2)).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(set_value(resource(r_1_XX_),scalar(10))).
initialize(set_draggable(entity(e_1_XX_),true)).
initialize(fill(all,blue)).
initialize(add(entity(e_1_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,center))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

controlLogic(draggable(entity(e_1_XX_))).

timer_logic(timer(t_1_XX_),scalar(7),loop).

pool(entity(e_1_XX_),location(top,left),random,random).
pool(entity(e_1_XX_),location(top,center),random,random).
pool(entity(e_1_XX_),location(top,right),random,random).
pool(entity(e_1_XX_),location(middle,left),random,random).
pool(entity(e_1_XX_),location(middle,center),random,random).
pool(entity(e_1_XX_),location(middle,right),random,random).
pool(entity(e_1_XX_),location(bottom,left),random,random).
pool(entity(e_1_XX_),location(bottom,center),random,random).
pool(entity(e_1_XX_),location(bottom,right),random,random).
pool(entity(e_2_XX_),location(top,left),random,random).
pool(entity(e_2_XX_),location(top,center),random,random).
pool(entity(e_2_XX_),location(top,right),random,random).
pool(entity(e_2_XX_),location(middle,left),random,random).
pool(entity(e_2_XX_),location(middle,center),random,random).
pool(entity(e_2_XX_),location(middle,right),random,random).
pool(entity(e_2_XX_),location(bottom,left),random,random).
pool(entity(e_2_XX_),location(bottom,right),random,random).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(10))).
initialize(set_value(resource(r_1_XX_),scalar(4))).

precondition(ge(distance(entity(e_2_XX_),entity(e_1_XX_),nearest),scalar(120)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),set_value(resource(r_1_XX_),amount(blue))).
result(outcome(o_1_XX_),moves(entity(e_2_XX_),left,scalar(5))).
result(outcome(o_1_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),set_value(resource(r_1_XX_),amount(blue))).
result(outcome(o_2_XX_),clear(entity(e_2_XX_))).
result(outcome(o_2_XX_),delete(entity(e_1_XX_))).
result(outcome(o_2_XX_),delete(entity(e_2_XX_))).

precondition(control_event(button(mouse,pressed)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(property(entity(e_1_XX_),health),scalar(9))).
result(outcome(o_3_XX_),increase(property(entity(e_1_XX_),health),scalar(8))).
result(outcome(o_3_XX_),increase(property(entity(e_2_XX_),health),scalar(1))).
result(outcome(o_3_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

precondition(le(amount(blue),scalar(1)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),mode_change(game_loss)).

precondition(timer_elapsed(t_1_XX_),outcome(o_5_XX_)).
result(outcome(o_5_XX_),set_value(resource(r_1_XX_),amount(blue))).
result(outcome(o_5_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).

precondition(le(distance(entity(e_2_XX_),entity(e_1_XX_),nearest),scalar(120)),outcome(o_6_XX_)).
result(outcome(o_6_XX_),set_value(resource(r_1_XX_),amount(blue))).
result(outcome(o_6_XX_),moves(entity(e_2_XX_),backward,scalar(5))).
result(outcome(o_6_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_2_XX_))).
result(tick,set_value(resource(r_1_XX_),amount(blue))).
result(tick,draw(entity(e_1_XX_),blue)).
result(tick,decrease_over_time(property(entity(e_2_XX_),health),scalar(10))).

reading(goal(produce),amount(blue)).
reading(goal(produce),blue).
reading(good,amount(blue)).
reading(good,blue).
reading(produces,relation(pool(entity(e_1_XX_)),entity(e_1_XX_))).
reading(produces,relation(pool(entity(e_2_XX_)),entity(e_2_XX_))).
reading(consumes,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(bad,outcome(o_2_XX_)).
reading(good,tick).
reading(hurt,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(hurt,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(sharing,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(costs,relation(entity(e_1_XX_),property(entity(e_1_XX_),health))).
reading(difficulty,5).
reading(stakes(low),resource(r_1_XX_)).
==========
<ul>
<li>games/lecture_drawMode_11.lp</li>
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
