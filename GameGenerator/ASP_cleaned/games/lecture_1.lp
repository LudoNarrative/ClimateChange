label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),concentration,write).
label(entity(e_2_XX_),e(2)).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).

singular(entity(e_2_XX_)).

many(entity(e_1_XX_)).

<<<<<<< HEAD
<<<<<<< HEAD
initialize(set_static(entity(e_1_XX_),true)).
=======
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0
initialize(add(entity(e_1_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,right))).
<<<<<<< HEAD
initialize(add(entity(e_2_XX_),scalar(1),location(middle,center))).
=======
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0
=======
initialize(add(entity(e_1_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,center))).
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

<<<<<<< HEAD
<<<<<<< HEAD
timer_logic(timer(behavior_condition_polarity_entity_e_2_XX__XX__X_wander_X_tick_XX_),scalar(7),loop).

=======
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f
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
<<<<<<< HEAD
=======
pool(entity(e_2_XX_),location(top,left),random,ordered).
pool(entity(e_2_XX_),location(top,center),random,ordered).
pool(entity(e_2_XX_),location(top,right),random,ordered).
pool(entity(e_2_XX_),location(middle,left),random,ordered).
pool(entity(e_2_XX_),location(middle,center),random,ordered).
pool(entity(e_2_XX_),location(middle,right),random,ordered).
pool(entity(e_2_XX_),location(bottom,left),random,ordered).
pool(entity(e_2_XX_),location(bottom,center),random,ordered).
pool(entity(e_2_XX_),location(bottom,right),random,ordered).
pool(entity(e_1_XX_),location(top,left),ordered,random).
pool(entity(e_1_XX_),location(top,center),ordered,random).
pool(entity(e_1_XX_),location(top,right),ordered,random).
pool(entity(e_1_XX_),location(middle,left),ordered,random).
pool(entity(e_1_XX_),location(middle,center),ordered,random).
pool(entity(e_1_XX_),location(middle,right),ordered,random).
pool(entity(e_1_XX_),location(bottom,left),ordered,random).
pool(entity(e_1_XX_),location(bottom,center),ordered,random).
pool(entity(e_1_XX_),location(bottom,right),ordered,random).
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0
=======
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f

boundary(torus).

initialize(set_value(resource(r_1_XX_),scalar(10))).

precondition(control_event(button(mouse,held)),outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),decrease_over_time(resource(r_1_XX_),scalar(1))).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),rotates(entity(e_1_XX_),ccw,scalar(10))).

<<<<<<< HEAD
<<<<<<< HEAD
precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(game_loss)).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(8))).

precondition(control_event(button(mouse,pressed)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(resource(r_1_XX_),scalar(1))).

precondition(tick,outcome(o_4_XX_)).
precondition(timer_elapsed(behavior_condition_polarity_entity_e_2_XX__XX__X_wander_X_tick_XX_),outcome(o_4_XX_)).
result(outcome(o_4_XX_),rotate_to(entity(e_2_XX_),random_int(scalar(0),scalar(360)))).
=======
precondition(control_event(button(mouse,pressed)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease(resource(r_1_XX_),scalar(1))).
=======
precondition(le(resource(r_1_XX_),scalar(4)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(game_loss)).
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f

precondition(control_event(button(mouse,pressed)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(o_2_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).

precondition(ge(distance(entity(e_2_XX_),entity(e_1_XX_),nearest),scalar(120)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease_over_time(resource(r_1_XX_),scalar(1))).
result(outcome(o_3_XX_),moves(entity(e_2_XX_),forward,resource(r_1_XX_))).
result(outcome(o_3_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_4_XX_)).
<<<<<<< HEAD
result(outcome(o_4_XX_),increase(resource(r_1_XX_),scalar(8))).
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0

precondition(tick,tick).
=======
result(outcome(o_4_XX_),increase(resource(r_1_XX_),scalar(4))).
result(outcome(o_4_XX_),delete(entity(e_2_XX_))).

precondition(le(distance(entity(e_2_XX_),entity(e_1_XX_),nearest),scalar(120)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),decrease_over_time(resource(r_1_XX_),scalar(1))).
result(outcome(o_5_XX_),moves(entity(e_2_XX_),backward,resource(r_1_XX_))).
result(outcome(o_5_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f
result(tick,apply_restitution(entity(e_2_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,decrease_over_time(property(entity(e_2_XX_),health),scalar(10))).
result(tick,increase_over_time(property(entity(e_2_XX_),health),scalar(10))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
<<<<<<< HEAD
<<<<<<< HEAD
result(tick,moves(entity(e_2_XX_),forward,resource(r_1_XX_))).
=======
result(tick,moves(entity(e_2_XX_),backward,scalar(5))).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0
=======
result(tick,moves(entity(e_1_XX_),forward,resource(r_1_XX_))).
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(pool(entity(e_2_XX_)),entity(e_2_XX_))).
reading(bad,tick).
<<<<<<< HEAD
<<<<<<< HEAD
reading(bad,outcome(o_3_XX_)).
reading(good,outcome(o_2_XX_)).
reading(hand_eye_coordination,game).
reading(risk_reward,control_event(button(mouse,pressed))).
reading(maintenance,resource(r_1_XX_)).
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_hurts,relation(outcome(o_3_XX_),resource(r_1_XX_))).
reading(risk,outcome(o_3_XX_)).
reading(risk,outcome(o_2_XX_)).
reading(outcome_helps,relation(outcome(o_2_XX_),resource(r_1_XX_))).
=======
reading(bad,outcome(o_1_XX_)).
=======
reading(bad,outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
reading(bad,outcome(o_5_XX_)).
reading(bad,outcome(o_3_XX_)).
reading(bad,outcome(o_2_XX_)).
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f
reading(good,outcome(o_4_XX_)).
reading(hand_eye_coordination,game).
reading(risk_reward,control_event(button(mouse,pressed))).
reading(maintenance,resource(r_1_XX_)).
reading(consts,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_hurts,relation(outcome(click_to_spin_entity_e_1_XX__XX__XX_),resource(r_1_XX_))).
reading(risk,outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
reading(outcome_helps,relation(outcome(o_4_XX_),resource(r_1_XX_))).
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0
==========
<ul>
<li>games/lecture_1.lp</li>
<li>The goal is to produce concentration</li>
<li>The player controls the game by<ul>
<li>
<<<<<<< HEAD
	clicking on a [[blue|circle]]
=======
	clicking on a [[blue|triangle]]
</li>
<li>
	pressing the mouse button
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0
</li>
<li>
	holding the mouse button
</li>
</ul></ul>
