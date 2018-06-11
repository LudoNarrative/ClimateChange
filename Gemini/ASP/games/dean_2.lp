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
initialize(add(entity(e_1_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,center))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

controlLogic(draggable(entity(e_1_XX_))).

timer_logic(timer(t_1_XX_),scalar(3),loop).

pool(entity(e_2_XX_),location(top,center),random,random).
pool(entity(e_2_XX_),location(middle,left),random,random).
pool(entity(e_2_XX_),location(middle,center),random,random).
pool(entity(e_2_XX_),location(middle,right),random,random).
pool(entity(e_2_XX_),location(bottom,left),random,random).
pool(entity(e_2_XX_),location(bottom,right),random,random).
pool(entity(e_1_XX_),location(top,left),ordered,ordered).
pool(entity(e_1_XX_),location(top,center),ordered,ordered).
pool(entity(e_1_XX_),location(middle,left),ordered,ordered).
pool(entity(e_1_XX_),location(middle,right),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,center),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,right),ordered,ordered).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(4))).
initialize(set_value(resource(r_2_XX_),scalar(9))).

precondition(ge(distance(entity(e_2_XX_),entity(e_1_XX_),nearest),scalar(120)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),moves(entity(e_2_XX_),backward,scalar(5))).
result(outcome(o_1_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

precondition(le(resource(r_1_XX_),scalar(10)),outcome(o_2_XX_)).
precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),delete(entity(e_1_XX_))).

precondition(le(distance(entity(e_2_XX_),entity(e_1_XX_),nearest),scalar(120)),outcome(o_3_XX_)).
precondition(ge(resource(r_2_XX_),scalar(1)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),moves(entity(e_2_XX_),right,resource(r_1_XX_))).
result(outcome(o_3_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

precondition(overlaps(entity(e_1_XX_),entity(e_1_XX_),true),outcome(o_4_XX_)).
result(outcome(o_4_XX_),increase(resource(r_2_XX_),scalar(5))).
result(outcome(o_4_XX_),delete(entity(e_1_XX_))).

precondition(timer_elapsed(t_1_XX_),outcome(o_5_XX_)).
result(outcome(o_5_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

precondition(control_event(button(mouse,held)),outcome(o_6_XX_)).
result(outcome(o_6_XX_),decrease_over_time(resource(r_2_XX_),scalar(7))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,decrease_over_time(resource(r_2_XX_),scalar(9))).

reading(produces,relation(entity(e_1_XX_),resource(r_2_XX_))).
reading(difficulty,5).
reading(difficulty,resource(r_1_XX_)).
reading(stakes(low),resource(r_1_XX_)).
==========
<ul>
<li>games/dean_2.lp</li>
<li>GOAL:<ul>
</ul></li>
<li>CONTROLS:<ul>
</ul></ul>
