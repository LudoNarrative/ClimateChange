label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),concentration,write).
label(entity(e_2_XX_),e(2)).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(set_draggable(entity(e_1_XX_),true)).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

controlLogic(draggable(entity(e_1_XX_))).

pool(entity(e_2_XX_),location(top,left),random,random).
pool(entity(e_2_XX_),location(top,center),random,random).
pool(entity(e_2_XX_),location(top,right),random,random).
pool(entity(e_2_XX_),location(middle,left),random,random).
pool(entity(e_2_XX_),location(middle,center),random,random).
pool(entity(e_2_XX_),location(middle,right),random,random).
pool(entity(e_2_XX_),location(bottom,left),random,random).
pool(entity(e_2_XX_),location(bottom,center),random,random).
pool(entity(e_2_XX_),location(bottom,right),random,random).
pool(entity(e_1_XX_),location(top,left),ordered,random).
pool(entity(e_1_XX_),location(top,center),ordered,random).
pool(entity(e_1_XX_),location(top,right),ordered,random).
pool(entity(e_1_XX_),location(middle,left),ordered,random).
pool(entity(e_1_XX_),location(middle,center),ordered,random).
pool(entity(e_1_XX_),location(middle,right),ordered,random).
pool(entity(e_1_XX_),location(bottom,left),ordered,random).
pool(entity(e_1_XX_),location(bottom,center),ordered,random).
pool(entity(e_1_XX_),location(bottom,right),ordered,random).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(4))).

precondition(le(distance(entity(e_2_XX_),entity(e_1_XX_),nearest),scalar(120)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),moves(entity(e_2_XX_),right,scalar(3))).
result(outcome(o_1_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

precondition(overlaps(entity(e_1_XX_),entity(e_1_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(28))).
result(outcome(o_2_XX_),delete(entity(e_1_XX_))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_3_XX_)).
result(outcome(o_3_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),mode_change(game_loss)).

precondition(ge(distance(entity(e_2_XX_),entity(e_1_XX_),nearest),scalar(120)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),moves(entity(e_2_XX_),backward,scalar(7))).
result(outcome(o_5_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(pool(entity(e_1_XX_)),entity(e_1_XX_))).
reading(produces,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(bad,tick).
reading(bad,outcome(o_2_XX_)).
reading(good,outcome(o_3_XX_)).
reading(good,outcome(o_2_XX_)).
reading(good,entity(e_1_XX_)).
reading(good,pool(entity(e_1_XX_))).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_1_XX_)).
reading(difficulty,3).
reading(difficulty,7).
reading(risk_reward,overlaps(entity(e_1_XX_),entity(e_1_XX_),true)).
reading(risk_reward,overlaps(entity(e_1_XX_))).
reading(tradeoff,outcome(o_2_XX_)).
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_helps,relation(outcome(o_2_XX_),resource(r_1_XX_))).
==========
<ul>
<li>games/lecture_dodgeMode_14.lp</li>
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
