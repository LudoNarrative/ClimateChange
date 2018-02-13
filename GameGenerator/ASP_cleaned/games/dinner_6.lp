label(entity(e_1_XX_),food).
label(entity(e_2_XX_),friend).
label(resource(r_1_XX_),satiation,write).
label(resource(r_2_XX_),appetite,private).

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
initialize(set_draggable(entity(e_1_XX_),true)).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

controlLogic(draggable(entity(e_1_XX_))).

pool(entity(e_1_XX_),location(top,left),ordered,ordered).
pool(entity(e_1_XX_),location(top,center),ordered,ordered).
pool(entity(e_1_XX_),location(top,right),ordered,ordered).
pool(entity(e_1_XX_),location(middle,left),ordered,ordered).
pool(entity(e_1_XX_),location(middle,center),ordered,ordered).
pool(entity(e_1_XX_),location(middle,right),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,center),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,right),ordered,ordered).
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
initialize(set_value(resource(r_2_XX_),scalar(1))).

precondition(control_event(button(mouse,pressed)),outcome(o_1_XX_)).
precondition(le(amount(clear),resource(r_1_XX_)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

precondition(ge(resource(r_1_XX_),scalar(5)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),set_value(resource(r_1_XX_),amount(clear))).

precondition(ge(resource(r_2_XX_),scalar(1)),outcome(o_3_XX_)).
precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(resource(r_2_XX_),scalar(10))).
result(outcome(o_3_XX_),increase(resource(r_1_XX_),scalar(8))).
result(outcome(o_3_XX_),delete(entity(e_1_XX_))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),mode_change(narrative_gating)).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_5_XX_)).
result(outcome(o_5_XX_),set_value(resource(r_2_XX_),amount(clear))).

precondition(control_event(button(mouse,held)),outcome(orbit_the_cursor_entity_e_2_XX__XX__XX_)).
result(outcome(orbit_the_cursor_entity_e_2_XX__XX__XX_),look_at(entity(e_2_XX_),cursor,nearest)).
result(outcome(orbit_the_cursor_entity_e_2_XX__XX__XX_),moves(entity(e_2_XX_),right,resource(r_1_XX_))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
result(tick,increase_over_time(resource(r_2_XX_),scalar(1))).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(pool(entity(e_1_XX_)),entity(e_1_XX_))).
reading(produces,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(produces,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(consumes,relation(entity(e_1_XX_),resource(r_2_XX_))).
reading(consumes,relation(entity(e_2_XX_),resource(r_2_XX_))).
reading(bad,tick).
reading(good,outcome(o_3_XX_)).
reading(good,outcome(o_1_XX_)).
reading(bad,entity(e_2_XX_)).
reading(good,entity(e_1_XX_)).
reading(good,entity(e_2_XX_)).
reading(good,pool(entity(e_1_XX_))).
reading(sharing,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(tradeoff,entity(e_2_XX_)).
reading(maintenance,resource(r_1_XX_)).
==========
<ul>
<li>games/dinner_1.lp</li>
<li>GOAL:<ul>
<li>Produce satiation</li>
</ul></li>

<li>HINT:<ul>
<li>
keep appetite high
	 and
make [[blue|triangle]] touch [[red|triangle]]
</li>
<li>
	press the mouse button
	 and
keep clear low
</li>
</ul></li>
<li>CONTROLS:<ul>
<li>	hold the mouse button
 to make [[blue|triangle]] orbit the cursor</li>
</ul></ul>
