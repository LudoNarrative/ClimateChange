label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),concentration,write).
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

timer_logic(timer(t_1_XX_),scalar(3),loop).

pool(entity(e_1_XX_),location(top,left),random,random).
pool(entity(e_1_XX_),location(top,center),random,random).
pool(entity(e_1_XX_),location(top,right),random,random).
pool(entity(e_1_XX_),location(middle,center),random,random).
pool(entity(e_1_XX_),location(bottom,center),random,random).
pool(entity(e_2_XX_),location(top,center),ordered,ordered).
pool(entity(e_2_XX_),location(middle,center),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,center),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,right),ordered,ordered).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(10))).
initialize(set_value(resource(r_1_XX_),scalar(4))).

precondition(overlaps(entity(e_1_XX_),entity(e_1_XX_),true),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease(property(entity(e_2_XX_),health),scalar(8))).
result(outcome(o_1_XX_),increase(property(entity(e_2_XX_),health),scalar(5))).
result(outcome(o_1_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).
result(outcome(o_1_XX_),delete(entity(e_1_XX_))).

precondition(control_event(button(mouse,held)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),set_value(resource(r_1_XX_),amount(blue))).
result(outcome(o_2_XX_),increase_over_time(property(entity(e_1_XX_),health),scalar(5))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),clear(entity(e_2_XX_))).
result(outcome(o_3_XX_),delete(entity(e_1_XX_))).
result(outcome(o_3_XX_),delete(entity(e_2_XX_))).

precondition(timer_elapsed(t_1_XX_),outcome(o_4_XX_)).
result(outcome(o_4_XX_),draw(entity(e_1_XX_),blue)).
result(outcome(o_4_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

precondition(le(amount(blue),scalar(1)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),mode_change(game_loss)).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,set_value(resource(r_1_XX_),amount(blue))).
result(tick,decrease_over_time(property(entity(e_1_XX_),health),scalar(5))).
result(tick,moves(entity(e_2_XX_),right,scalar(5))).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

reading(goal(produce),amount(blue)).
reading(goal(produce),blue).
reading(good,amount(blue)).
reading(good,blue).
reading(produces,relation(pool(entity(e_2_XX_)),entity(e_2_XX_))).
reading(produces,relation(entity(e_1_XX_),property(entity(e_2_XX_),health))).
reading(consumes,relation(entity(e_1_XX_),entity(e_1_XX_))).
reading(consumes,relation(entity(e_1_XX_),property(entity(e_2_XX_),health))).
reading(bad,outcome(o_3_XX_)).
reading(good,outcome(o_4_XX_)).
reading(hurt,relation(entity(e_1_XX_),player)).
reading(hurt,relation(entity(e_2_XX_),player)).
reading(hurt,relation(entity(e_1_XX_),entity(e_1_XX_))).
reading(hurt,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(defend_against,entity(e_1_XX_)).
reading(defend_against,entity(e_2_XX_)).
reading(dodge,entity(e_1_XX_)).
reading(survive,entity(e_1_XX_)).
reading(survive,entity(e_2_XX_)).
reading(sharing,relation(entity(e_1_XX_),entity(e_1_XX_))).
reading(costs,relation(entity(e_2_XX_),property(entity(e_2_XX_),health))).
reading(difficulty,5).
reading(difficulty,scalar(1)).
==========
<ul>
<li>games/lecture_drawMode_17.lp</li>
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
