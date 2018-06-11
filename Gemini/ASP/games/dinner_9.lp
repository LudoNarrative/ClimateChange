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
initialize(set_draggable(entity(e_1_XX_),true)).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

controlLogic(draggable(entity(e_1_XX_))).

timer_logic(timer(behavior_condition_polarity_entity_e_2_XX__XX__X_wander_X_tick_XX_),scalar(5),loop).

pool(entity(e_1_XX_),location(top,left),random,random).
pool(entity(e_1_XX_),location(top,center),random,random).
pool(entity(e_1_XX_),location(top,right),random,random).
pool(entity(e_1_XX_),location(middle,left),random,random).
pool(entity(e_1_XX_),location(middle,center),random,random).
pool(entity(e_1_XX_),location(middle,right),random,random).
pool(entity(e_1_XX_),location(bottom,left),random,random).
pool(entity(e_1_XX_),location(bottom,center),random,random).
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

initialize(set_value(resource(r_1_XX_),scalar(8))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase(resource(r_1_XX_),scalar(24))).
result(outcome(o_1_XX_),delete(entity(e_1_XX_))).

precondition(timer_elapsed(behavior_condition_polarity_entity_e_2_XX__XX__X_wander_X_tick_XX_),outcome(o_2_XX_)).
result(outcome(o_2_XX_),rotate_to(entity(e_2_XX_),random_int(scalar(0),scalar(360)))).

precondition(control_event(button(mouse,held)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease_over_time(property(entity(e_1_XX_),health),scalar(0))).
result(outcome(o_3_XX_),increase_over_time(property(entity(e_1_XX_),health),scalar(5))).

precondition(le(resource(r_1_XX_),scalar(2)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),mode_change(narrative_gating)).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_5_XX_)).
result(outcome(o_5_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
result(tick,moves(entity(e_2_XX_),forward,scalar(5))).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(pool(entity(e_1_XX_)),entity(e_1_XX_))).
reading(produces,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(produces,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(bad,outcome(o_1_XX_)).
reading(bad,tick).
reading(good,outcome(o_5_XX_)).
reading(good,outcome(o_1_XX_)).
reading(bad,entity(e_2_XX_)).
reading(good,entity(e_1_XX_)).
reading(good,entity(e_2_XX_)).
reading(good,pool(entity(e_1_XX_))).
reading(sharing,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(difficulty,5).
reading(risk_reward,overlaps(entity(e_1_XX_),entity(e_2_XX_),true)).
reading(risk_reward,overlaps(entity(e_1_XX_))).
reading(risk_reward,overlaps(entity(e_2_XX_))).
reading(hand_eye_coordination,game).
reading(tradeoff,outcome(o_1_XX_)).
reading(tradeoff,entity(e_2_XX_)).
reading(maintenance,resource(r_1_XX_)).
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_helps,relation(outcome(o_1_XX_),resource(r_1_XX_))).
==========
<ul>
<li>games/dinner_9.lp</li>
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
