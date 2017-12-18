label(resource(r_1_XX_),effort,write).
label(entity(e_1_XX_),e(1)).

entity(e_1_XX_).

resource(r_1_XX_).

singular(entity(e_1_XX_)).

initialize(fill(all,orange)).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_color(entity(e_1_XX_),red)).

pool(entity(e_1_XX_),location(top,left),random,random).
pool(entity(e_1_XX_),location(top,center),random,random).
pool(entity(e_1_XX_),location(top,right),random,random).
pool(entity(e_1_XX_),location(middle,left),random,random).
pool(entity(e_1_XX_),location(middle,center),random,random).
pool(entity(e_1_XX_),location(middle,right),random,random).
pool(entity(e_1_XX_),location(bottom,left),random,random).
pool(entity(e_1_XX_),location(bottom,center),random,random).
pool(entity(e_1_XX_),location(bottom,right),random,random).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(1))).

precondition(le(amount(orange),scalar(5)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),set_value(resource(r_1_XX_),amount(orange))).

precondition(ge(resource(r_1_XX_),scalar(2)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),set_value(resource(r_1_XX_),amount(orange))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_3_XX_)).
result(outcome(o_3_XX_),set_value(resource(r_1_XX_),amount(orange))).

precondition(control_event(button(mouse,held)),outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),clear(cursor)).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),increase_over_time(resource(r_1_XX_),scalar(1))).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),right,scalar(5))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).

reading(bad,orange).
reading(good,outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_)).
reading(stakes(low),resource(r_1_XX_)).
reading(grinding,resource(r_1_XX_)).
==========
<ul>
<li>games/beach_1.lp</li>
<li>GOAL:</li>
<li>CONTROLS:<ul>
<li>	controlling [[red|triangle]] by making it orbit the cursor 
by holding the mouse button
</li>
</ul></ul>
