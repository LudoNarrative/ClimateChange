label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),concentration,write).
label(entity(e_2_XX_),e(2)).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).

singular(entity(e_1_XX_)).

many(entity(e_2_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

pool(entity(e_1_XX_),location(top,left),random,ordered).
pool(entity(e_1_XX_),location(top,center),random,ordered).
pool(entity(e_1_XX_),location(top,right),random,ordered).
pool(entity(e_1_XX_),location(middle,left),random,ordered).
pool(entity(e_1_XX_),location(middle,center),random,ordered).
pool(entity(e_1_XX_),location(bottom,left),random,ordered).
pool(entity(e_1_XX_),location(bottom,center),random,ordered).
pool(entity(e_2_XX_),location(top,left),ordered,ordered).
pool(entity(e_2_XX_),location(top,center),ordered,ordered).
pool(entity(e_2_XX_),location(middle,left),ordered,ordered).
pool(entity(e_2_XX_),location(middle,right),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,center),ordered,ordered).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(9))).

precondition(control_event(button(mouse,held)),outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),forward,scalar(7))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(game_loss)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(4))).
result(outcome(o_2_XX_),add(entity(e_2_XX_),resource(r_1_XX_),pool(entity(e_2_XX_)))).
result(outcome(o_2_XX_),delete(entity(e_2_XX_))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_3_XX_)).
result(outcome(o_3_XX_),increase(resource(r_1_XX_),scalar(4))).
result(outcome(o_3_XX_),delete(entity(e_2_XX_))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_4_XX_)).
result(outcome(o_4_XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(o_4_XX_),add(entity(e_2_XX_),resource(r_1_XX_),pool(entity(e_2_XX_)))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
result(tick,moves(entity(e_2_XX_),right,scalar(3))).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(pool(entity(e_2_XX_)),entity(e_2_XX_))).
reading(produces,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(bad,tick).
reading(bad,outcome(o_4_XX_)).
reading(good,outcome(o_3_XX_)).
reading(good,outcome(o_2_XX_)).
reading(hand_eye_coordination,game).
reading(risk_reward,control_event(button(mouse,pressed))).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_2_XX_),player)).
reading(hurt,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(difficulty,3).
reading(difficulty,resource(r_1_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_helps,relation(outcome(o_3_XX_),resource(r_1_XX_))).
==========
<ul>
<li>games/lecture_attract_9.lp</li>
<li>The goal is to produce concentration</li>
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
