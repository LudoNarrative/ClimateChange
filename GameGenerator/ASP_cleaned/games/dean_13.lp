label(resource(r_1_XX_),composure).
label(resource(r_2_XX_),tension).
label(entity(e_1_XX_),yourself).
label(entity(e_2_XX_),help).
label(entity(e_3_XX_),harm).
label(resource(r_1_XX_),r(1),private).
label(resource(r_2_XX_),r(2),private).

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

timer_logic(timer(t_1_XX_),scalar(3),loop).
timer_logic(timer(t_2_XX_),scalar(7),loop).

pool(entity(e_1_XX_),location(middle,center),random,ordered).
pool(entity(e_2_XX_),location(top,left),ordered,random).
pool(entity(e_2_XX_),location(top,right),ordered,random).
pool(entity(e_2_XX_),location(bottom,left),ordered,random).
pool(entity(e_2_XX_),location(bottom,right),ordered,random).
pool(entity(e_3_XX_),location(top,center),ordered,random).
pool(entity(e_3_XX_),location(middle,left),ordered,random).
pool(entity(e_3_XX_),location(middle,right),ordered,random).
pool(entity(e_3_XX_),location(bottom,center),ordered,random).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(0))).
initialize(set_value(resource(r_2_XX_),scalar(9))).

precondition(ge(resource(r_1_XX_),scalar(3)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(narrative_progress)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),decrease_over_time(property(entity(e_3_XX_),health),scalar(7))).
result(outcome(o_2_XX_),increase_over_time(resource(r_1_XX_),scalar(16))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(o_3_XX_),add(entity(e_3_XX_),scalar(1),pool(entity(e_3_XX_)))).
result(outcome(o_3_XX_),delete(entity(e_3_XX_))).

precondition(timer_elapsed(t_2_XX_),outcome(o_4_XX_)).
result(outcome(o_4_XX_),add(entity(e_3_XX_),scalar(1),pool(entity(e_3_XX_)))).

precondition(timer_elapsed(t_1_XX_),outcome(o_5_XX_)).
result(outcome(o_5_XX_),add(entity(e_3_XX_),scalar(1),pool(entity(e_3_XX_)))).

precondition(control_event(button(mouse,held)),outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),increase_over_time(property(entity(e_3_XX_),health),scalar(1))).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),backward,scalar(7))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_2_XX_),forward,scalar(5))).
result(tick,moves(entity(e_3_XX_),forward,scalar(3))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
result(tick,look_at(entity(e_3_XX_),entity(e_1_XX_),nearest)).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(consumes,relation(entity(e_3_XX_),resource(r_1_XX_))).
reading(bad,tick).
reading(bad,outcome(o_5_XX_)).
reading(bad,outcome(o_4_XX_)).
reading(bad,outcome(o_3_XX_)).
reading(bad,entity(e_3_XX_)).
reading(good,outcome(o_3_XX_)).
reading(good,outcome(o_2_XX_)).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_3_XX_),player)).
reading(hurt,relation(entity(e_1_XX_),entity(e_3_XX_))).
reading(defend_against,entity(e_3_XX_)).
reading(survive,entity(e_3_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(tradeoff,outcome(o_3_XX_)).
reading(stakes(low),resource(r_2_XX_)).
==========
<ul>
<li>games/dean_13.lp</li>
<li>The goal is to produce r(1)</li>
<li>The player controls the game by<ul>
<li>
	holding the mouse button
</li>
</ul></ul>
