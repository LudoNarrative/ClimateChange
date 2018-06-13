label(resource(r_1_XX_),effort,write).
label(entity(e_1_XX_),e(1)).

entity(e_1_XX_).

resource(r_1_XX_).

singular(entity(e_1_XX_)).

initialize(set_value(resource(r_1_XX_),scalar(0))).
initialize(fill(all,orange)).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_color(entity(e_1_XX_),red)).

pool(entity(e_1_XX_),location(top,left),random,ordered).
pool(entity(e_1_XX_),location(top,center),random,ordered).
pool(entity(e_1_XX_),location(top,right),random,ordered).
pool(entity(e_1_XX_),location(middle,left),random,ordered).
pool(entity(e_1_XX_),location(middle,center),random,ordered).
pool(entity(e_1_XX_),location(middle,right),random,ordered).
pool(entity(e_1_XX_),location(bottom,left),random,ordered).
pool(entity(e_1_XX_),location(bottom,center),random,ordered).
pool(entity(e_1_XX_),location(bottom,right),random,ordered).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(0))).
initialize(set_value(resource(r_1_XX_),scalar(3))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase(resource(r_1_XX_),scalar(1))).
result(outcome(o_1_XX_),clear(entity(e_1_XX_))).

precondition(control_event(button(mouse,pressed)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(0))).
result(outcome(o_2_XX_),clear(entity(e_1_XX_))).

precondition(control_event(button(mouse,held)),outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),increase_over_time(resource(r_1_XX_),scalar(0))).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),clear(entity(e_1_XX_))).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),backward,resource(r_1_XX_))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).

reading(bad,orange).
reading(good,outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_)).
reading(good,outcome(o_2_XX_)).
reading(good,outcome(o_1_XX_)).
reading(stakes(low),resource(r_1_XX_)).
reading(grinding,resource(r_1_XX_)).
==========
<ul>
<li>games/beach_10.lp</li>
<li>GOAL:<ul>
</ul></li>

<li>SUBGOALS:<ul>
<li>
	pressing the mouse button
</li>
<li>
	clicking on a [[red|triangle]]
</li>
</ul></li>
<li>CONTROLS:<ul>
<li>	controlling [[red|triangle]] by making it flee the cursor 
by holding the mouse button
</li>
</ul></ul>
