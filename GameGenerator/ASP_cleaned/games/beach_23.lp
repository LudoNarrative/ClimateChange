label(entity(e_1_XX_),e(1)).
label(entity(e_2_XX_),e(2)).

entity(e_1_XX_).
entity(e_2_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(fill(all,orange)).
initialize(add(entity(e_1_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,center))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).

timer_logic(timer(t_1_XX_),scalar(7),loop).
timer_logic(timer(t_2_XX_),scalar(7),loop).
timer_logic(timer(pingpong_entity_e_2_XX__XX__XX_),scalar(7),loop).
timer_logic(timer(wander_entity_e_2_XX__XX__XX_),scalar(7),loop).

pool(entity(e_1_XX_),location(top,left),ordered,ordered).
pool(entity(e_1_XX_),location(top,right),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,right),ordered,ordered).
pool(entity(e_2_XX_),location(middle,center),ordered,ordered).

boundary(closed).


precondition(control_event(button(mouse,held)),outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_),decrease_over_time(property(entity(e_2_XX_),health),scalar(6))).
result(outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),forward,scalar(5))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease(property(entity(e_2_XX_),health),scalar(8))).
result(outcome(o_1_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_2_XX_)).
result(outcome(o_2_XX_),decrease(property(entity(e_2_XX_),health),scalar(9))).
result(outcome(o_2_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).
result(outcome(o_2_XX_),delete(entity(e_1_XX_))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease_over_time(property(entity(e_1_XX_),health),scalar(9))).
result(outcome(o_3_XX_),increase_over_time(property(entity(e_1_XX_),health),scalar(6))).
result(outcome(o_3_XX_),increase_over_time(property(entity(e_2_XX_),health),scalar(9))).

precondition(timer_elapsed(t_2_XX_),outcome(o_4_XX_)).
result(outcome(o_4_XX_),decrease(property(entity(e_1_XX_),health),scalar(5))).
result(outcome(o_4_XX_),decrease(property(entity(e_2_XX_),health),scalar(5))).
result(outcome(o_4_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).

precondition(timer_elapsed(t_1_XX_),outcome(o_5_XX_)).
result(outcome(o_5_XX_),decrease(property(entity(e_2_XX_),health),scalar(9))).
result(outcome(o_5_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_6_XX_)).
precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_6_XX_)).
result(outcome(o_6_XX_),decrease(property(entity(e_1_XX_),health),scalar(9))).
result(outcome(o_6_XX_),increase(property(entity(e_1_XX_),health),scalar(6))).
result(outcome(o_6_XX_),delete(entity(e_2_XX_))).

precondition(timer_elapsed(pingpong_entity_e_2_XX__XX__XX_),outcome(pingpong_entity_e_2_XX__XX__XX_)).
result(outcome(pingpong_entity_e_2_XX__XX__XX_),rotates(entity(e_2_XX_),cw,scalar(180))).
result(outcome(pingpong_entity_e_2_XX__XX__XX_),clear(entity(entity(e_2_XX_)))).
result(outcome(pingpong_entity_e_2_XX__XX__XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).

precondition(timer_elapsed(wander_entity_e_2_XX__XX__XX_),outcome(wander_entity_e_2_XX__XX__XX_)).
result(outcome(wander_entity_e_2_XX__XX__XX_),rotate_to(entity(e_2_XX_),random_int(scalar(0),scalar(360)))).
result(outcome(wander_entity_e_2_XX__XX__XX_),decrease(property(entity(e_2_XX_),health),scalar(7))).
result(outcome(wander_entity_e_2_XX__XX__XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,moves(entity(e_2_XX_),forward,scalar(3))).

reading(produces,relation(pool(entity(e_2_XX_)),entity(e_2_XX_))).
reading(produces,relation(entity(e_1_XX_),property(entity(e_2_XX_),health))).
reading(produces,relation(entity(e_2_XX_),property(entity(e_2_XX_),health))).
reading(consumes,relation(entity(e_1_XX_),property(entity(e_1_XX_),health))).
reading(hurt,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(hurt,relation(entity(e_2_XX_),player)).
reading(defend_against,entity(e_2_XX_)).
reading(survive,entity(e_2_XX_)).
reading(difficulty,3).
reading(difficulty,scalar(1)).
reading(consts,relation(entity(e_1_XX_),property(entity(e_2_XX_),health))).
reading(consts,relation(entity(e_2_XX_),property(entity(e_1_XX_),health))).
reading(consts,relation(entity(e_2_XX_),property(entity(e_2_XX_),health))).
reading(costs,relation(entity(e_1_XX_),property(entity(e_2_XX_),health))).
reading(costs,relation(entity(e_2_XX_),property(entity(e_1_XX_),health))).
reading(costs,relation(entity(e_2_XX_),property(entity(e_2_XX_),health))).
==========
<ul>
<li>games/beach_23.lp</li>
<li>The player controls the game by<ul>
<li>
	clicking on a [[red|circle]]
</li>
<li>
	clicking on a [[blue|circle]]
</li>
<li>
	holding the mouse button
</li>
</ul></ul>
