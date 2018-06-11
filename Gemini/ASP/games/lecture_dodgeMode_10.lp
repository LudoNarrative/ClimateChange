label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),concentration,write).
label(entity(e_2_XX_),e(2)).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).

singular(entity(e_2_XX_)).

many(entity(e_1_XX_)).

initialize(set_draggable(entity(e_1_XX_),true)).
initialize(fill(all,clear)).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,center))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

controlLogic(draggable(entity(e_1_XX_))).

pool(entity(e_1_XX_),location(top,left),random,random).
pool(entity(e_1_XX_),location(top,center),random,random).
pool(entity(e_1_XX_),location(top,right),random,random).
pool(entity(e_1_XX_),location(middle,center),random,random).
pool(entity(e_1_XX_),location(bottom,left),random,random).
pool(entity(e_1_XX_),location(bottom,right),random,random).
pool(entity(e_2_XX_),location(top,left),ordered,ordered).
pool(entity(e_2_XX_),location(top,center),ordered,ordered).
pool(entity(e_2_XX_),location(top,right),ordered,ordered).
pool(entity(e_2_XX_),location(middle,center),ordered,ordered).
pool(entity(e_2_XX_),location(middle,right),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,center),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,right),ordered,ordered).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(9))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(game_loss)).

precondition(control_event(button(mouse,pressed)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),decrease(property(entity(e_1_XX_),health),scalar(9))).
result(outcome(o_2_XX_),increase(property(entity(e_1_XX_),health),scalar(4))).

precondition(control_event(button(mouse,held)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease_over_time(property(entity(e_1_XX_),health),scalar(10))).
result(outcome(o_3_XX_),increase_over_time(property(entity(e_1_XX_),health),scalar(2))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_4_XX_)).
result(outcome(o_4_XX_),increase(resource(r_1_XX_),scalar(8))).
result(outcome(o_4_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_5_XX_)).
result(outcome(o_5_XX_),increase(resource(r_1_XX_),scalar(4))).
result(outcome(o_5_XX_),delete(entity(e_1_XX_))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
result(tick,moves(entity(e_2_XX_),left,scalar(5))).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(pool(entity(e_1_XX_)),entity(e_1_XX_))).
reading(produces,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(produces,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(bad,tick).
reading(bad,outcome(o_5_XX_)).
reading(good,outcome(o_5_XX_)).
reading(good,outcome(o_4_XX_)).
reading(good,entity(e_1_XX_)).
reading(good,entity(e_2_XX_)).
reading(good,pool(entity(e_1_XX_))).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_2_XX_),player)).
reading(hurt,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(dodge,entity(e_2_XX_)).
reading(survive,entity(e_2_XX_)).
reading(difficulty,5).
reading(risk_reward,overlaps(entity(e_1_XX_),entity(e_2_XX_),true)).
reading(risk_reward,overlaps(entity(e_1_XX_))).
reading(risk_reward,overlaps(entity(e_2_XX_))).
reading(tradeoff,outcome(o_5_XX_)).
reading(stakes(low),resource(r_1_XX_)).
==========
<ul>
<li>games/lecture_dodgeMode_10.lp</li>
<li>GOAL:<ul>
<li>Produce concentration</li>
</ul></li>

<li>SUBGOALS:<ul>
<li>
	clicking on a [[blue|triangle]]
</li>
</ul></li>
<li>CONTROLS:<ul>
</ul></ul>
