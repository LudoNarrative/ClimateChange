label(entity(e_1_XX_),emma).
label(entity(e_2_XX_),audience).
label(entity(e_3_XX_),objection).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

singular(entity(e_1_XX_)).

many(entity(e_2_XX_)).
many(entity(e_3_XX_)).

initialize(set_static(entity(e_3_XX_),true)).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_sprite(entity(e_3_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_3_XX_),green)).

pool(entity(e_1_XX_),location(top,left),random,random).
pool(entity(e_1_XX_),location(top,center),random,random).
pool(entity(e_1_XX_),location(middle,left),random,random).
pool(entity(e_1_XX_),location(middle,center),random,random).
pool(entity(e_1_XX_),location(middle,right),random,random).
pool(entity(e_1_XX_),location(bottom,left),random,random).
pool(entity(e_1_XX_),location(bottom,center),random,random).
pool(entity(e_1_XX_),location(bottom,right),random,random).
pool(entity(e_3_XX_),location(top,left),ordered,random).
pool(entity(e_3_XX_),location(top,right),ordered,random).
pool(entity(e_3_XX_),location(middle,left),ordered,random).
pool(entity(e_3_XX_),location(middle,center),ordered,random).
pool(entity(e_3_XX_),location(middle,right),ordered,random).
pool(entity(e_3_XX_),location(bottom,left),ordered,random).
pool(entity(e_3_XX_),location(bottom,center),ordered,random).
pool(entity(e_3_XX_),location(bottom,right),ordered,random).
pool(entity(e_2_XX_),location(top,left),ordered,ordered).
pool(entity(e_2_XX_),location(top,center),ordered,ordered).
pool(entity(e_2_XX_),location(top,right),ordered,ordered).
pool(entity(e_2_XX_),location(middle,left),ordered,ordered).
pool(entity(e_2_XX_),location(middle,right),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,center),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,right),ordered,ordered).

boundary(closed).


precondition(control_event(click(entity(e_2_XX_))),outcome(o_1_XX_)).
result(outcome(o_1_XX_),add(entity(e_3_XX_),scalar(1),entity(e_2_XX_))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),delete(entity(e_3_XX_))).

precondition(control_event(button(mouse,pressed)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(property(entity(e_3_XX_),health),scalar(10))).
result(outcome(o_3_XX_),increase(property(entity(e_3_XX_),health),scalar(7))).
result(outcome(o_3_XX_),add(entity(e_3_XX_),scalar(1),entity(e_2_XX_))).

precondition(control_event(button(mouse,held)),outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),right,scalar(3))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,moves(entity(e_2_XX_),left,scalar(5))).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

reading(produces,relation(entity(e_2_XX_),entity(e_3_XX_))).
reading(consumes,relation(entity(e_1_XX_),entity(e_3_XX_))).
reading(hurt,relation(entity(e_1_XX_),entity(e_3_XX_))).
reading(costs,relation(entity(e_3_XX_),property(entity(e_3_XX_),health))).
reading(difficulty,5).
==========
<ul>
<li>games/un_t_25.lp</li>
<li>GOAL:<ul>
</ul></li>
<li>CONTROLS:<ul>
<li>	controlling [[red|triangle]] by making it orbit the cursor 
by holding the mouse button
</li>
</ul></ul>
