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

pool(entity(e_1_XX_),location(top,left),ordered,ordered).
pool(entity(e_1_XX_),location(top,center),ordered,ordered).
pool(entity(e_1_XX_),location(top,right),ordered,ordered).
pool(entity(e_1_XX_),location(middle,left),ordered,ordered).
pool(entity(e_1_XX_),location(middle,center),ordered,ordered).
pool(entity(e_1_XX_),location(middle,right),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,center),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,right),ordered,ordered).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(0))).
initialize(set_value(resource(r_1_XX_),scalar(1))).

precondition(control_event(button(mouse,held)),outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),increase_over_time(resource(r_1_XX_),scalar(1))).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),clear(entity(e_1_XX_))).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),rotates(entity(e_1_XX_),ccw,scalar(10))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase(resource(r_1_XX_),scalar(1))).
result(outcome(o_1_XX_),clear(entity(e_1_XX_))).

precondition(control_event(button(mouse,pressed)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(1))).
result(outcome(o_2_XX_),clear(entity(e_1_XX_))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,moves(entity(e_1_XX_),forward,scalar(5))).

reading(bad,orange).
reading(good,outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
reading(good,outcome(o_2_XX_)).
reading(good,outcome(o_1_XX_)).
reading(stakes(low),resource(r_1_XX_)).
reading(grinding,resource(r_1_XX_)).
==========
<ul>
<li>games/beach_13.lp</li>
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
<li>	controlling [[red|triangle]] by making it rotate 
by holding the mouse button
</li>
</ul></ul>
