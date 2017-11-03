label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),stress,write).
label(resource(r_2_XX_),r(2),private).
label(entity(e_2_XX_),e(2)).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,center))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).

timer_logic(timer(t_1_XX_),scalar(3),loop).
timer_logic(timer(t_2_XX_),scalar(3),loop).

pool(entity(e_1_XX_),location(top,left),ordered,random).
pool(entity(e_1_XX_),location(top,center),ordered,random).
pool(entity(e_1_XX_),location(top,right),ordered,random).
pool(entity(e_1_XX_),location(middle,left),ordered,random).
pool(entity(e_1_XX_),location(bottom,left),ordered,random).
pool(entity(e_1_XX_),location(bottom,right),ordered,random).
pool(entity(e_2_XX_),location(top,right),ordered,ordered).
pool(entity(e_2_XX_),location(middle,center),ordered,ordered).
pool(entity(e_2_XX_),location(middle,right),ordered,ordered).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(1))).
initialize(set_value(resource(r_2_XX_),scalar(1))).

precondition(control_event(button(mouse,pressed)),outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),decrease(resource(r_2_XX_),scalar(10))).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),increase(resource(r_1_XX_),scalar(1))).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),rotates(entity(e_1_XX_),cw,scalar(30))).

precondition(timer_elapsed(t_1_XX_),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase(property(entity(e_2_XX_),health),scalar(1))).
result(outcome(o_1_XX_),increase(resource(r_1_XX_),scalar(1))).
result(outcome(o_1_XX_),increase(resource(r_2_XX_),scalar(1))).

precondition(ge(resource(r_1_XX_),scalar(10)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),mode_change(game_loss)).

precondition(control_event(button(mouse,pressed)),outcome(o_3_XX_)).
precondition(control_event(button(mouse,held)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(property(entity(e_2_XX_),health),scalar(9))).
result(outcome(o_3_XX_),increase(resource(r_1_XX_),resource(r_1_XX_))).
result(outcome(o_3_XX_),add(entity(e_2_XX_),resource(r_2_XX_),pool(entity(e_2_XX_)))).

precondition(le(resource(r_2_XX_),scalar(1)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),moves(entity(e_2_XX_),forward,scalar(5))).
result(outcome(o_4_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),furthest)).

precondition(ge(resource(r_2_XX_),scalar(1)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),moves(entity(e_2_XX_),backward,scalar(7))).
result(outcome(o_5_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_),random)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_6_XX_)).
result(outcome(o_6_XX_),decrease(resource(r_1_XX_),scalar(14))).
result(outcome(o_6_XX_),increase(resource(r_2_XX_),scalar(1))).
result(outcome(o_6_XX_),delete(entity(e_2_XX_))).

precondition(timer_elapsed(t_2_XX_),outcome(o_7_XX_)).
result(outcome(o_7_XX_),increase(property(entity(e_2_XX_),health),scalar(6))).
result(outcome(o_7_XX_),increase(resource(r_2_XX_),resource(r_2_XX_))).
result(outcome(o_7_XX_),increase(resource(r_1_XX_),scalar(1))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,moves(entity(e_1_XX_),forward,resource(r_1_XX_))).

reading(produces,relation(pool(entity(e_2_XX_)),entity(e_2_XX_))).
reading(produces,relation(entity(e_1_XX_),resource(r_2_XX_))).
reading(produces,relation(entity(e_2_XX_),resource(r_2_XX_))).
reading(consumes,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(goal(reduce),resource(r_1_XX_)).
reading(bad,resource(r_1_XX_)).
reading(bad,outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
reading(bad,outcome(o_7_XX_)).
reading(bad,outcome(o_6_XX_)).
reading(bad,outcome(o_1_XX_)).
reading(good,outcome(o_6_XX_)).
reading(good,outcome(o_3_XX_)).
reading(good,entity(e_2_XX_)).
reading(hand_eye_coordination,game).
reading(risk_reward,control_event(button(mouse,pressed))).
reading(risk_reward,overlaps(entity(e_1_XX_),entity(e_2_XX_),true)).
reading(risk_reward,overlaps(entity(e_1_XX_))).
reading(risk_reward,overlaps(entity(e_2_XX_))).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_2_XX_),player)).
reading(hurt,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(defend_against,entity(e_2_XX_)).
reading(dodge,entity(e_2_XX_)).
reading(survive,entity(e_2_XX_)).
reading(difficulty,5).
reading(difficulty,7).
reading(difficulty,resource(r_1_XX_)).
reading(difficulty,resource(r_2_XX_)).
reading(consts,relation(entity(e_2_XX_),property(entity(e_2_XX_),health))).
reading(costs,relation(entity(e_2_XX_),property(entity(e_2_XX_),health))).
reading(tradeoff,outcome(o_6_XX_)).
reading(stakes(low),resource(r_2_XX_)).
==========
<ul>
<li>games/lecture_50.lp</li>
<li>The goal is to reduce stress</li>
<li>The player controls the game by<ul>
<li>
	pressing the mouse button
</li>
<li>
	holding the mouse button
</li>
</ul></ul>
