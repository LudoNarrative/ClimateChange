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
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(middle,right))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,center))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_sprite(entity(e_3_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_3_XX_),green)).

timer_logic(timer(t_1_XX_),scalar(7),loop).

pool(entity(e_2_XX_),location(top,left),random,random).
pool(entity(e_2_XX_),location(top,right),random,random).
pool(entity(e_1_XX_),location(middle,center),random,random).
pool(entity(e_2_XX_),location(bottom,left),random,random).
pool(entity(e_2_XX_),location(bottom,right),random,random).
pool(entity(e_3_XX_),location(top,center),ordered,random).
pool(entity(e_3_XX_),location(middle,left),ordered,random).
pool(entity(e_3_XX_),location(middle,right),ordered,random).
pool(entity(e_3_XX_),location(bottom,center),ordered,random).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(7))).
initialize(set_value(resource(r_2_XX_),scalar(9))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_1_XX_)).
precondition(le(resource(r_1_XX_),scalar(7)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase(resource(r_1_XX_),scalar(4))).
result(outcome(o_1_XX_),delete(entity(e_3_XX_))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),mode_change(narrative_gating)).

precondition(timer_elapsed(t_1_XX_),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(property(entity(e_2_XX_),health),scalar(2))).
result(outcome(o_3_XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(o_3_XX_),add(entity(e_3_XX_),resource(r_1_XX_),pool(entity(e_3_XX_)))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_4_XX_)).
precondition(le(resource(r_1_XX_),scalar(3)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),increase(resource(r_1_XX_),scalar(2))).
result(outcome(o_4_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).
result(outcome(o_4_XX_),delete(entity(e_2_XX_))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_5_XX_)).
precondition(ge(resource(r_1_XX_),scalar(5)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(o_5_XX_),delete(entity(e_3_XX_))).

precondition(control_event(button(mouse,held)),outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),decrease(resource(r_1_XX_),resource(r_2_XX_))).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),backward,scalar(7))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_3_XX_),right,scalar(5))).
result(tick,moves(entity(e_2_XX_),right,scalar(5))).
result(tick,look_at(entity(e_3_XX_),entity(e_1_XX_),random)).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),random)).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(bad,outcome(o_5_XX_)).
reading(bad,outcome(o_3_XX_)).
reading(good,outcome(o_4_XX_)).
reading(good,outcome(o_1_XX_)).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_3_XX_),player)).
reading(hurt,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(dodge,entity(e_3_XX_)).
reading(survive,entity(e_3_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(help,relation(entity(e_3_XX_),player)).
reading(difficulty,5).
reading(difficulty,resource(r_1_XX_)).
reading(difficulty,resource(r_2_XX_)).
reading(risk_reward,overlaps(entity(e_1_XX_),entity(e_3_XX_),true)).
reading(risk_reward,overlaps(entity(e_1_XX_))).
reading(risk_reward,overlaps(entity(e_3_XX_))).
reading(hand_eye_coordination,game).
==========
<ul>
<li>games/dean_18.lp</li>
<li>The goal is to produce composure</li>
<li>The player controls the game by<ul>
<li>
	holding the mouse button
</li>
</ul></ul>
