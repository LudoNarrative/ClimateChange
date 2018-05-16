label(resource(r_1_XX_),tension,read_only).
label(resource(r_2_XX_),power,write).
label(entity(e_1_XX_),e(1)).
label(entity(e_2_XX_),e(2)).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

singular(entity(e_1_XX_)).

many(entity(e_2_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

pool(entity(e_1_XX_),location(top,left),random,random).
pool(entity(e_1_XX_),location(top,right),random,random).
pool(entity(e_1_XX_),location(middle,left),random,random).
pool(entity(e_1_XX_),location(middle,center),random,random).
pool(entity(e_1_XX_),location(middle,right),random,random).
pool(entity(e_1_XX_),location(bottom,left),random,random).
pool(entity(e_1_XX_),location(bottom,center),random,random).
pool(entity(e_1_XX_),location(bottom,right),random,random).
pool(entity(e_2_XX_),location(top,left),ordered,ordered).
pool(entity(e_2_XX_),location(top,right),ordered,ordered).
pool(entity(e_2_XX_),location(middle,left),ordered,ordered).
pool(entity(e_2_XX_),location(middle,center),ordered,ordered).
pool(entity(e_2_XX_),location(middle,right),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,center),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,right),ordered,ordered).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(2))).
initialize(set_value(resource(r_2_XX_),scalar(4))).

precondition(le(resource(r_2_XX_),scalar(4)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),set_value(resource(r_2_XX_),amount(clear))).

precondition(ge(resource(r_2_XX_),scalar(1)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),set_value(resource(r_2_XX_),amount(clear))).

precondition(le(distance(entity(e_2_XX_),entity(e_1_XX_),nearest),scalar(120)),outcome(o_3_XX_)).
precondition(le(resource(r_2_XX_),scalar(6)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),moves(entity(e_2_XX_),left,resource(r_1_XX_))).
result(outcome(o_3_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

precondition(ge(distance(entity(e_2_XX_),entity(e_1_XX_),nearest),scalar(120)),outcome(o_4_XX_)).
precondition(le(resource(r_2_XX_),scalar(6)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),moves(entity(e_2_XX_),right,resource(r_1_XX_))).
result(outcome(o_4_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_5_XX_)).
result(outcome(o_5_XX_),set_value(resource(r_2_XX_),amount(clear))).
result(outcome(o_5_XX_),increase_over_time(resource(r_2_XX_),scalar(4))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_6_XX_)).
result(outcome(o_6_XX_),set_value(resource(r_2_XX_),amount(clear))).
result(outcome(o_6_XX_),increase(resource(r_2_XX_),scalar(4))).

precondition(control_event(button(mouse,held)),outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),decrease_over_time(resource(r_2_XX_),scalar(2))).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),backward,resource(r_2_XX_))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,decrease_over_time(resource(r_2_XX_),scalar(1))).

reading(goal(produce),resource(r_2_XX_)).
reading(good,resource(r_2_XX_)).
reading(produces,relation(entity(e_1_XX_),resource(r_2_XX_))).
reading(produces,relation(entity(e_2_XX_),resource(r_2_XX_))).
reading(bad,outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_)).
reading(bad,tick).
reading(good,outcome(o_6_XX_)).
reading(good,outcome(o_5_XX_)).
reading(good,entity(e_1_XX_)).
reading(good,entity(e_2_XX_)).
reading(difficulty,resource(r_1_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_2_XX_)).
reading(stakes(low),resource(r_1_XX_)).
reading(stakes(low),resource(r_2_XX_)).
reading(outcome_hurts,relation(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),resource(r_2_XX_))).
reading(risk,outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_)).
reading(outcome_helps,relation(outcome(o_6_XX_),resource(r_2_XX_))).
reading(outcome_helps,relation(outcome(o_5_XX_),resource(r_2_XX_))).
==========
<ul>
<li>games/dean_t_5.lp</li>
<li>GOAL:<ul>
<li>Produce power</li>
</ul></li>

<li>SUBGOALS:<ul>
<li>
	clicking on a [[blue|triangle]]
</li>
<li>
attempting to make a [[blue|triangle]] and [[red|triangle]] touch
</li>
</ul></li>
<li>CONTROLS:<ul>
<li>	controlling [[red|triangle]] by making it flee the cursor 
by holding the mouse button
</li>
</ul></ul>
