label(resource(r_1_XX_),confidence,write).
label(entity(e_1_XX_),emma).
label(entity(e_2_XX_),audience).
label(entity(e_3_XX_),objection).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

resource(r_1_XX_).

singular(entity(e_1_XX_)).

many(entity(e_2_XX_)).
many(entity(e_3_XX_)).

initialize(fill(location(top,right),clear)).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(middle,right))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,center))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_sprite(entity(e_3_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_3_XX_),green)).

timer_logic(timer(t_1_XX_),scalar(3),loop).

pool(entity(e_2_XX_),location(top,left),random,random).
pool(entity(e_3_XX_),location(top,left),random,random).
pool(entity(e_2_XX_),location(top,center),random,random).
pool(entity(e_3_XX_),location(top,center),random,random).
pool(entity(e_2_XX_),location(top,right),random,random).
pool(entity(e_3_XX_),location(top,right),random,random).
pool(entity(e_2_XX_),location(middle,left),random,random).
pool(entity(e_3_XX_),location(middle,left),random,random).
pool(entity(e_3_XX_),location(middle,right),random,random).
pool(entity(e_2_XX_),location(bottom,left),random,random).
pool(entity(e_3_XX_),location(bottom,center),random,random).
pool(entity(e_2_XX_),location(bottom,right),random,random).
pool(entity(e_3_XX_),location(bottom,right),random,random).
pool(entity(e_1_XX_),location(top,center),ordered,ordered).
pool(entity(e_1_XX_),location(middle,left),ordered,ordered).
pool(entity(e_1_XX_),location(middle,center),ordered,ordered).
pool(entity(e_1_XX_),location(middle,right),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,center),ordered,ordered).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(6))).

precondition(ge(distance(entity(e_3_XX_),entity(e_1_XX_),nearest),scalar(120)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),moves(entity(e_3_XX_),right,scalar(3))).
result(outcome(o_1_XX_),look_at(entity(e_3_XX_),entity(e_2_XX_),nearest)).

precondition(le(resource(r_1_XX_),scalar(9)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),moves(entity(e_2_XX_),right,scalar(3))).
result(outcome(o_2_XX_),look_at(entity(e_2_XX_),entity(e_3_XX_),nearest)).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),delete(entity(e_3_XX_))).

precondition(timer_elapsed(t_1_XX_),outcome(o_4_XX_)).
result(outcome(o_4_XX_),add(entity(e_3_XX_),scalar(1),entity(e_2_XX_))).

precondition(le(distance(entity(e_3_XX_),entity(e_1_XX_),nearest),scalar(120)),outcome(o_5_XX_)).
precondition(ge(resource(r_1_XX_),scalar(0)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),moves(entity(e_3_XX_),left,scalar(3))).
result(outcome(o_5_XX_),moves(entity(e_2_XX_),left,scalar(3))).
result(outcome(o_5_XX_),look_at(entity(e_2_XX_),entity(e_3_XX_),nearest)).
result(outcome(o_5_XX_),look_at(entity(e_3_XX_),entity(e_1_XX_),nearest)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_6_XX_)).
result(outcome(o_6_XX_),decrease_over_time(resource(r_1_XX_),scalar(4))).

precondition(control_event(button(mouse,held)),outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),backward,resource(r_1_XX_))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_3_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_3_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,increase_over_time(resource(r_1_XX_),scalar(0))).

reading(produces,relation(entity(e_2_XX_),entity(e_3_XX_))).
reading(consumes,relation(entity(e_1_XX_),entity(e_3_XX_))).
reading(consumes,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(difficulty,3).
==========
<ul>
<li>games/un_3.lp</li>
<li>GOAL:<ul>
</ul></li>
<li>CONTROLS:<ul>
<li>	controlling [[red|triangle]] by making it flee the cursor 
by holding the mouse button
</li>
</ul></ul>
