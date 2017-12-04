label(entity(e_1_XX_),e1).
label(entity(e_2_XX_),e(2)).
label(resource(r_1_XX_),r(1),private).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).

singular(entity(e_2_XX_)).

many(entity(e_1_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,center))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

pool(entity(e_1_XX_),location(top,left),random,random).
pool(entity(e_1_XX_),location(top,center),random,random).
pool(entity(e_1_XX_),location(top,right),random,random).
pool(entity(e_1_XX_),location(middle,center),random,random).
pool(entity(e_1_XX_),location(middle,right),random,random).
pool(entity(e_1_XX_),location(bottom,left),random,random).
pool(entity(e_1_XX_),location(bottom,right),random,random).
pool(entity(e_2_XX_),location(top,left),random,random).
pool(entity(e_2_XX_),location(top,center),random,random).
pool(entity(e_2_XX_),location(top,right),random,random).
pool(entity(e_2_XX_),location(middle,center),random,random).
pool(entity(e_2_XX_),location(middle,right),random,random).
pool(entity(e_2_XX_),location(bottom,center),random,random).
pool(entity(e_2_XX_),location(bottom,right),random,random).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(5))).

precondition(control_event(button(mouse,held)),outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),rotates(entity(e_1_XX_),ccw,scalar(1))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase(resource(r_1_XX_),scalar(4))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_2_XX_)).
precondition(le(amount(blue),scalar(1)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),mode_change(game_loss)).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(resource(r_1_XX_),scalar(1))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,clear(entity(e_2_XX_))).
result(tick,draw(entity(e_1_XX_),blue)).
result(tick,draw(entity(e_2_XX_),blue)).
result(tick,moves(entity(e_1_XX_),forward,scalar(5))).
result(tick,moves(entity(e_2_XX_),right,scalar(3))).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(bad,outcome(o_3_XX_)).
reading(good,outcome(o_1_XX_)).
reading(hand_eye_coordination,game).
reading(risk_reward,control_event(button(mouse,pressed))).
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_hurts,relation(outcome(o_3_XX_),resource(r_1_XX_))).
reading(risk,outcome(o_3_XX_)).
reading(risk,outcome(o_1_XX_)).
==========
<ul>
<li>games/lecture_drawMode_5.lp</li>
<li>The goal is to produce r(1)</li>
<li>The player controls the game by<ul>
<li>
	clicking on a [[red|triangle]]
</li>
<li>
	clicking on a [[blue|triangle]]
</li>
<li>
	pressing the mouse button
</li>
<li>
	holding the mouse button
</li>
</ul></ul>
