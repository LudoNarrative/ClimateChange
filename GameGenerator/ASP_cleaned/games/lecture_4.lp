label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),concentration,write).
label(entity(e_2_XX_),e(2)).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

<<<<<<< HEAD
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
=======
initialize(add(entity(e_1_XX_),scalar(1),location(middle,left))).
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0
initialize(add(entity(e_1_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,center))).
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
timer_logic(timer(t_1_XX_),scalar(3),loop).
timer_logic(timer(t_2_XX_),scalar(5),loop).
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(6))).

<<<<<<< HEAD
precondition(le(resource(r_1_XX_),scalar(4)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),moves(entity(e_2_XX_),forward,scalar(7))).
result(outcome(o_1_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).
=======
initialize(set_value(resource(r_1_XX_),scalar(10))).

precondition(timer_elapsed(t_1_XX_),outcome(o_1_XX_)).
result(outcome(o_1_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_2_XX_)).
precondition(timer_elapsed(t_2_XX_),outcome(o_2_XX_)).
result(outcome(o_2_XX_),mode_change(game_loss)).

precondition(control_event(button(mouse,pressed)),outcome(o_3_XX_)).
<<<<<<< HEAD
result(outcome(o_3_XX_),decrease(resource(r_1_XX_),scalar(1))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_4_XX_)).
result(outcome(o_4_XX_),increase(resource(r_1_XX_),scalar(12))).

precondition(ge(resource(r_1_XX_),scalar(4)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),moves(entity(e_2_XX_),backward,scalar(3))).
result(outcome(o_5_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).
=======
result(outcome(o_3_XX_),decrease(property(entity(e_2_XX_),health),scalar(9))).
result(outcome(o_3_XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(o_3_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_4_XX_)).
result(outcome(o_4_XX_),increase(resource(r_1_XX_),scalar(4))).
result(outcome(o_4_XX_),delete(entity(e_2_XX_))).
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
<<<<<<< HEAD
result(tick,moves(entity(e_1_XX_),right,scalar(3))).
result(tick,look_at(entity(e_1_XX_),entity(e_2_XX_),nearest)).
=======
result(tick,moves(entity(e_2_XX_),forward,scalar(3))).
result(tick,moves(entity(e_1_XX_),backward,scalar(3))).
result(tick,look_at(entity(e_1_XX_),entity(e_2_XX_),nearest)).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(bad,tick).
reading(bad,outcome(o_3_XX_)).
reading(good,outcome(o_4_XX_)).
reading(hand_eye_coordination,game).
reading(risk_reward,control_event(button(mouse,pressed))).
reading(maintenance,resource(r_1_XX_)).
<<<<<<< HEAD
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_hurts,relation(outcome(o_3_XX_),resource(r_1_XX_))).
reading(risk,outcome(o_4_XX_)).
reading(risk,outcome(o_3_XX_)).
reading(outcome_helps,relation(outcome(o_4_XX_),resource(r_1_XX_))).
=======
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0
==========
<ul>
<li>games/lecture_4.lp</li>
<li>The goal is to produce concentration</li>
<li>The player controls the game by<ul>
<li>
<<<<<<< HEAD
	clicking on a [[red|circle]]
=======
	clicking on a [[blue|triangle]]
>>>>>>> 1213359cf8fe97f566fee4eecc1aefdf6ca468b0
</li>
<li>
	pressing the mouse button
</li>
</ul></ul>
