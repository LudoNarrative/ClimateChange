label(resource(r_1_XX_),tension,read_only).
label(resource(r_2_XX_),power,write).
label(entity(e_1_XX_),e(1)).
label(entity(e_2_XX_),e(2)).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

singular(entity(e_1_XX_)).

many(entity(e_2_XX_)).

initialize(set_draggable(entity(e_1_XX_),true)).
initialize(fill(all,clear)).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

controlLogic(draggable(entity(e_1_XX_))).

timer_logic(timer(behavior_condition_polarity_entity_e_2_XX__XX__X_wander_X_tick_XX_),scalar(3),loop).

pool(entity(e_1_XX_),location(top,left),random,ordered).
pool(entity(e_1_XX_),location(top,center),random,ordered).
pool(entity(e_1_XX_),location(top,right),random,ordered).
pool(entity(e_1_XX_),location(middle,left),random,ordered).
pool(entity(e_1_XX_),location(middle,center),random,ordered).
pool(entity(e_1_XX_),location(middle,right),random,ordered).
pool(entity(e_1_XX_),location(bottom,left),random,ordered).
pool(entity(e_1_XX_),location(bottom,center),random,ordered).
pool(entity(e_1_XX_),location(bottom,right),random,ordered).
pool(entity(e_2_XX_),location(top,left),random,random).
pool(entity(e_2_XX_),location(top,center),random,random).
pool(entity(e_2_XX_),location(top,right),random,random).
pool(entity(e_2_XX_),location(middle,left),random,random).
pool(entity(e_2_XX_),location(middle,center),random,random).
pool(entity(e_2_XX_),location(middle,right),random,random).
pool(entity(e_2_XX_),location(bottom,left),random,random).
pool(entity(e_2_XX_),location(bottom,center),random,random).
pool(entity(e_2_XX_),location(bottom,right),random,random).

boundary(torus).

initialize(set_value(resource(r_1_XX_),scalar(10))).
initialize(set_value(resource(r_2_XX_),scalar(10))).

precondition(ge(resource(r_2_XX_),scalar(4)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),set_value(resource(r_2_XX_),amount(clear))).

precondition(ge(resource(r_1_XX_),scalar(2)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),set_value(resource(r_2_XX_),amount(clear))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),set_value(resource(r_2_XX_),amount(clear))).

precondition(le(resource(r_2_XX_),scalar(10)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),set_value(resource(r_2_XX_),amount(clear))).

precondition(control_event(button(mouse,held)),outcome(o_5_XX_)).
precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_5_XX_)).
result(outcome(o_5_XX_),increase_over_time(resource(r_2_XX_),scalar(40))).

precondition(timer_elapsed(behavior_condition_polarity_entity_e_2_XX__XX__X_wander_X_tick_XX_),outcome(o_6_XX_)).
result(outcome(o_6_XX_),rotate_to(entity(e_2_XX_),random_int(scalar(0),scalar(360)))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,decrease_over_time(resource(r_2_XX_),scalar(2))).
result(tick,moves(entity(e_2_XX_),forward,resource(r_1_XX_))).

reading(goal(produce),resource(r_2_XX_)).
reading(good,resource(r_2_XX_)).
reading(produces,relation(entity(e_1_XX_),resource(r_2_XX_))).
reading(produces,relation(entity(e_2_XX_),resource(r_2_XX_))).
reading(bad,tick).
reading(good,outcome(o_5_XX_)).
reading(good,entity(e_1_XX_)).
reading(good,entity(e_2_XX_)).
reading(difficulty,resource(r_1_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_2_XX_)).
reading(stakes(low),resource(r_1_XX_)).
reading(stakes(low),resource(r_2_XX_)).
reading(outcome_helps,relation(outcome(o_5_XX_),resource(r_2_XX_))).
==========
<ul>
<li>games/dean_t_6.lp</li>
<li>GOAL:<ul>
<li>Produce power</li>
</ul></li>

<li>SUBGOALS:<ul>
<li>
	holding the mouse button
	 at the same time as
attempting to make a [[blue|triangle]] and [[red|triangle]] touch
</li>
</ul></li>
<li>CONTROLS:<ul>
</ul></ul>
