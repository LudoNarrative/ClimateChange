label(resource(r_1_XX_),concentration,write).
label(entity(e_1_XX_),e1).
label(entity(e_2_XX_),e(2)).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).

singular(entity(e_1_XX_)).

many(entity(e_2_XX_)).

initialize(set_value(resource(r_1_XX_),scalar(10))).
initialize(fill(all,blue)).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

pool(entity(e_1_XX_),location(top,left),random,random).
pool(entity(e_1_XX_),location(top,center),random,random).
pool(entity(e_1_XX_),location(top,right),random,random).
pool(entity(e_1_XX_),location(middle,left),random,random).
pool(entity(e_1_XX_),location(middle,center),random,random).
pool(entity(e_1_XX_),location(middle,right),random,random).
pool(entity(e_1_XX_),location(bottom,left),random,random).
pool(entity(e_1_XX_),location(bottom,right),random,random).
pool(entity(e_2_XX_),location(top,left),random,random).
pool(entity(e_2_XX_),location(top,right),random,random).
pool(entity(e_2_XX_),location(middle,right),random,random).
pool(entity(e_2_XX_),location(bottom,center),random,random).
pool(entity(e_2_XX_),location(bottom,right),random,random).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(10))).
initialize(set_value(resource(r_1_XX_),scalar(1))).

precondition(control_event(button(mouse,held)),outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),draw(entity(e_1_XX_),blue)).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),rotates(entity(e_1_XX_),cw,scalar(1))).

precondition(le(amount(blue),scalar(1)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(game_loss)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),set_value(resource(r_1_XX_),amount(blue))).
result(outcome(o_2_XX_),delete(entity(e_2_XX_))).

precondition(control_event(button(mouse,pressed)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),draw(entity(e_1_XX_),blue)).
result(outcome(o_3_XX_),decrease(property(entity(e_2_XX_),health),scalar(6))).
result(outcome(o_3_XX_),increase(property(entity(e_2_XX_),health),scalar(8))).
result(outcome(o_3_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_2_XX_))).
result(tick,set_value(resource(r_1_XX_),amount(blue))).
result(tick,clear(entity(e_2_XX_))).
result(tick,moves(entity(e_1_XX_),forward,resource(r_1_XX_))).
result(tick,moves(entity(e_2_XX_),right,scalar(5))).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

reading(goal(produce),amount(blue)).
reading(goal(produce),blue).
reading(good,amount(blue)).
reading(good,blue).
reading(produces,relation(pool(entity(e_2_XX_)),entity(e_2_XX_))).
reading(bad,tick).
reading(good,outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
reading(good,outcome(o_3_XX_)).
reading(hurt,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(costs,relation(entity(e_2_XX_),property(entity(e_2_XX_),health))).
reading(difficulty,5).
reading(stakes(low),resource(r_1_XX_)).
==========
<ul>
<li>games/lecture_drawMode_13.lp</li>
<li>GOAL:<ul>
<li>Produce blue</li>
</ul></li>

<li>SUBGOALS:<ul>
<li>
	pressing the mouse button
</li>
</ul></li>
<li>CONTROLS:<ul>
<li>	controlling [[red|triangle]] by making it rotate 
by holding the mouse button
</li>
</ul></ul>
