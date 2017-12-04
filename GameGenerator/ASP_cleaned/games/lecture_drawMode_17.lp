label(entity(e_1_XX_),e1).
label(entity(e_2_XX_),e(2)).
label(resource(r_1_XX_),r(1),private).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).

singular(entity(e_2_XX_)).

many(entity(e_1_XX_)).

initialize(set_draggable(entity(e_1_XX_),true)).
initialize(add(entity(e_1_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,center))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

controlLogic(draggable(entity(e_1_XX_))).

pool(entity(e_1_XX_),location(top,left),random,ordered).
pool(entity(e_1_XX_),location(top,center),random,ordered).
pool(entity(e_1_XX_),location(top,right),random,ordered).
pool(entity(e_1_XX_),location(bottom,left),random,ordered).
pool(entity(e_1_XX_),location(bottom,center),random,ordered).
pool(entity(e_1_XX_),location(bottom,right),random,ordered).
pool(entity(e_2_XX_),location(top,left),random,random).
pool(entity(e_2_XX_),location(top,right),random,random).
pool(entity(e_2_XX_),location(middle,left),random,random).
pool(entity(e_2_XX_),location(middle,center),random,random).
pool(entity(e_2_XX_),location(middle,right),random,random).
pool(entity(e_2_XX_),location(bottom,center),random,random).
pool(entity(e_2_XX_),location(bottom,right),random,random).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(1))).

precondition(ge(resource(r_1_XX_),scalar(8)),outcome(o_1_XX_)).
precondition(le(amount(blue),scalar(1)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(game_loss)).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_2_XX_)).
result(outcome(o_2_XX_),clear(cursor)).
result(outcome(o_2_XX_),decrease(resource(r_1_XX_),scalar(40))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_3_XX_)).
result(outcome(o_3_XX_),increase(resource(r_1_XX_),scalar(1))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,clear(entity(e_2_XX_))).
result(tick,draw(entity(e_1_XX_),blue)).
result(tick,moves(entity(e_2_XX_),left,scalar(3))).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

reading(goal(reduce),resource(r_1_XX_)).
reading(bad,resource(r_1_XX_)).
reading(bad,outcome(o_3_XX_)).
reading(good,outcome(o_2_XX_)).
reading(hand_eye_coordination,game).
reading(risk_reward,control_event(button(mouse,pressed))).
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_helps,relation(outcome(o_2_XX_),resource(r_1_XX_))).
==========
<ul>
<li>games/lecture_drawMode_2.lp</li>
<li>The goal is to reduce r(1)</li>
<li>The player controls the game by<ul>
<li>
	clicking-and-dragging [[red|triangle]]s
</li>
<li>
	clicking on a [[red|triangle]]
</li>
<li>
	clicking on a [[blue|triangle]]
</li>
<li>
	pressing the mouse button
</li>
</ul></ul>
