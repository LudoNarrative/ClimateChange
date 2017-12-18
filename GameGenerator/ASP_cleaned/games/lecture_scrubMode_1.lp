label(entity(e_1_XX_),e1).
label(entity(e_2_XX_),e(2)).
label(resource(r_1_XX_),r(1),private).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).

singular(entity(e_2_XX_)).

many(entity(e_1_XX_)).

initialize(fill(all,blue)).
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

initialize(set_value(resource(r_1_XX_),scalar(2))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_1_XX_)).
result(outcome(o_1_XX_),clear(entity(e_1_XX_))).
result(outcome(o_1_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

precondition(ge(amount(blue),scalar(9)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),mode_change(game_loss)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),delete(entity(e_1_XX_))).

precondition(control_event(button(mouse,held)),outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),clear(entity(e_1_XX_))).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),draw(entity(e_2_XX_),blue)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),backward,resource(r_1_XX_))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,decrease_over_time(property(entity(e_1_XX_),health),scalar(10))).
result(tick,increase_over_time(property(entity(e_1_XX_),health),scalar(10))).
result(tick,clear(cursor)).
result(tick,clear(entity(e_1_XX_))).
result(tick,set_value(resource(r_1_XX_),amount(blue))).
result(tick,draw(cursor,blue)).
result(tick,draw(entity(e_2_XX_),blue)).
result(tick,moves(entity(e_2_XX_),right,scalar(5))).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

reading(consumes,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(goal(reduce),blue).
reading(bad,blue).
reading(bad,tick).
reading(bad,outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_)).
reading(good,tick).
reading(good,outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_)).
reading(good,outcome(o_1_XX_)).
reading(hand_eye_coordination,game).
reading(risk_reward,control_event(button(mouse,held))).
reading(risk_reward,tick).
reading(tradeoff,tick).
reading(tradeoff,outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_)).
==========
<ul>
<li>games/lecture_scrubMode_1.lp</li>
<li>GOAL:</li>
<li>Reduce blue</li>

<li>SUBGOALS:<ul>
<li>
	clicking on a [[blue|triangle]]
</li>
</ul></li>
<li>CONTROLS:<ul>
<li>	controlling [[red|triangle]] by making it flee the cursor 
by holding the mouse button
</li>
</ul></ul>
