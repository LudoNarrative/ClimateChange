label(entity(e_1_XX_),food).
label(entity(e_2_XX_),friend).
label(resource(r_1_XX_),satiation,write).
label(resource(r_2_XX_),r(2),private).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

timer_logic(timer(patrol_entity_e_2_XX__XX__XX_),scalar(7),loop).
timer_logic(timer(pingpong_entity_e_2_XX__XX__XX_),scalar(3),loop).

pool(entity(e_1_XX_),location(top,left),random,random).
pool(entity(e_1_XX_),location(top,center),random,random).
pool(entity(e_1_XX_),location(top,right),random,random).
pool(entity(e_1_XX_),location(middle,center),random,random).
pool(entity(e_1_XX_),location(bottom,left),random,random).
pool(entity(e_1_XX_),location(bottom,center),random,random).
pool(entity(e_1_XX_),location(bottom,right),random,random).
pool(entity(e_2_XX_),location(top,left),random,ordered).
pool(entity(e_2_XX_),location(top,center),random,ordered).
pool(entity(e_2_XX_),location(top,right),random,ordered).
pool(entity(e_2_XX_),location(bottom,left),random,ordered).
pool(entity(e_2_XX_),location(bottom,center),random,ordered).
pool(entity(e_2_XX_),location(bottom,right),random,ordered).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(5))).
initialize(set_value(resource(r_2_XX_),scalar(1))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(narrative_gating)).

precondition(le(resource(r_2_XX_),scalar(6)),outcome(o_2_XX_)).
precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(2))).
result(outcome(o_2_XX_),delete(entity(e_1_XX_))).

precondition(control_event(button(mouse,pressed)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(resource(r_2_XX_),scalar(9))).
result(outcome(o_3_XX_),add(entity(e_1_XX_),resource(r_2_XX_),pool(entity(e_1_XX_)))).

precondition(control_event(button(mouse,held)),outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),increase_over_time(resource(r_2_XX_),scalar(1))).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),right,resource(r_1_XX_))).

precondition(timer_elapsed(patrol_entity_e_2_XX__XX__XX_),outcome(patrol_entity_e_2_XX__XX__XX_)).
result(outcome(patrol_entity_e_2_XX__XX__XX_),rotates(entity(e_2_XX_),ccw,scalar(60))).
result(outcome(patrol_entity_e_2_XX__XX__XX_),decrease(resource(r_2_XX_),resource(r_2_XX_))).
result(outcome(patrol_entity_e_2_XX__XX__XX_),decrease(resource(r_1_XX_),scalar(1))).

precondition(timer_elapsed(pingpong_entity_e_2_XX__XX__XX_),outcome(pingpong_entity_e_2_XX__XX__XX_)).
result(outcome(pingpong_entity_e_2_XX__XX__XX_),rotates(entity(e_2_XX_),cw,scalar(180))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,moves(entity(e_2_XX_),forward,scalar(5))).
result(tick,decrease_over_time(property(entity(e_1_XX_),health),scalar(5))).
result(tick,increase_over_time(property(entity(e_1_XX_),health),scalar(3))).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(consumes,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(bad,outcome(patrol_entity_e_2_XX__XX__XX_)).
reading(good,outcome(o_2_XX_)).
reading(sharing,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_2_XX_),player)).
reading(hurt,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(difficulty,5).
reading(help,relation(entity(e_2_XX_),player)).
reading(stakes(low),resource(r_2_XX_)).
==========
<ul>
<li>games/dinner_6.lp</li>
<li>The goal is to produce satiation</li>
<li>The player controls the game by<ul>
<li>
	pressing the mouse button
</li>
<li>
	holding the mouse button
</li>
</ul></ul>
