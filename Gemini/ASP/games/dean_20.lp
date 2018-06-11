label(resource(r_1_XX_),tension,read_only).
label(resource(r_2_XX_),power,write).
label(entity(e_1_XX_),argument).
label(entity(e_2_XX_),dean).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

singular(entity(e_2_XX_)).

many(entity(e_1_XX_)).

initialize(set_draggable(entity(e_1_XX_),true)).
initialize(fill(all,clear)).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,center))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

controlLogic(draggable(entity(e_1_XX_))).

pool(entity(e_1_XX_),location(top,left),random,random).
pool(entity(e_1_XX_),location(top,center),random,random).
pool(entity(e_1_XX_),location(top,right),random,random).
pool(entity(e_1_XX_),location(middle,left),random,random).
pool(entity(e_1_XX_),location(middle,center),random,random).
pool(entity(e_1_XX_),location(middle,right),random,random).
pool(entity(e_1_XX_),location(bottom,left),random,random).
pool(entity(e_1_XX_),location(bottom,center),random,random).
pool(entity(e_1_XX_),location(bottom,right),random,random).
pool(entity(e_2_XX_),location(top,left),random,random).
pool(entity(e_2_XX_),location(top,center),random,random).
pool(entity(e_2_XX_),location(top,right),random,random).
pool(entity(e_2_XX_),location(middle,left),random,random).
pool(entity(e_2_XX_),location(middle,center),random,random).
pool(entity(e_2_XX_),location(middle,right),random,random).
pool(entity(e_2_XX_),location(bottom,left),random,random).
pool(entity(e_2_XX_),location(bottom,center),random,random).
pool(entity(e_2_XX_),location(bottom,right),random,random).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(10))).
initialize(set_value(resource(r_2_XX_),scalar(6))).

precondition(ge(resource(r_2_XX_),scalar(4)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),moves(entity(e_2_XX_),left,resource(r_1_XX_))).
result(outcome(o_1_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

precondition(le(resource(r_2_XX_),scalar(10)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),moves(entity(e_2_XX_),right,resource(r_1_XX_))).
result(outcome(o_2_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

precondition(control_event(button(mouse,pressed)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(resource(r_2_XX_),scalar(6))).
result(outcome(o_3_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

precondition(le(resource(r_2_XX_),scalar(9)),outcome(o_4_XX_)).
precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_4_XX_)).
result(outcome(o_4_XX_),increase(resource(r_2_XX_),scalar(1))).
result(outcome(o_4_XX_),delete(entity(e_1_XX_))).

precondition(overlaps(entity(e_1_XX_),entity(e_1_XX_),true),outcome(o_5_XX_)).
result(outcome(o_5_XX_),increase_over_time(resource(r_2_XX_),scalar(3))).

precondition(control_event(button(mouse,held)),outcome(o_6_XX_)).
result(outcome(o_6_XX_),decrease_over_time(resource(r_2_XX_),scalar(7))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,decrease_over_time(resource(r_2_XX_),scalar(7))).

reading(consumes,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(produces,relation(pool(entity(e_1_XX_)),entity(e_1_XX_))).
reading(produces,relation(entity(e_1_XX_),resource(r_2_XX_))).
reading(produces,relation(entity(e_2_XX_),resource(r_2_XX_))).
reading(difficulty,resource(r_1_XX_)).
reading(costs,relation(entity(e_1_XX_),resource(r_2_XX_))).
==========
<ul>
<li>games/dean_20.lp</li>
<li>GOAL:<ul>
</ul></li>
<li>CONTROLS:<ul>
</ul></ul>
