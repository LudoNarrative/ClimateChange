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
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

timer_logic(timer(t_1_XX_),scalar(5),loop).
timer_logic(timer(behavior_condition_polarity_entity_e_2_XX__XX__X_wander_X_tick_XX_),scalar(3),loop).

pool(entity(e_1_XX_),location(top,left),ordered,ordered).
pool(entity(e_1_XX_),location(top,center),ordered,ordered).
pool(entity(e_1_XX_),location(top,right),ordered,ordered).
pool(entity(e_1_XX_),location(middle,left),ordered,ordered).
pool(entity(e_1_XX_),location(middle,center),ordered,ordered).
pool(entity(e_1_XX_),location(middle,right),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,center),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,right),ordered,ordered).
pool(entity(e_2_XX_),location(top,left),ordered,random).
pool(entity(e_2_XX_),location(top,center),ordered,random).
pool(entity(e_2_XX_),location(top,right),ordered,random).
pool(entity(e_2_XX_),location(middle,left),ordered,random).
pool(entity(e_2_XX_),location(middle,center),ordered,random).
pool(entity(e_2_XX_),location(middle,right),ordered,random).
pool(entity(e_2_XX_),location(bottom,left),ordered,random).
pool(entity(e_2_XX_),location(bottom,center),ordered,random).
pool(entity(e_2_XX_),location(bottom,right),ordered,random).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(10))).
initialize(set_value(resource(r_1_XX_),scalar(6))).

precondition(control_event(button(mouse,held)),outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),rotates(entity(e_1_XX_),cw,scalar(1))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_1_XX_)).
result(outcome(o_1_XX_),clear(entity(e_2_XX_))).

precondition(le(amount(blue),scalar(1)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),mode_change(game_loss)).

precondition(timer_elapsed(behavior_condition_polarity_entity_e_2_XX__XX__X_wander_X_tick_XX_),outcome(o_3_XX_)).
result(outcome(o_3_XX_),set_value(resource(r_1_XX_),amount(blue))).
result(outcome(o_3_XX_),rotate_to(entity(e_2_XX_),random_int(scalar(0),scalar(360)))).

precondition(timer_elapsed(t_1_XX_),outcome(o_4_XX_)).
result(outcome(o_4_XX_),set_value(resource(r_1_XX_),amount(blue))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_5_XX_)).
result(outcome(o_5_XX_),set_value(resource(r_1_XX_),amount(blue))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,set_value(resource(r_1_XX_),amount(blue))).
result(tick,draw(entity(e_1_XX_),blue)).
result(tick,moves(entity(e_2_XX_),forward,scalar(5))).
result(tick,moves(entity(e_1_XX_),forward,resource(r_1_XX_))).

reading(goal(produce),amount(blue)).
reading(goal(produce),blue).
reading(good,amount(blue)).
reading(good,blue).
reading(bad,outcome(o_1_XX_)).
reading(good,tick).
reading(difficulty,5).
reading(stakes(low),resource(r_1_XX_)).
==========
<ul>
<li>games/lecture_drawMode_26.lp</li>
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
