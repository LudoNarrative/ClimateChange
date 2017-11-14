label(entity(e_1_XX_),e(1)).

entity(e_1_XX_).

many(entity(e_1_XX_)).

initialize(fill(all,orange)).
initialize(set_draggable(entity(e_1_XX_),true)).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,right))).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_color(entity(e_1_XX_),red)).

controlLogic(draggable(entity(e_1_XX_))).

pool(entity(e_1_XX_),location(top,left),ordered,ordered).
pool(entity(e_1_XX_),location(top,center),ordered,ordered).
pool(entity(e_1_XX_),location(top,right),ordered,ordered).
pool(entity(e_1_XX_),location(middle,left),ordered,ordered).
pool(entity(e_1_XX_),location(middle,right),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,center),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,right),ordered,ordered).

boundary(closed).


precondition(control_event(button(mouse,pressed)),outcome(o_1_XX_)).
precondition(le(amount(orange),scalar(4)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease(property(entity(e_1_XX_),health),scalar(5))).
result(outcome(o_1_XX_),clear(entity(e_1_XX_))).
result(outcome(o_1_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_2_XX_)).
precondition(control_event(button(mouse,pressed)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),clear(entity(e_1_XX_))).
result(outcome(o_2_XX_),delete(entity(e_1_XX_))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_3_XX_)).
precondition(control_event(button(mouse,pressed)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),clear(entity(e_1_XX_))).
result(outcome(o_3_XX_),delete(entity(e_1_XX_))).

precondition(overlaps(entity(e_1_XX_),entity(e_1_XX_),true),outcome(o_4_XX_)).
result(outcome(o_4_XX_),clear(entity(e_1_XX_))).
result(outcome(o_4_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).
result(outcome(o_4_XX_),delete(entity(e_1_XX_))).

precondition(overlaps(entity(e_1_XX_),entity(e_1_XX_),true),outcome(o_5_XX_)).
result(outcome(o_5_XX_),clear(entity(e_1_XX_))).
result(outcome(o_5_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).
result(outcome(o_5_XX_),delete(entity(e_1_XX_))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_6_XX_)).
precondition(control_event(button(mouse,pressed)),outcome(o_6_XX_)).
result(outcome(o_6_XX_),clear(entity(e_1_XX_))).
result(outcome(o_6_XX_),delete(entity(e_1_XX_))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).

reading(consumes,relation(entity(e_1_XX_),entity(e_1_XX_))).
reading(hurt,relation(entity(e_1_XX_),entity(e_1_XX_))).
reading(hurt,relation(entity(e_1_XX_),player)).
reading(difficulty,scalar(1)).
==========
<ul>
<li>games/beach_5.lp</li>
<li>The player controls the game by<ul>
<li>
	clicking-and-dragging [[red|triangle]]s
</li>
<li>
	clicking on a [[red|triangle]]
</li>
<li>
	pressing the mouse button
</li>
</ul></ul>
