label(entity(e_1_XX_),food).
label(entity(e_2_XX_),friend).
label(resource(r_1_XX_),satiation,write).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
initialize(set_static(entity(e_2_XX_),true)).
initialize(set_draggable(entity(e_1_XX_),true)).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

controlLogic(draggable(entity(e_1_XX_))).

pool(entity(e_1_XX_),location(top,left),ordered,random).
pool(entity(e_1_XX_),location(top,center),ordered,random).
pool(entity(e_1_XX_),location(top,right),ordered,random).
pool(entity(e_1_XX_),location(middle,left),ordered,random).
pool(entity(e_1_XX_),location(middle,center),ordered,random).
pool(entity(e_1_XX_),location(middle,right),ordered,random).
pool(entity(e_1_XX_),location(bottom,left),ordered,random).
pool(entity(e_1_XX_),location(bottom,center),ordered,random).
pool(entity(e_1_XX_),location(bottom,right),ordered,random).
pool(entity(e_2_XX_),location(top,left),ordered,random).
pool(entity(e_2_XX_),location(top,center),ordered,random).
pool(entity(e_2_XX_),location(top,right),ordered,random).
pool(entity(e_2_XX_),location(middle,left),ordered,random).
pool(entity(e_2_XX_),location(middle,center),ordered,random).
pool(entity(e_2_XX_),location(middle,right),ordered,random).
pool(entity(e_2_XX_),location(bottom,left),ordered,random).
pool(entity(e_2_XX_),location(bottom,center),ordered,random).
pool(entity(e_2_XX_),location(bottom,right),ordered,random).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(10))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_1_XX_)).
result(outcome(o_1_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),mode_change(narrative_gating)).

precondition(le(resource(r_1_XX_),scalar(8)),outcome(o_3_XX_)).
precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),increase(resource(r_1_XX_),scalar(4))).
result(outcome(o_3_XX_),delete(entity(e_1_XX_))).

precondition(control_event(button(mouse,pressed)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),decrease(property(entity(e_1_XX_),health),scalar(10))).
result(outcome(o_4_XX_),increase(property(entity(e_1_XX_),health),scalar(10))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(pool(entity(e_1_XX_)),entity(e_1_XX_))).
reading(produces,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(produces,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(bad,outcome(o_3_XX_)).
reading(bad,tick).
reading(good,outcome(o_3_XX_)).
reading(good,outcome(o_1_XX_)).
reading(bad,entity(e_2_XX_)).
reading(good,entity(e_1_XX_)).
reading(good,entity(e_2_XX_)).
reading(good,pool(entity(e_1_XX_))).
reading(hurt,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(sharing,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(risk_reward,le(resource(r_1_XX_))).
reading(risk_reward,overlaps(entity(e_1_XX_),entity(e_2_XX_),true)).
reading(risk_reward,overlaps(entity(e_1_XX_))).
reading(risk_reward,overlaps(entity(e_2_XX_))).
reading(tradeoff,outcome(o_3_XX_)).
reading(tradeoff,entity(e_2_XX_)).
reading(maintenance,resource(r_1_XX_)).
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_helps,relation(outcome(o_3_XX_),resource(r_1_XX_))).
==========
<ul>
<li>games/dinner_8.lp</li>
<li>GOAL:<ul>
<li>Produce satiation</li>
</ul></li>

<li>SUBGOALS:<ul>
<li>
	clicking on a [[blue|triangle]]
</li>
</ul></li>
<li>CONTROLS:<ul>
</ul></ul>
