label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),concentration,write).
label(entity(e_2_XX_),e(2)).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

<<<<<<< HEAD
<<<<<<< HEAD
initialize(add(entity(e_1_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
=======
=======
initialize(set_draggable(entity(e_1_XX_),true)).
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f
initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,right))).
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

<<<<<<< HEAD
pool(entity(e_1_XX_),location(top,left),ordered,ordered).
pool(entity(e_1_XX_),location(top,center),ordered,ordered).
pool(entity(e_1_XX_),location(top,right),ordered,ordered).
pool(entity(e_1_XX_),location(middle,left),ordered,ordered).
pool(entity(e_1_XX_),location(middle,center),ordered,ordered).
pool(entity(e_1_XX_),location(middle,right),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,center),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,right),ordered,ordered).
pool(entity(e_2_XX_),location(top,left),ordered,ordered).
pool(entity(e_2_XX_),location(top,center),ordered,ordered).
pool(entity(e_2_XX_),location(top,right),ordered,ordered).
pool(entity(e_2_XX_),location(middle,left),ordered,ordered).
pool(entity(e_2_XX_),location(middle,center),ordered,ordered).
pool(entity(e_2_XX_),location(middle,right),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,center),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,right),ordered,ordered).
=======
controlLogic(draggable(entity(e_1_XX_))).

pool(entity(e_1_XX_),location(top,center),random,random).
pool(entity(e_1_XX_),location(top,right),random,random).
pool(entity(e_1_XX_),location(middle,left),random,random).
pool(entity(e_1_XX_),location(middle,center),random,random).
pool(entity(e_1_XX_),location(middle,right),random,random).
pool(entity(e_1_XX_),location(bottom,left),random,random).
pool(entity(e_1_XX_),location(bottom,center),random,random).
pool(entity(e_1_XX_),location(bottom,right),random,random).
pool(entity(e_2_XX_),location(top,center),ordered,random).
pool(entity(e_2_XX_),location(top,right),ordered,random).
pool(entity(e_2_XX_),location(middle,left),ordered,random).
pool(entity(e_2_XX_),location(middle,center),ordered,random).
pool(entity(e_2_XX_),location(middle,right),ordered,random).
pool(entity(e_2_XX_),location(bottom,center),ordered,random).
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(9))).

<<<<<<< HEAD
<<<<<<< HEAD
precondition(control_event(click(entity(e_1_XX_))),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase(resource(r_1_XX_),scalar(8))).
result(outcome(o_1_XX_),delete(entity(e_1_XX_))).
=======
precondition(control_event(button(mouse,held)),outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),rotates(entity(e_1_XX_),cw,scalar(5))).

precondition(timer_elapsed(t_1_XX_),outcome(o_1_XX_)).
result(outcome(o_1_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0

precondition(ge(resource(r_1_XX_),scalar(4)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),moves(entity(e_2_XX_),left,scalar(5))).
result(outcome(o_2_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

precondition(control_event(button(mouse,pressed)),outcome(o_3_XX_)).
<<<<<<< HEAD
=======
result(outcome(o_3_XX_),decrease(property(entity(e_2_XX_),health),scalar(1))).
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0
result(outcome(o_3_XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(o_3_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),mode_change(game_loss)).

<<<<<<< HEAD
precondition(le(resource(r_1_XX_),scalar(4)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),moves(entity(e_2_XX_),right,scalar(3))).
result(outcome(o_5_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).
=======
precondition(control_event(click(entity(e_2_XX_))),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase(resource(r_1_XX_),scalar(4))).

precondition(ge(distance(entity(e_2_XX_),entity(e_1_XX_),nearest),scalar(240)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase_over_time(resource(r_1_XX_),scalar(8))).
result(outcome(o_2_XX_),moves(entity(e_2_XX_),forward,scalar(7))).
result(outcome(o_2_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

precondition(control_event(button(mouse,pressed)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(resource(r_1_XX_),scalar(1))).

precondition(le(distance(entity(e_2_XX_),entity(e_1_XX_),nearest),scalar(240)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),decrease_over_time(resource(r_1_XX_),scalar(1))).
result(outcome(o_4_XX_),moves(entity(e_2_XX_),backward,scalar(3))).
result(outcome(o_4_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),mode_change(game_loss)).
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f

=======
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0
precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,decrease_over_time(property(entity(e_1_XX_),health),scalar(6))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
<<<<<<< HEAD
<<<<<<< HEAD
result(tick,moves(entity(e_1_XX_),right,scalar(3))).
result(tick,look_at(entity(e_1_XX_),entity(e_2_XX_),nearest)).
=======
result(tick,moves(entity(e_2_XX_),forward,scalar(3))).
result(tick,moves(entity(e_1_XX_),forward,scalar(5))).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0
=======
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(pool(entity(e_1_XX_)),entity(e_1_XX_))).
reading(bad,tick).
reading(bad,outcome(o_4_XX_)).
reading(bad,outcome(o_3_XX_)).
<<<<<<< HEAD
=======
reading(good,outcome(o_2_XX_)).
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f
reading(good,outcome(o_1_XX_)).
reading(hand_eye_coordination,game).
reading(risk_reward,control_event(button(mouse,pressed))).
reading(maintenance,resource(r_1_XX_)).
<<<<<<< HEAD
reading(consts,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(costs,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_hurts,relation(outcome(o_3_XX_),resource(r_1_XX_))).
reading(risk,outcome(o_3_XX_)).
reading(risk,outcome(o_1_XX_)).
=======
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_hurts,relation(outcome(o_3_XX_),resource(r_1_XX_))).
reading(risk,outcome(o_3_XX_)).
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f
reading(outcome_helps,relation(outcome(o_1_XX_),resource(r_1_XX_))).
==========
<ul>
<li>games/lecture_7.lp</li>
<li>The goal is to produce concentration</li>
<li>The player controls the game by<ul>
<li>
<<<<<<< HEAD
<<<<<<< HEAD
	clicking on a [[red|circle]]
=======
	clicking on a [[blue|triangle]]
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0
=======
	clicking-and-dragging [[red|triangle]]s
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f
</li>
<li>
	clicking on a [[blue|triangle]]
</li>
<<<<<<< HEAD
=======
<li>
	pressing the mouse button
</li>
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f
</ul></ul>
