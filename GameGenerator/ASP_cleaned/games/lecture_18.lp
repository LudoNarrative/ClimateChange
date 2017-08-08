label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),stress,write).
label(entity(e_2_XX_),e(2)).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).

timer_logic(timer(pingpong_entity_e_2_XX__XX__XX_),scalar(3),loop).
timer_logic(timer(wander_entity_e_2_XX__XX__XX_),scalar(5),loop).

pool(entity(e_1_XX_),location(middle,left),random,ordered).
pool(entity(e_1_XX_),location(top,center),random,ordered).
pool(entity(e_1_XX_),location(bottom,center),random,ordered).
pool(entity(e_1_XX_),location(middle,right),random,ordered).
pool(entity(e_2_XX_),location(top,left),random,ordered).
pool(entity(e_2_XX_),location(bottom,left),random,ordered).
pool(entity(e_2_XX_),location(top,right),random,ordered).
pool(entity(e_2_XX_),location(bottom,right),random,ordered).

boundary(torus).

initialize(set_value(resource(r_1_XX_),scalar(1))).

precondition(ge(resource(r_1_XX_),scalar(9)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(game_loss)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),decrease(resource(r_1_XX_),scalar(2))).
result(outcome(o_2_XX_),delete(entity(e_1_XX_))).

precondition(control_event(button(mouse,held)),outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),left,scalar(5))).

precondition(timer_elapsed(pingpong_entity_e_2_XX__XX__XX_),outcome(pingpong_entity_e_2_XX__XX__XX_)).
result(outcome(pingpong_entity_e_2_XX__XX__XX_),rotates(entity(e_2_XX_),cw,scalar(180))).
result(outcome(pingpong_entity_e_2_XX__XX__XX_),increase(resource(r_1_XX_),scalar(1))).

precondition(timer_elapsed(wander_entity_e_2_XX__XX__XX_),outcome(wander_entity_e_2_XX__XX__XX_)).
result(outcome(wander_entity_e_2_XX__XX__XX_),rotate_to(entity(e_2_XX_),random_int(scalar(0),scalar(360)))).
result(outcome(wander_entity_e_2_XX__XX__XX_),modify(increase,resource(r_1_XX_),resource(r_1_XX_))).
result(outcome(wander_entity_e_2_XX__XX__XX_),add(entity(e_1_XX_),resource(r_1_XX_),pool(entity(e_1_XX_)))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,moves(entity(e_2_XX_),forward,scalar(3))).
result(tick,increase_over_time(property(entity(e_1_XX_),health),scalar(6))).
result(tick,increase_over_time(property(entity(e_2_XX_),health),scalar(4))).

reading(produces,relation(pool(entity(e_1_XX_)),entity(e_1_XX_))).
reading(goal(reduce),resource(r_1_XX_)).
reading(bad,resource(r_1_XX_)).
reading(bad,outcome(pingpong_entity_e_2_XX__XX__XX_)).
reading(good,outcome(o_2_XX_)).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(difficulty,resource(r_1_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_helps,relation(outcome(o_2_XX_),resource(r_1_XX_))).
==========
<ul>
<li>games/lecture_18.lp</li>
<li>The goal is to reduce stress</li>
<li>The player controls the game by<ul>
<li>
	holding the mouse button
</li>
</ul></ul>
