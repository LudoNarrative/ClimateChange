label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),concentration,write).
label(entity(e_2_XX_),e(2)).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(set_draggable(entity(e_1_XX_),true)).
initialize(set_draggable(entity(e_2_XX_),true)).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

controlLogic(draggable(entity(e_1_XX_))).
controlLogic(draggable(entity(e_2_XX_))).

pool(entity(e_2_XX_),location(top,center),random,random).
pool(entity(e_2_XX_),location(top,right),random,random).
pool(entity(e_2_XX_),location(middle,center),random,random).
pool(entity(e_2_XX_),location(middle,right),random,random).
pool(entity(e_2_XX_),location(bottom,left),random,random).
pool(entity(e_2_XX_),location(bottom,center),random,random).
pool(entity(e_2_XX_),location(bottom,right),random,random).
pool(entity(e_1_XX_),location(top,left),ordered,ordered).
pool(entity(e_1_XX_),location(top,center),ordered,ordered).
pool(entity(e_1_XX_),location(top,right),ordered,ordered).
pool(entity(e_1_XX_),location(middle,left),ordered,ordered).
pool(entity(e_1_XX_),location(middle,center),ordered,ordered).
pool(entity(e_1_XX_),location(middle,right),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,right),ordered,ordered).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(10))).

precondition(control_event(button(mouse,pressed)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease(property(entity(e_1_XX_),health),scalar(2))).
result(outcome(o_1_XX_),decrease(property(entity(e_2_XX_),health),scalar(4))).
result(outcome(o_1_XX_),increase(property(entity(e_1_XX_),health),scalar(4))).
result(outcome(o_1_XX_),increase(property(entity(e_2_XX_),health),scalar(6))).
result(outcome(o_1_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).

precondition(overlaps(entity(e_1_XX_),entity(e_1_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),decrease(property(entity(e_2_XX_),health),scalar(10))).
result(outcome(o_2_XX_),increase(property(entity(e_2_XX_),health),scalar(3))).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(4))).
result(outcome(o_2_XX_),delete(entity(e_1_XX_))).

precondition(overlaps(entity(e_2_XX_),entity(e_2_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(property(entity(e_1_XX_),health),scalar(2))).
result(outcome(o_3_XX_),increase(property(entity(e_1_XX_),health),scalar(8))).
result(outcome(o_3_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).
result(outcome(o_3_XX_),delete(entity(e_2_XX_))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),mode_change(game_loss)).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(pool(entity(e_1_XX_)),entity(e_1_XX_))).
reading(produces,relation(entity(e_1_XX_),property(entity(e_2_XX_),health))).
reading(produces,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(produces,relation(entity(e_2_XX_),property(entity(e_1_XX_),health))).
reading(consumes,relation(entity(e_1_XX_),property(entity(e_2_XX_),health))).
reading(consumes,relation(entity(e_2_XX_),property(entity(e_1_XX_),health))).
reading(bad,outcome(o_2_XX_)).
reading(bad,tick).
reading(good,outcome(o_3_XX_)).
reading(good,outcome(o_2_XX_)).
reading(good,entity(e_1_XX_)).
reading(good,pool(entity(e_1_XX_))).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_1_XX_),entity(e_1_XX_))).
reading(costs,relation(entity(e_1_XX_),property(entity(e_1_XX_),health))).
reading(costs,relation(entity(e_2_XX_),property(entity(e_1_XX_),health))).
reading(costs,relation(entity(e_2_XX_),property(entity(e_2_XX_),health))).
reading(risk_reward,overlaps(entity(e_1_XX_),entity(e_1_XX_),true)).
reading(risk_reward,overlaps(entity(e_1_XX_))).
reading(tradeoff,outcome(o_2_XX_)).
reading(stakes(low),resource(r_1_XX_)).
==========
<ul>
<li>games/lecture_attractMode_26.lp</li>
<li>GOAL:<ul>
<li>Produce concentration</li>
</ul></li>

<li>SUBGOALS:<ul>
<li>
attempting to make a [[blue|triangle]] and [[blue|triangle]] touch
</li>
</ul></li>
<li>CONTROLS:<ul>
</ul></ul>
