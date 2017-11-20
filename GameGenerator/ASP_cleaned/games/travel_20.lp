label(resource(r_1_XX_),money,write).
label(resource(r_2_XX_),co2,write).
label(resource(r_3_XX_),fame,write).
label(entity(e_1_XX_),e(1)).
label(entity(e_2_XX_),e(2)).
label(entity(e_3_XX_),e(3)).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

resource(r_1_XX_).
resource(r_2_XX_).
resource(r_3_XX_).

many(entity(e_1_XX_)).
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
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_sprite(entity(e_3_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_3_XX_),green)).

timer_logic(timer(patrol_entity_e_2_XX__XX__XX_),scalar(5),loop).
timer_logic(timer(patrol_entity_e_3_XX__XX__XX_),scalar(5),loop).

pool(entity(e_2_XX_),location(top,left),random,ordered).
pool(entity(e_3_XX_),location(top,left),random,ordered).
pool(entity(e_2_XX_),location(top,center),random,ordered).
pool(entity(e_3_XX_),location(top,center),random,ordered).
pool(entity(e_2_XX_),location(top,right),random,ordered).
pool(entity(e_3_XX_),location(top,right),random,ordered).
pool(entity(e_2_XX_),location(middle,left),random,ordered).
pool(entity(e_3_XX_),location(middle,left),random,ordered).
pool(entity(e_2_XX_),location(middle,center),random,ordered).
pool(entity(e_3_XX_),location(middle,center),random,ordered).
pool(entity(e_2_XX_),location(middle,right),random,ordered).
pool(entity(e_3_XX_),location(middle,right),random,ordered).
pool(entity(e_2_XX_),location(bottom,left),random,ordered).
pool(entity(e_3_XX_),location(bottom,left),random,ordered).
pool(entity(e_2_XX_),location(bottom,center),random,ordered).
pool(entity(e_3_XX_),location(bottom,center),random,ordered).
pool(entity(e_2_XX_),location(bottom,right),random,ordered).
pool(entity(e_3_XX_),location(bottom,right),random,ordered).
pool(entity(e_1_XX_),location(top,left),ordered,ordered).
pool(entity(e_1_XX_),location(top,center),ordered,ordered).
pool(entity(e_1_XX_),location(top,right),ordered,ordered).
pool(entity(e_1_XX_),location(middle,left),ordered,ordered).
pool(entity(e_1_XX_),location(middle,center),ordered,ordered).
pool(entity(e_1_XX_),location(middle,right),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,center),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,right),ordered,ordered).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(1))).
initialize(set_value(resource(r_2_XX_),scalar(1))).
initialize(set_value(resource(r_3_XX_),scalar(1))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_1_XX_)).
precondition(ge(resource(r_3_XX_),scalar(7)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease(resource(r_1_XX_),scalar(3))).
result(outcome(o_1_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).
result(outcome(o_1_XX_),delete(entity(e_1_XX_))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_2_XX_)).
result(outcome(o_2_XX_),decrease(resource(r_1_XX_),scalar(5))).
result(outcome(o_2_XX_),increase(resource(r_2_XX_),scalar(1))).
result(outcome(o_2_XX_),increase(resource(r_3_XX_),scalar(1))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_3_XX_)).
precondition(ge(resource(r_1_XX_),scalar(2)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease_over_time(property(entity(e_1_XX_),health),scalar(6))).
result(outcome(o_3_XX_),increase_over_time(property(entity(e_1_XX_),health),scalar(9))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_4_XX_)).
precondition(ge(resource(r_2_XX_),scalar(7)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),increase_over_time(property(entity(e_1_XX_),health),scalar(3))).
result(outcome(o_4_XX_),increase_over_time(resource(r_1_XX_),scalar(5))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_5_XX_)).
result(outcome(o_5_XX_),decrease(resource(r_1_XX_),scalar(5))).
result(outcome(o_5_XX_),increase(resource(r_2_XX_),scalar(2))).
result(outcome(o_5_XX_),increase(resource(r_3_XX_),scalar(2))).

precondition(timer_elapsed(patrol_entity_e_2_XX__XX__XX_),outcome(patrol_entity_e_2_XX__XX__XX_)).
result(outcome(patrol_entity_e_2_XX__XX__XX_),rotates(entity(e_2_XX_),ccw,scalar(90))).
result(outcome(patrol_entity_e_2_XX__XX__XX_),increase(resource(r_1_XX_),scalar(1))).

precondition(timer_elapsed(patrol_entity_e_3_XX__XX__XX_),outcome(patrol_entity_e_3_XX__XX__XX_)).
result(outcome(patrol_entity_e_3_XX__XX__XX_),rotates(entity(e_3_XX_),ccw,scalar(90))).
result(outcome(patrol_entity_e_3_XX__XX__XX_),increase(resource(r_1_XX_),scalar(7))).

precondition(control_event(button(mouse,held)),outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),increase_over_time(property(entity(e_1_XX_),health),scalar(8))).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),backward,resource(r_3_XX_))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_3_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_2_XX_),forward,scalar(3))).
result(tick,moves(entity(e_3_XX_),forward,scalar(5))).
result(tick,decrease_over_time(property(entity(e_1_XX_),health),scalar(8))).
result(tick,increase_over_time(property(entity(e_1_XX_),health),scalar(7))).

reading(produces,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(produces,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_3_XX_),property(entity(e_1_XX_),health))).
reading(stakes(low),resource(r_1_XX_)).
reading(stakes(low),resource(r_3_XX_)).
reading(grinding,resource(r_2_XX_)).
==========
<ul>
<li>games/travel_20.lp</li>
<li>The player controls the game by<ul>
<li>
	clicking on a [[red|triangle]]
</li>
<li>
	clicking on a [[blue|triangle]]
</li>
<li>
	holding the mouse button
</li>
</ul></ul>
