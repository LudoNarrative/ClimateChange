label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),concentration,write).
label(entity(e_2_XX_),e(2)).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,center))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

timer_logic(timer(t_1_XX_),scalar(3),loop).
timer_logic(timer(t_2_XX_),scalar(5),loop).

pool(entity(e_1_XX_),location(top,left),ordered,random).
pool(entity(e_1_XX_),location(top,center),ordered,random).
pool(entity(e_1_XX_),location(top,right),ordered,random).
pool(entity(e_1_XX_),location(middle,left),ordered,random).
pool(entity(e_1_XX_),location(middle,center),ordered,random).
pool(entity(e_1_XX_),location(middle,right),ordered,random).
pool(entity(e_1_XX_),location(bottom,left),ordered,random).
pool(entity(e_1_XX_),location(bottom,center),ordered,random).
pool(entity(e_1_XX_),location(bottom,right),ordered,random).
pool(entity(e_2_XX_),location(top,left),ordered,ordered).
pool(entity(e_2_XX_),location(top,center),ordered,ordered).
pool(entity(e_2_XX_),location(top,right),ordered,ordered).
pool(entity(e_2_XX_),location(middle,left),ordered,ordered).
pool(entity(e_2_XX_),location(middle,center),ordered,ordered).
pool(entity(e_2_XX_),location(middle,right),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,center),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,right),ordered,ordered).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(6))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(game_loss)).

precondition(timer_elapsed(t_1_XX_),outcome(o_2_XX_)).
result(outcome(o_2_XX_),decrease(resource(r_1_XX_),scalar(1))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_3_XX_)).
result(outcome(o_3_XX_),increase(resource(r_1_XX_),scalar(4))).

precondition(control_event(button(mouse,pressed)),outcome(o_4_XX_)).
precondition(timer_elapsed(t_2_XX_),outcome(o_4_XX_)).
result(outcome(o_4_XX_),decrease(resource(r_1_XX_),scalar(1))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,moves(entity(e_2_XX_),forward,scalar(3))).
result(tick,moves(entity(e_1_XX_),forward,resource(r_1_XX_))).
result(tick,look_at(entity(e_1_XX_),entity(e_2_XX_),furthest)).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(bad,outcome(o_4_XX_)).
reading(bad,outcome(o_2_XX_)).
reading(good,outcome(o_3_XX_)).
reading(hand_eye_coordination,game).
reading(risk_reward,control_event(button(mouse,pressed))).
reading(maintenance,resource(r_1_XX_)).
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_hurts,relation(outcome(o_4_XX_),resource(r_1_XX_))).
reading(risk,outcome(o_3_XX_)).
==========
<ul>
<li>games/lecture_38.lp</li>
<li>The goal is to produce concentration</li>
<li>The player controls the game by<ul>
<li>
	clicking on a [[red|triangle]]
</li>
<li>
	pressing the mouse button
</li>
</ul></ul>
