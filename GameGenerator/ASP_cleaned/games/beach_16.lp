label(entity(e_1_XX_),e(1)).

entity(e_1_XX_).

many(entity(e_1_XX_)).

initialize(fill(all,orange)).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_color(entity(e_1_XX_),red)).

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

boundary(closed).


precondition(control_event(button(mouse,held)),outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),forward,scalar(5))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_1_XX_)).
result(outcome(o_1_XX_),clear(entity(e_1_XX_))).
result(outcome(o_1_XX_),delete(entity(e_1_XX_))).

precondition(le(amount(orange),scalar(1)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),decrease_over_time(property(entity(e_1_XX_),health),scalar(1))).

precondition(timer_elapsed(t_1_XX_),outcome(o_3_XX_)).
result(outcome(o_3_XX_),increase(property(entity(e_1_XX_),health),scalar(8))).
result(outcome(o_3_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,increase_over_time(property(entity(e_1_XX_),health),scalar(1))).

reading(produces,relation(pool(entity(e_1_XX_)),entity(e_1_XX_))).
==========
<ul>
<li>games/beach_16.lp</li>
<li>The player controls the game by<ul>
<li>
	clicking on a [[red|triangle]]
</li>
<li>
	holding the mouse button
</li>
</ul></ul>
