label(entity(e_1_XX_),e(1)).

entity(e_1_XX_).

many(entity(e_1_XX_)).

initialize(fill(all,orange)).
initialize(set_draggable(entity(e_1_XX_),true)).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,right))).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_color(entity(e_1_XX_),red)).

controlLogic(draggable(entity(e_1_XX_))).

timer_logic(timer(t_1_XX_),scalar(7),loop).
timer_logic(timer(t_2_XX_),scalar(7),loop).

pool(entity(e_1_XX_),location(top,left),random,random).
pool(entity(e_1_XX_),location(top,center),random,random).
pool(entity(e_1_XX_),location(top,right),random,random).
pool(entity(e_1_XX_),location(middle,left),random,random).
pool(entity(e_1_XX_),location(middle,center),random,random).
pool(entity(e_1_XX_),location(middle,right),random,random).
pool(entity(e_1_XX_),location(bottom,left),random,random).
pool(entity(e_1_XX_),location(bottom,center),random,random).
pool(entity(e_1_XX_),location(bottom,right),random,random).

boundary(closed).


precondition(timer_elapsed(t_1_XX_),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease(property(entity(e_1_XX_),health),scalar(6))).
result(outcome(o_1_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

precondition(overlaps(entity(e_1_XX_),entity(e_1_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),clear(entity(e_1_XX_))).
result(outcome(o_2_XX_),delete(entity(e_1_XX_))).

precondition(timer_elapsed(t_2_XX_),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(property(entity(e_1_XX_),health),scalar(4))).
result(outcome(o_3_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

precondition(overlaps(entity(e_1_XX_),entity(e_1_XX_),true),outcome(o_4_XX_)).
precondition(le(amount(orange),scalar(4)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),decrease_over_time(property(entity(e_1_XX_),health),scalar(5))).
result(outcome(o_4_XX_),increase_over_time(property(entity(e_1_XX_),health),scalar(9))).
result(outcome(o_4_XX_),clear(entity(e_1_XX_))).

precondition(control_event(button(mouse,held)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),clear(entity(e_1_XX_))).

precondition(control_event(button(mouse,pressed)),outcome(o_6_XX_)).
result(outcome(o_6_XX_),decrease(property(entity(e_1_XX_),health),scalar(1))).
result(outcome(o_6_XX_),clear(entity(e_1_XX_))).
result(outcome(o_6_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).

reading(produces,relation(entity(e_1_XX_),property(entity(e_1_XX_),health))).
reading(consumes,relation(entity(e_1_XX_),entity(e_1_XX_))).
reading(consumes,relation(entity(e_1_XX_),property(entity(e_1_XX_),health))).
reading(hurt,relation(entity(e_1_XX_),entity(e_1_XX_))).
reading(hurt,relation(entity(e_1_XX_),player)).
reading(defend_against,entity(e_1_XX_)).
reading(survive,entity(e_1_XX_)).
reading(difficulty,scalar(1)).
==========
<ul>
<li>games/beach_6.lp</li>
<li>The player controls the game by<ul>
<li>
	clicking-and-dragging [[red|circle]]s
</li>
<li>
	pressing the mouse button
</li>
<li>
	holding the mouse button
</li>
</ul></ul>
