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

initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).

timer_logic(timer(t_1_XX_),scalar(3),loop).
timer_logic(timer(t_2_XX_),scalar(7),loop).
timer_logic(timer(pingpong_entity_e_2_XX__XX__XX_),scalar(3),loop).

pool(entity(e_1_XX_),location(top,center),random,random).
pool(entity(e_1_XX_),location(bottom,left),random,random).
pool(entity(e_1_XX_),location(bottom,right),random,random).
pool(entity(e_2_XX_),location(top,left),ordered,ordered).
pool(entity(e_2_XX_),location(top,right),ordered,ordered).
pool(entity(e_2_XX_),location(bottom,center),ordered,ordered).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(10))).
initialize(set_value(resource(r_2_XX_),scalar(4))).

precondition(control_event(click(entity(e_1_XX_))),outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),decrease(resource(r_1_XX_),scalar(2))).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),decrease(resource(r_2_XX_),scalar(3))).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),rotates(entity(e_1_XX_),ccw,scalar(30))).

precondition(le(resource(r_1_XX_),scalar(4)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(narrative_gating)).

precondition(timer_elapsed(t_2_XX_),outcome(o_2_XX_)).
result(outcome(o_2_XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(o_2_XX_),increase(resource(r_2_XX_),scalar(5))).
result(outcome(o_2_XX_),add(entity(e_1_XX_),resource(r_1_XX_),pool(entity(e_1_XX_)))).

precondition(ge(resource(r_2_XX_),scalar(3)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease_over_time(resource(r_2_XX_),scalar(8))).
result(outcome(o_3_XX_),increase_over_time(resource(r_2_XX_),scalar(1))).

precondition(timer_elapsed(t_1_XX_),outcome(o_4_XX_)).
result(outcome(o_4_XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(o_4_XX_),increase(resource(r_2_XX_),scalar(3))).
result(outcome(o_4_XX_),add(entity(e_1_XX_),resource(r_2_XX_),pool(entity(e_1_XX_)))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_5_XX_)).
result(outcome(o_5_XX_),increase(resource(r_1_XX_),scalar(32))).
result(outcome(o_5_XX_),increase(resource(r_2_XX_),scalar(4))).
result(outcome(o_5_XX_),delete(entity(e_1_XX_))).

precondition(le(resource(r_2_XX_),scalar(6)),outcome(o_6_XX_)).
result(outcome(o_6_XX_),decrease_over_time(resource(r_2_XX_),scalar(7))).

precondition(timer_elapsed(pingpong_entity_e_2_XX__XX__XX_),outcome(pingpong_entity_e_2_XX__XX__XX_)).
result(outcome(pingpong_entity_e_2_XX__XX__XX_),rotates(entity(e_2_XX_),cw,scalar(180))).
result(outcome(pingpong_entity_e_2_XX__XX__XX_),decrease(resource(r_1_XX_),scalar(2))).
result(outcome(pingpong_entity_e_2_XX__XX__XX_),add(entity(e_1_XX_),resource(r_2_XX_),pool(entity(e_1_XX_)))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,moves(entity(e_1_XX_),forward,resource(r_1_XX_))).
result(tick,moves(entity(e_2_XX_),forward,scalar(5))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(bad,tick).
reading(bad,outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
reading(bad,outcome(o_4_XX_)).
reading(bad,outcome(o_2_XX_)).
reading(bad,outcome(pingpong_entity_e_2_XX__XX__XX_)).
reading(good,outcome(o_5_XX_)).
reading(good,entity(e_2_XX_)).
reading(sharing,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(maintenance,resource(r_1_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(stakes(low),resource(r_2_XX_)).
==========
<ul>
<li>games/dinner_1.lp</li>
<li>The goal is to produce satiation</li>
<li>The player controls the game by<ul>
<li>
	clicking on a [[red|circle]]
</li>
</ul></ul>
