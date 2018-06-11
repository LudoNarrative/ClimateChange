label(resource(r_1_XX_),concentration,write).
label(entity(e_1_XX_),e1).
label(entity(e_2_XX_),e(2)).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(set_value(resource(r_1_XX_),scalar(10))).
initialize(fill(all,blue)).
initialize(add(entity(e_1_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,center))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

pool(entity(e_2_XX_),location(top,left),random,random).
pool(entity(e_2_XX_),location(top,center),random,random).
pool(entity(e_2_XX_),location(top,right),random,random).
pool(entity(e_2_XX_),location(middle,left),random,random).
pool(entity(e_2_XX_),location(middle,center),random,random).
pool(entity(e_2_XX_),location(middle,right),random,random).
pool(entity(e_2_XX_),location(bottom,left),random,random).
pool(entity(e_2_XX_),location(bottom,center),random,random).
pool(entity(e_2_XX_),location(bottom,right),random,random).
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

initialize(set_value(resource(r_1_XX_),scalar(10))).
initialize(set_value(resource(r_1_XX_),scalar(10))).

precondition(control_event(button(mouse,held)),outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),clear(entity(e_2_XX_))).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),rotates(entity(e_1_XX_),cw,scalar(5))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_1_XX_)).
result(outcome(o_1_XX_),set_value(resource(r_1_XX_),amount(blue))).
result(outcome(o_1_XX_),clear(entity(e_2_XX_))).

precondition(ge(distance(entity(e_2_XX_),entity(e_1_XX_),nearest),scalar(120)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),moves(entity(e_2_XX_),left,scalar(5))).
result(outcome(o_2_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

precondition(le(amount(blue),scalar(1)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),mode_change(game_loss)).

precondition(le(distance(entity(e_2_XX_),entity(e_1_XX_),nearest),scalar(120)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),moves(entity(e_2_XX_),backward,scalar(5))).
result(outcome(o_4_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_2_XX_))).
result(tick,set_value(resource(r_1_XX_),amount(blue))).
result(tick,draw(entity(e_1_XX_),blue)).
result(tick,moves(entity(e_1_XX_),forward,resource(r_1_XX_))).

reading(goal(produce),amount(blue)).
reading(goal(produce),blue).
reading(good,amount(blue)).
reading(good,blue).
reading(bad,outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
reading(bad,outcome(o_1_XX_)).
reading(good,tick).
reading(difficulty,5).
==========
<ul>
<li>games/lecture_drawMode_3.lp</li>
<li>GOAL:<ul>
<li>Produce blue</li>
</ul></li>
<li>AVOID:<ul>
<li>
	attempting to make a [[blue|triangle]] and [[red|triangle]] touch
</li>
</ul>
<li>CONTROLS:<ul>
<li>	controlling [[red|triangle]] by making it rotate 
by holding the mouse button
</li>
</ul></ul>
