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

initialize(set_draggable(entity(e_1_XX_),true)).
initialize(add(entity(e_1_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_sprite(entity(e_3_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_3_XX_),green)).

controlLogic(draggable(entity(e_1_XX_))).

timer_logic(timer(patrol_entity_e_3_XX__XX__XX_),scalar(3),loop).

pool(entity(e_1_XX_),location(top,left),random,random).
pool(entity(e_1_XX_),location(top,right),random,random).
pool(entity(e_1_XX_),location(bottom,center),random,random).
pool(entity(e_2_XX_),location(middle,center),random,random).
pool(entity(e_3_XX_),location(top,center),random,random).
pool(entity(e_3_XX_),location(bottom,left),random,random).
pool(entity(e_3_XX_),location(bottom,right),random,random).

boundary(torus).

initialize(set_value(resource(r_1_XX_),scalar(4))).
initialize(set_value(resource(r_2_XX_),scalar(1))).
initialize(set_value(resource(r_3_XX_),scalar(4))).

precondition(overlaps(entity(e_2_XX_),entity(e_3_XX_),true),outcome(o_1_XX_)).
precondition(le(resource(r_1_XX_),scalar(0)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease(resource(r_3_XX_),scalar(1))).
result(outcome(o_1_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).
result(outcome(o_1_XX_),delete(entity(e_2_XX_))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(property(entity(e_2_XX_),health),scalar(2))).
result(outcome(o_2_XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(o_2_XX_),increase(resource(r_2_XX_),scalar(1))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(property(entity(e_1_XX_),health),scalar(2))).
result(outcome(o_3_XX_),decrease(resource(r_3_XX_),scalar(1))).
result(outcome(o_3_XX_),add(entity(e_3_XX_),scalar(1),pool(entity(e_3_XX_)))).

precondition(overlaps(entity(e_1_XX_),entity(e_1_XX_),true),outcome(o_4_XX_)).
result(outcome(o_4_XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(o_4_XX_),increase(resource(r_3_XX_),scalar(4))).
result(outcome(o_4_XX_),delete(entity(e_1_XX_))).

precondition(overlaps(entity(e_1_XX_),entity(e_1_XX_),true),outcome(o_5_XX_)).
precondition(ge(resource(r_2_XX_),scalar(1)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),decrease(resource(r_2_XX_),scalar(4))).
result(outcome(o_5_XX_),decrease(resource(r_3_XX_),scalar(2))).
result(outcome(o_5_XX_),delete(entity(e_1_XX_))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_6_XX_)).
precondition(ge(resource(r_3_XX_),scalar(1)),outcome(o_6_XX_)).
result(outcome(o_6_XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(o_6_XX_),decrease(resource(r_2_XX_),scalar(36))).
result(outcome(o_6_XX_),delete(entity(e_3_XX_))).

precondition(timer_elapsed(patrol_entity_e_3_XX__XX__XX_),outcome(patrol_entity_e_3_XX__XX__XX_)).
result(outcome(patrol_entity_e_3_XX__XX__XX_),rotates(entity(e_3_XX_),ccw,scalar(90))).
result(outcome(patrol_entity_e_3_XX__XX__XX_),decrease(property(entity(e_3_XX_),health),scalar(6))).
result(outcome(patrol_entity_e_3_XX__XX__XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

precondition(control_event(button(mouse,held)),outcome(repeled_from_cursor_entity_e_2_XX__XX__XX_)).
result(outcome(repeled_from_cursor_entity_e_2_XX__XX__XX_),look_at(entity(e_2_XX_),cursor,nearest)).
result(outcome(repeled_from_cursor_entity_e_2_XX__XX__XX_),moves(entity(e_2_XX_),backward,scalar(7))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_3_XX_),forward,scalar(5))).
result(tick,decrease_over_time(property(entity(e_2_XX_),health),scalar(2))).
result(tick,increase_over_time(resource(r_2_XX_),scalar(1))).
result(tick,look_at(entity(e_3_XX_),entity(e_2_XX_),nearest)).

reading(good,resource(r_1_XX_)).
reading(bad,resource(r_2_XX_)).
reading(good,resource(r_3_XX_)).
reading(consumes,relation(entity(e_1_XX_),entity(e_1_XX_))).
reading(consumes,relation(entity(e_3_XX_),entity(e_2_XX_))).
reading(consumes,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_1_XX_),resource(r_2_XX_))).
reading(consumes,relation(entity(e_3_XX_),resource(r_2_XX_))).
reading(consumes,relation(entity(e_2_XX_),resource(r_3_XX_))).
reading(consumes,relation(entity(e_3_XX_),resource(r_3_XX_))).
reading(good,property(entity(e_1_XX_),health)).
reading(produces,relation(pool(entity(e_1_XX_)),entity(e_1_XX_))).
reading(produces,relation(pool(entity(e_2_XX_)),entity(e_2_XX_))).
reading(produces,relation(pool(entity(e_3_XX_)),entity(e_3_XX_))).
reading(produces,relation(entity(e_1_XX_),resource(r_3_XX_))).
reading(bad,tick).
reading(bad,outcome(o_6_XX_)).
reading(bad,outcome(o_5_XX_)).
reading(bad,outcome(o_4_XX_)).
reading(bad,outcome(o_3_XX_)).
reading(bad,outcome(o_2_XX_)).
reading(bad,outcome(o_1_XX_)).
reading(bad,outcome(patrol_entity_e_3_XX__XX__XX_)).
reading(good,outcome(o_6_XX_)).
reading(good,outcome(o_5_XX_)).
reading(good,outcome(o_4_XX_)).
reading(bad,entity(e_1_XX_)).
reading(hurt,relation(entity(e_1_XX_),player)).
reading(hurt,relation(entity(e_3_XX_),player)).
reading(hurt,relation(entity(e_1_XX_),entity(e_1_XX_))).
reading(hurt,relation(entity(e_3_XX_),entity(e_2_XX_))).
reading(hurt,relation(entity(e_1_XX_),entity(e_3_XX_))).
reading(defend_against,entity(e_1_XX_)).
reading(defend_against,entity(e_3_XX_)).
reading(dodge,entity(e_1_XX_)).
reading(dodge,entity(e_3_XX_)).
reading(survive,entity(e_1_XX_)).
reading(survive,entity(e_3_XX_)).
reading(consts,relation(entity(e_2_XX_),resource(r_3_XX_))).
reading(costs,relation(entity(e_2_XX_),resource(r_3_XX_))).
reading(hand_eye_coordination,game).
reading(sharing,relation(entity(e_1_XX_),entity(e_1_XX_))).
reading(sharing,relation(entity(e_2_XX_),entity(e_3_XX_))).
reading(sharing,relation(resource(r_1_XX_),entity(e_1_XX_))).
reading(sharing,relation(resource(r_2_XX_),entity(e_1_XX_))).
reading(sharing,relation(resource(r_2_XX_),entity(e_3_XX_))).
reading(sharing,relation(resource(r_3_XX_),entity(e_2_XX_))).
reading(sharing,relation(resource(r_3_XX_),entity(e_3_XX_))).
reading(tradeoff,outcome(o_6_XX_)).
reading(tradeoff,outcome(o_5_XX_)).
reading(tradeoff,outcome(o_4_XX_)).
reading(maintenance,resource(r_2_XX_)).
reading(tradeoff,relation(resource(r_1_XX_),resource(r_2_XX_))).
reading(tradeoff,relation(resource(r_3_XX_),resource(r_2_XX_))).
reading(tradeoff,relation(resource(r_2_XX_),resource(r_3_XX_))).
reading(tradeoff,relation(resource(r_1_XX_),resource(r_3_XX_))).
reading(tradeoff,relation(resource(r_2_XX_),resource(r_1_XX_))).
reading(tradeoff,relation(resource(r_3_XX_),resource(r_1_XX_))).
==========
<ul>
<li>games/travel_21.lp</li>
<li>The player controls the game by<ul>
<li>
	clicking-and-dragging [[red|circle]]s
</li>
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
