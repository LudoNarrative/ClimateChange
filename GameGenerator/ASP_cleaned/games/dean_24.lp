label(entity(e_1_XX_),yourself).
label(entity(e_2_XX_),help).
label(entity(e_3_XX_),harm).
label(resource(r_1_XX_),composure,write).
label(resource(r_2_XX_),tension,read_only).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

singular(entity(e_1_XX_)).

many(entity(e_2_XX_)).
many(entity(e_3_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_sprite(entity(e_3_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_3_XX_),green)).

timer_logic(timer(patrol_entity_e_2_XX__XX__XX_),scalar(7),loop).
timer_logic(timer(patrol_entity_e_3_XX__XX__XX_),scalar(7),loop).

pool(entity(e_1_XX_),location(middle,center),random,random).
pool(entity(e_2_XX_),location(top,left),random,ordered).
pool(entity(e_2_XX_),location(top,right),random,ordered).
pool(entity(e_2_XX_),location(bottom,center),random,ordered).
pool(entity(e_3_XX_),location(top,center),ordered,random).
pool(entity(e_3_XX_),location(bottom,left),ordered,random).
pool(entity(e_3_XX_),location(bottom,right),ordered,random).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(5))).
initialize(set_value(resource(r_2_XX_),scalar(7))).

precondition(ge(resource(r_1_XX_),scalar(10)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(narrative_progress)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
precondition(ge(resource(r_2_XX_),scalar(2)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(32))).
result(outcome(o_2_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).
result(outcome(o_2_XX_),delete(entity(e_2_XX_))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(property(entity(e_2_XX_),health),scalar(8))).
result(outcome(o_3_XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(o_3_XX_),delete(entity(e_3_XX_))).

precondition(timer_elapsed(patrol_entity_e_2_XX__XX__XX_),outcome(patrol_entity_e_2_XX__XX__XX_)).
result(outcome(patrol_entity_e_2_XX__XX__XX_),rotates(entity(e_2_XX_),ccw,scalar(30))).
result(outcome(patrol_entity_e_2_XX__XX__XX_),increase(property(entity(e_2_XX_),health),scalar(8))).
result(outcome(patrol_entity_e_2_XX__XX__XX_),increase(property(entity(e_3_XX_),health),scalar(1))).

precondition(timer_elapsed(patrol_entity_e_3_XX__XX__XX_),outcome(patrol_entity_e_3_XX__XX__XX_)).
result(outcome(patrol_entity_e_3_XX__XX__XX_),rotates(entity(e_3_XX_),ccw,scalar(30))).
result(outcome(patrol_entity_e_3_XX__XX__XX_),increase(property(entity(e_2_XX_),health),scalar(1))).
result(outcome(patrol_entity_e_3_XX__XX__XX_),add(entity(e_3_XX_),scalar(1),pool(entity(e_3_XX_)))).

precondition(control_event(button(mouse,held)),outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),backward,resource(r_1_XX_))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_2_XX_),forward,scalar(3))).
result(tick,moves(entity(e_3_XX_),forward,scalar(3))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(2))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
result(tick,moves(entity(e_3_XX_),right,scalar(3))).
result(tick,moves(entity(e_2_XX_),right,scalar(3))).
result(tick,look_at(entity(e_3_XX_),entity(e_1_XX_),furthest)).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),furthest)).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_1_XX_),property(entity(e_2_XX_),health))).
reading(bad,tick).
reading(bad,outcome(o_3_XX_)).
reading(good,outcome(o_2_XX_)).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_3_XX_),player)).
reading(dodge,entity(e_3_XX_)).
reading(survive,entity(e_3_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(difficulty,3).
reading(difficulty,resource(r_2_XX_)).
reading(difficulty,scalar(1)).
reading(hand_eye_coordination,game).
==========
<ul>
<li>games/dean_24.lp</li>
<li>The goal is to produce composure</li>
<li>The player controls the game by<ul>
<li>
	holding the mouse button
</li>
</ul></ul>
