label(entity(e_1_XX_),emma).
label(entity(e_2_XX_),audience).
label(entity(e_3_XX_),objection).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

singular(entity(e_1_XX_)).

many(entity(e_2_XX_)).
many(entity(e_3_XX_)).

initialize(set_static(entity(e_2_XX_),true)).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_sprite(entity(e_3_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_3_XX_),green)).

timer_logic(timer(t_1_XX_),scalar(7),loop).

pool(entity(e_3_XX_),location(top,left),random,random).
pool(entity(e_3_XX_),location(top,center),random,random).
pool(entity(e_3_XX_),location(top,right),random,random).
pool(entity(e_3_XX_),location(middle,left),random,random).
pool(entity(e_3_XX_),location(middle,center),random,random).
pool(entity(e_3_XX_),location(middle,right),random,random).
pool(entity(e_3_XX_),location(bottom,left),random,random).
pool(entity(e_3_XX_),location(bottom,center),random,random).
pool(entity(e_3_XX_),location(bottom,right),random,random).
pool(entity(e_1_XX_),location(top,left),random,ordered).
pool(entity(e_1_XX_),location(top,center),random,ordered).
pool(entity(e_1_XX_),location(top,right),random,ordered).
pool(entity(e_1_XX_),location(middle,left),random,ordered).
pool(entity(e_1_XX_),location(middle,center),random,ordered).
pool(entity(e_1_XX_),location(middle,right),random,ordered).
pool(entity(e_1_XX_),location(bottom,left),random,ordered).
pool(entity(e_1_XX_),location(bottom,center),random,ordered).
pool(entity(e_1_XX_),location(bottom,right),random,ordered).
pool(entity(e_2_XX_),location(top,left),ordered,ordered).
pool(entity(e_2_XX_),location(top,center),ordered,ordered).
pool(entity(e_2_XX_),location(top,right),ordered,ordered).
pool(entity(e_2_XX_),location(middle,left),ordered,ordered).
pool(entity(e_2_XX_),location(middle,center),ordered,ordered).
pool(entity(e_2_XX_),location(middle,right),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,center),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,right),ordered,ordered).

boundary(closed).


precondition(timer_elapsed(t_1_XX_),outcome(o_1_XX_)).
result(outcome(o_1_XX_),add(entity(e_3_XX_),scalar(1),entity(e_2_XX_))).

precondition(ge(distance(entity(e_3_XX_),entity(e_1_XX_),nearest),scalar(120)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),moves(entity(e_3_XX_),right,scalar(3))).
result(outcome(o_2_XX_),look_at(entity(e_3_XX_),entity(e_1_XX_),nearest)).

precondition(le(distance(entity(e_3_XX_),entity(e_1_XX_),nearest),scalar(120)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),moves(entity(e_3_XX_),backward,scalar(3))).
result(outcome(o_3_XX_),look_at(entity(e_3_XX_),entity(e_1_XX_),nearest)).

precondition(control_event(button(mouse,pressed)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),increase(property(entity(e_3_XX_),health),scalar(3))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_5_XX_)).
result(outcome(o_5_XX_),delete(entity(e_3_XX_))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_6_XX_)).
result(outcome(o_6_XX_),add(entity(e_3_XX_),scalar(1),entity(e_2_XX_))).

precondition(control_event(button(mouse,held)),outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),left,scalar(5))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,decrease_over_time(property(entity(e_3_XX_),health),scalar(1))).

reading(produces,relation(entity(e_2_XX_),entity(e_3_XX_))).
reading(consumes,relation(entity(e_1_XX_),entity(e_3_XX_))).
reading(hurt,relation(entity(e_1_XX_),entity(e_3_XX_))).
reading(difficulty,3).
==========
<ul>
<li>games/un_t_5.lp</li>
<li>GOAL:<ul>
</ul></li>
<li>CONTROLS:<ul>
<li>	controlling [[red|triangle]] by making it orbit the cursor 
by holding the mouse button
</li>
</ul></ul>
