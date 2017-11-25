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
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,right))).
=======
=======
initialize(set_draggable(entity(e_1_XX_),true)).
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f
initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
<<<<<<< HEAD
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0
=======
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

<<<<<<< HEAD
timer_logic(timer(t_1_XX_),scalar(7),loop).

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

<<<<<<< HEAD
boundary(closed).
=======
initialize(set_value(resource(r_1_XX_),scalar(10))).
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0

initialize(set_value(resource(r_1_XX_),scalar(6))).
=======
controlLogic(draggable(entity(e_1_XX_))).

pool(entity(e_1_XX_),location(top,center),random,random).
pool(entity(e_1_XX_),location(middle,left),random,random).
pool(entity(e_1_XX_),location(middle,center),random,random).
pool(entity(e_1_XX_),location(bottom,left),random,random).
pool(entity(e_1_XX_),location(bottom,center),random,random).
pool(entity(e_1_XX_),location(bottom,right),random,random).
pool(entity(e_2_XX_),location(top,left),ordered,random).
pool(entity(e_2_XX_),location(top,right),ordered,random).
pool(entity(e_2_XX_),location(middle,left),ordered,random).
pool(entity(e_2_XX_),location(middle,center),ordered,random).
pool(entity(e_2_XX_),location(bottom,left),ordered,random).
pool(entity(e_2_XX_),location(bottom,right),ordered,random).

boundary(torus).

initialize(set_value(resource(r_1_XX_),scalar(6))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase(resource(r_1_XX_),scalar(4))).
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f

precondition(ge(distance(entity(e_2_XX_),entity(e_1_XX_),nearest),scalar(240)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase_over_time(resource(r_1_XX_),scalar(16))).
result(outcome(o_2_XX_),moves(entity(e_2_XX_),forward,scalar(7))).
result(outcome(o_2_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

<<<<<<< HEAD
<<<<<<< HEAD
precondition(control_event(click(entity(e_2_XX_))),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(12))).
result(outcome(o_2_XX_),delete(entity(e_2_XX_))).

precondition(control_event(button(mouse,held)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),increase_over_time(property(entity(e_2_XX_),health),scalar(4))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_4_XX_)).
precondition(timer_elapsed(t_1_XX_),outcome(o_4_XX_)).
result(outcome(o_4_XX_),mode_change(game_loss)).
=======
precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),decrease_over_time(resource(r_1_XX_),scalar(1))).
=======
precondition(control_event(button(mouse,pressed)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(resource(r_1_XX_),scalar(1))).
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f

precondition(le(distance(entity(e_2_XX_),entity(e_1_XX_),nearest),scalar(240)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),decrease_over_time(resource(r_1_XX_),scalar(1))).
result(outcome(o_4_XX_),moves(entity(e_2_XX_),backward,scalar(5))).
result(outcome(o_4_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

<<<<<<< HEAD
precondition(control_event(click(entity(e_2_XX_))),outcome(o_4_XX_)).
result(outcome(o_4_XX_),increase(resource(r_1_XX_),scalar(12))).
result(outcome(o_4_XX_),delete(entity(e_2_XX_))).
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0
=======
precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),mode_change(game_loss)).
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,decrease_over_time(property(entity(e_2_XX_),health),scalar(2))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
<<<<<<< HEAD
<<<<<<< HEAD
result(tick,moves(entity(e_2_XX_),left,scalar(3))).
result(tick,moves(entity(e_1_XX_),left,scalar(5))).
result(tick,look_at(entity(e_1_XX_),entity(e_2_XX_),nearest)).
=======
result(tick,moves(entity(e_2_XX_),forward,scalar(5))).
result(tick,moves(entity(e_1_XX_),forward,resource(r_1_XX_))).
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
<<<<<<< HEAD
reading(produces,relation(pool(entity(e_2_XX_)),entity(e_2_XX_))).
=======
reading(consumes,relation(entity(e_1_XX_),resource(r_1_XX_))).
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0
reading(bad,tick).
reading(bad,outcome(o_2_XX_)).
reading(bad,outcome(o_1_XX_)).
reading(good,outcome(o_2_XX_)).
reading(hand_eye_coordination,game).
reading(risk_reward,control_event(button(mouse,pressed))).
reading(maintenance,resource(r_1_XX_)).
<<<<<<< HEAD
reading(consts,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(costs,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_hurts,relation(outcome(o_1_XX_),resource(r_1_XX_))).
reading(risk,outcome(o_2_XX_)).
reading(risk,outcome(o_1_XX_)).
reading(outcome_helps,relation(outcome(o_2_XX_),resource(r_1_XX_))).
=======
reading(outcome_hurts,relation(outcome(o_2_XX_),resource(r_1_XX_))).
reading(outcome_hurts,relation(outcome(o_1_XX_),resource(r_1_XX_))).
reading(risk,outcome(o_2_XX_)).
reading(outcome_helps,relation(outcome(o_4_XX_),resource(r_1_XX_))).
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0
=======

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(bad,tick).
reading(bad,outcome(o_4_XX_)).
reading(bad,outcome(o_3_XX_)).
reading(good,outcome(o_2_XX_)).
reading(good,outcome(o_1_XX_)).
reading(hand_eye_coordination,game).
reading(risk_reward,control_event(button(mouse,pressed))).
reading(maintenance,resource(r_1_XX_)).
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_hurts,relation(outcome(o_3_XX_),resource(r_1_XX_))).
reading(outcome_helps,relation(outcome(o_1_XX_),resource(r_1_XX_))).
>>>>>>> 358cb85a7df139284c84fc7e7a7a8bd97310283f
==========
<ul>
<li>games/lecture_3.lp</li>
<li>The goal is to produce concentration</li>
<li>The player controls the game by<ul>
<li>
	clicking-and-dragging [[red|triangle]]s
</li>
<li>
	clicking on a [[blue|triangle]]
</li>
<li>
	pressing the mouse button
</li>
</ul></ul>
