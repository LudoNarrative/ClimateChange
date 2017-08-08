label(entity(e_1_XX_),food).
label(entity(e_2_XX_),friend).
label(resource(r_1_XX_),satiation,write).
label(resource(r_2_XX_),r(2),private).

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
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).

controlLogic(draggable(entity(e_1_XX_))).

timer_logic(timer(wander_entity_e_2_XX__XX__XX_),scalar(7),loop).

pool(entity(e_1_XX_),location(middle,center),ordered,random).
pool(entity(e_2_XX_),location(top,left),random,random).
pool(entity(e_2_XX_),location(bottom,center),random,random).
pool(entity(e_2_XX_),location(top,right),random,random).

boundary(torus).

initialize(set_value(resource(r_1_XX_),scalar(4))).
initialize(set_value(resource(r_2_XX_),scalar(2))).

precondition(ge(resource(r_1_XX_),scalar(8)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease_over_time(resource(r_1_XX_),scalar(1))).
result(outcome(o_1_XX_),increase_over_time(resource(r_1_XX_),scalar(4))).
result(outcome(o_1_XX_),increase_over_time(resource(r_2_XX_),scalar(5))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),mode_change(narrative_gating)).

precondition(le(resource(r_1_XX_),scalar(7)),outcome(o_3_XX_)).
precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(resource(r_2_XX_),scalar(3))).
result(outcome(o_3_XX_),increase(resource(r_1_XX_),scalar(12))).
result(outcome(o_3_XX_),delete(entity(e_1_XX_))).

precondition(le(resource(r_2_XX_),scalar(5)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),increase_over_time(resource(r_2_XX_),scalar(2))).

precondition(timer_elapsed(wander_entity_e_2_XX__XX__XX_),outcome(wander_entity_e_2_XX__XX__XX_)).
result(outcome(wander_entity_e_2_XX__XX__XX_),rotate_to(entity(e_2_XX_),random_int(scalar(0),scalar(360)))).
result(outcome(wander_entity_e_2_XX__XX__XX_),add(entity(e_1_XX_),resource(r_2_XX_),pool(entity(e_1_XX_)))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,moves(entity(e_2_XX_),forward,scalar(3))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
result(tick,increase_over_time(resource(r_1_XX_),scalar(16))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
result(tick,increase_over_time(resource(r_2_XX_),scalar(1))).
result(tick,moves(entity(e_2_XX_),right,scalar(3))).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(pool(entity(e_1_XX_)),entity(e_1_XX_))).
reading(produces,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(bad,tick).
reading(good,outcome(o_3_XX_)).
reading(sharing,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(maintenance,resource(r_1_XX_)).
reading(difficulty,resource(r_1_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(stakes(low),resource(r_2_XX_)).
==========
<ul>
<li>games/dinner_21.lp</li>
<li>The goal is to produce satiation</li>
<li>The player controls the game by<ul>
<li>
	clicking-and-dragging [[red|circle]]s
</li>
</ul></ul>
