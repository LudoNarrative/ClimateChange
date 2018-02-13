label(resource(r_1_XX_),tension,write).
label(entity(e_1_XX_),friend1).
label(entity(e_2_XX_),friend2).
label(resource(r_2_XX_),activism,read).
label(entity(e_3_XX_),emma).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).
many(entity(e_3_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_sprite(entity(e_3_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_3_XX_),green)).
initialize(set_draggable(entity(e_1_XX_),true)).
initialize(set_draggable(entity(e_2_XX_),true)).

controlLogic(draggable(entity(e_1_XX_))).
controlLogic(draggable(entity(e_2_XX_))).

pool(entity(e_1_XX_),location(top,left),ordered,ordered).
pool(entity(e_2_XX_),location(top,left),ordered,ordered).
pool(entity(e_3_XX_),location(top,left),ordered,ordered).
pool(entity(e_1_XX_),location(top,center),ordered,ordered).
pool(entity(e_2_XX_),location(top,center),ordered,ordered).
pool(entity(e_3_XX_),location(top,center),ordered,ordered).
pool(entity(e_1_XX_),location(top,right),ordered,ordered).
pool(entity(e_2_XX_),location(top,right),ordered,ordered).
pool(entity(e_3_XX_),location(top,right),ordered,ordered).
pool(entity(e_1_XX_),location(middle,left),ordered,ordered).
pool(entity(e_2_XX_),location(middle,left),ordered,ordered).
pool(entity(e_3_XX_),location(middle,left),ordered,ordered).
pool(entity(e_1_XX_),location(middle,center),ordered,ordered).
pool(entity(e_2_XX_),location(middle,center),ordered,ordered).
pool(entity(e_3_XX_),location(middle,center),ordered,ordered).
pool(entity(e_1_XX_),location(middle,right),ordered,ordered).
pool(entity(e_2_XX_),location(middle,right),ordered,ordered).
pool(entity(e_3_XX_),location(middle,right),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_3_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,center),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,center),ordered,ordered).
pool(entity(e_3_XX_),location(bottom,center),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,right),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,right),ordered,ordered).
pool(entity(e_3_XX_),location(bottom,right),ordered,ordered).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(1))).
initialize(set_value(resource(r_2_XX_),scalar(1))).

precondition(control_event(button(mouse,held)),outcome(o_1_XX_)).
precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_1_XX_)).
result(outcome(o_1_XX_),set_value(resource(r_1_XX_),amount(clear))).
result(outcome(o_1_XX_),delete(entity(e_1_XX_))).

precondition(ge(resource(r_1_XX_),scalar(1)),outcome(o_2_XX_)).
precondition(overlaps(entity(e_2_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).
result(outcome(o_2_XX_),delete(entity(e_2_XX_))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),set_value(resource(r_2_XX_),amount(clear))).
result(outcome(o_3_XX_),decrease_over_time(property(entity(e_2_XX_),health),scalar(1))).

precondition(control_event(click(entity(e_3_XX_))),outcome(o_4_XX_)).
result(outcome(o_4_XX_),set_value(resource(r_2_XX_),amount(clear))).
result(outcome(o_4_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).

precondition(ge(resource(r_1_XX_),scalar(10)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),mode_change(narrative_gating)).

precondition(overlaps(entity(e_2_XX_),entity(e_2_XX_),true),outcome(o_6_XX_)).
result(outcome(o_6_XX_),set_value(resource(r_1_XX_),amount(clear))).
result(outcome(o_6_XX_),set_value(resource(r_2_XX_),amount(clear))).

precondition(control_event(button(mouse,held)),outcome(repeled_from_cursor_entity_e_3_XX__XX__XX_)).
result(outcome(repeled_from_cursor_entity_e_3_XX__XX__XX_),increase_over_time(resource(r_1_XX_),scalar(1))).
result(outcome(repeled_from_cursor_entity_e_3_XX__XX__XX_),look_at(entity(e_3_XX_),cursor,nearest)).
result(outcome(repeled_from_cursor_entity_e_3_XX__XX__XX_),moves(entity(e_3_XX_),backward,scalar(7))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).

reading(goal(reduce),resource(r_1_XX_)).
reading(bad,resource(r_1_XX_)).
reading(consumes,relation(entity(e_1_XX_),property(entity(e_2_XX_),health))).
reading(consumes,relation(entity(e_2_XX_),property(entity(e_2_XX_),health))).
reading(bad,outcome(repeled_from_cursor_entity_e_3_XX__XX__XX_)).
reading(hurt,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(hurt,relation(entity(e_1_XX_),entity(e_2_XX_))).
==========
<ul>
<li>games/dinner_2.lp</li>
<li>GOAL:<ul>
<li>Reduce tension</li>
</ul></li>
<li>CONTROLS:<ul>
<li>	hold the mouse button
 to make [[green|triangle]] flee the cursor</li>
</ul></ul>
