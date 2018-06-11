label(entity(e_1_XX_),e1).
label(entity(e_2_XX_),e(2)).
label(resource(r_1_XX_),r(1),private).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).

singular(entity(e_1_XX_)).

many(entity(e_2_XX_)).

initialize(set_value(resource(r_1_XX_),scalar(0))).
initialize(fill(location(top,left),blue)).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

timer_logic(timer(t_1_XX_),scalar(7),loop).
timer_logic(timer(t_2_XX_),scalar(7),loop).
timer_logic(timer(behavior_condition_polarity_entity_e_2_XX__XX__X_wander_X_tick_XX_),scalar(7),loop).

pool(entity(e_1_XX_),location(top,left),random,random).
pool(entity(e_1_XX_),location(top,center),random,random).
pool(entity(e_1_XX_),location(top,right),random,random).
pool(entity(e_1_XX_),location(middle,left),random,random).
pool(entity(e_1_XX_),location(middle,center),random,random).
pool(entity(e_1_XX_),location(middle,right),random,random).
pool(entity(e_1_XX_),location(bottom,left),random,random).
pool(entity(e_1_XX_),location(bottom,center),random,random).
pool(entity(e_1_XX_),location(bottom,right),random,random).
pool(entity(e_2_XX_),location(top,left),random,random).
pool(entity(e_2_XX_),location(top,center),random,random).
pool(entity(e_2_XX_),location(top,right),random,random).
pool(entity(e_2_XX_),location(middle,left),random,random).
pool(entity(e_2_XX_),location(middle,center),random,random).
pool(entity(e_2_XX_),location(middle,right),random,random).
pool(entity(e_2_XX_),location(bottom,left),random,random).
pool(entity(e_2_XX_),location(bottom,center),random,random).
pool(entity(e_2_XX_),location(bottom,right),random,random).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(0))).
initialize(set_value(resource(r_1_XX_),scalar(10))).

precondition(control_event(button(mouse,held)),outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),rotates(entity(e_1_XX_),ccw,scalar(10))).

precondition(timer_elapsed(t_2_XX_),outcome(o_1_XX_)).
result(outcome(o_1_XX_),draw(entity(e_2_XX_),blue)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),clear(entity(e_1_XX_))).

precondition(timer_elapsed(t_1_XX_),outcome(o_3_XX_)).
result(outcome(o_3_XX_),draw(entity(e_2_XX_),blue)).

precondition(control_event(button(mouse,pressed)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),clear(entity(e_1_XX_))).

precondition(timer_elapsed(behavior_condition_polarity_entity_e_2_XX__XX__X_wander_X_tick_XX_),outcome(o_5_XX_)).
result(outcome(o_5_XX_),draw(entity(e_2_XX_),blue)).
result(outcome(o_5_XX_),rotate_to(entity(e_2_XX_),random_int(scalar(0),scalar(360)))).

precondition(ge(amount(blue),scalar(9)),outcome(o_6_XX_)).
result(outcome(o_6_XX_),mode_change(game_loss)).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,set_value(resource(r_1_XX_),amount(clear))).
result(tick,draw(cursor,blue)).
result(tick,moves(entity(e_2_XX_),forward,scalar(3))).
result(tick,moves(entity(e_1_XX_),forward,resource(r_1_XX_))).

reading(goal(reduce),blue).
reading(bad,blue).
reading(bad,tick).
reading(bad,outcome(o_5_XX_)).
reading(bad,outcome(o_3_XX_)).
reading(bad,outcome(o_1_XX_)).
reading(good,outcome(o_4_XX_)).
reading(good,outcome(o_2_XX_)).
reading(hand_eye_coordination,game).
reading(difficulty,3).
reading(help,relation(entity(e_2_XX_),player)).
==========
<ul>
<li>games/lecture_scrubMode_20.lp</li>
<li>GOAL:<ul>
<li>Reduce blue</li>
</ul></li>

<li>SUBGOALS:<ul>
<li>
	pressing the mouse button
</li>
<li>
attempting to make a [[blue|triangle]] and [[red|triangle]] touch
</li>
</ul></li>
<li>CONTROLS:<ul>
<li>	controlling [[red|triangle]] by making it rotate 
by holding the mouse button
</li>
</ul></ul>
