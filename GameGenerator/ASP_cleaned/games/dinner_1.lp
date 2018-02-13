label(resource(r_1_XX_),tension,write).
label(entity(e_2_XX_),friend1).
label(entity(e_3_XX_),friend2).
label(resource(r_2_XX_),activism,read_only).
label(entity(e_1_XX_),emma).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

singular(entity(e_1_XX_)).

many(entity(e_2_XX_)).
many(entity(e_3_XX_)).

initialize(set_value(resource(r_1_XX_),scalar(0))).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(middle,right))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,center))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_sprite(entity(e_3_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_3_XX_),green)).
initialize(set_draggable(entity(e_2_XX_),true)).
initialize(set_draggable(entity(e_3_XX_),true)).

controlLogic(draggable(entity(e_2_XX_))).
controlLogic(draggable(entity(e_3_XX_))).

timer_logic(timer(t_1_XX_),scalar(7),loop).

pool(entity(e_1_XX_),location(top,left),random,random).
pool(entity(e_1_XX_),location(top,center),random,random).
pool(entity(e_1_XX_),location(top,right),random,random).
pool(entity(e_1_XX_),location(middle,left),random,random).
pool(entity(e_1_XX_),location(middle,center),random,random).
pool(entity(e_1_XX_),location(middle,right),random,random).
pool(entity(e_1_XX_),location(bottom,left),random,random).
pool(entity(e_1_XX_),location(bottom,center),random,random).
pool(entity(e_1_XX_),location(bottom,right),random,random).
pool(entity(e_3_XX_),location(top,left),random,ordered).
pool(entity(e_3_XX_),location(top,center),random,ordered).
pool(entity(e_3_XX_),location(top,right),random,ordered).
pool(entity(e_3_XX_),location(middle,left),random,ordered).
pool(entity(e_3_XX_),location(middle,center),random,ordered).
pool(entity(e_3_XX_),location(middle,right),random,ordered).
pool(entity(e_3_XX_),location(bottom,left),random,ordered).
pool(entity(e_3_XX_),location(bottom,center),random,ordered).
pool(entity(e_3_XX_),location(bottom,right),random,ordered).
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

initialize(set_value(resource(r_1_XX_),scalar(0))).
initialize(set_value(resource(r_1_XX_),scalar(1))).
initialize(set_value(resource(r_2_XX_),scalar(10))).

precondition(ge(resource(r_1_XX_),scalar(9)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(narrative_gating)).

precondition(control_event(button(mouse,pressed)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),add(entity(e_3_XX_),scalar(1),pool(entity(e_3_XX_)))).
result(outcome(o_3_XX_),delete(entity(e_2_XX_))).

precondition(ge(resource(r_2_XX_),scalar(6)),outcome(o_4_XX_)).
precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_4_XX_)).
result(outcome(o_4_XX_),decrease(resource(r_1_XX_),scalar(20))).
result(outcome(o_4_XX_),delete(entity(e_3_XX_))).

precondition(timer_elapsed(t_1_XX_),outcome(o_5_XX_)).
result(outcome(o_5_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).

precondition(overlaps(entity(e_2_XX_),entity(e_3_XX_),true),outcome(o_6_XX_)).
result(outcome(o_6_XX_),decrease(property(entity(e_3_XX_),health),scalar(10))).
result(outcome(o_6_XX_),delete(entity(e_2_XX_))).

precondition(control_event(button(mouse,held)),outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),increase_over_time(resource(r_1_XX_),scalar(1))).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),left,scalar(3))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).

reading(goal(reduce),resource(r_1_XX_)).
reading(bad,resource(r_1_XX_)).
reading(consumes,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_2_XX_),property(entity(e_3_XX_),health))).
reading(consumes,relation(entity(e_3_XX_),property(entity(e_3_XX_),health))).
reading(consumes,relation(entity(e_3_XX_),resource(r_1_XX_))).
reading(bad,outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_)).
reading(bad,outcome(o_4_XX_)).
reading(good,outcome(o_4_XX_)).
reading(good,outcome(o_3_XX_)).
reading(good,entity(e_1_XX_)).
reading(good,entity(e_3_XX_)).
reading(hurt,relation(entity(e_3_XX_),entity(e_2_XX_))).
reading(hurt,relation(entity(e_2_XX_),entity(e_3_XX_))).
reading(risk_reward,ge(resource(r_2_XX_))).
reading(risk_reward,overlaps(entity(e_1_XX_),entity(e_3_XX_),true)).
reading(risk_reward,overlaps(entity(e_1_XX_))).
reading(risk_reward,overlaps(entity(e_3_XX_))).
reading(tradeoff,outcome(o_4_XX_)).
reading(stakes(low),resource(r_2_XX_)).
reading(outcome_hurts,relation(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),resource(r_1_XX_))).
reading(risk,outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_)).
==========
<ul>
<li>games/dinner_1.lp</li>
<li>GOAL:<ul>
<li>Reduce tension</li>
</ul></li>

<li>HINT:<ul>
<li>
make [[blue|triangle]] touch [[red|triangle]]
</li>
</ul></li>
<li>CONTROLS:<ul>
<li>	hold the mouse button
 to make [[red|triangle]] orbit the cursor</li>
</ul></ul>
