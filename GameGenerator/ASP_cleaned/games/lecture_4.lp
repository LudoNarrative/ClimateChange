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
initialize(add(entity(e_2_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).

timer_logic(timer(patrol_entity_e_2_XX__XX__XX_),scalar(3),loop).
timer_logic(timer(pingpong_entity_e_2_XX__XX__XX_),scalar(7),loop).

pool(entity(e_1_XX_),location(top,left),random,ordered).
pool(entity(e_1_XX_),location(bottom,left),random,ordered).
pool(entity(e_1_XX_),location(top,right),random,ordered).
pool(entity(e_1_XX_),location(bottom,right),random,ordered).
pool(entity(e_2_XX_),location(middle,left),random,ordered).
pool(entity(e_2_XX_),location(top,center),random,ordered).
pool(entity(e_2_XX_),location(bottom,center),random,ordered).
pool(entity(e_2_XX_),location(middle,right),random,ordered).

boundary(torus).

initialize(set_value(resource(r_1_XX_),scalar(2))).
initialize(set_value(resource(r_2_XX_),scalar(4))).

precondition(ge(resource(r_2_XX_),scalar(0)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),modify(increase,resource(r_1_XX_),resource(r_1_XX_))).

precondition(ge(resource(r_1_XX_),scalar(9)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),mode_change(game_loss)).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_3_XX_)).
result(outcome(o_3_XX_),modify(increase,resource(r_1_XX_),resource(r_1_XX_))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_4_XX_)).
precondition(ge(resource(r_2_XX_),scalar(4)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),increase_over_time(property(entity(e_1_XX_),health),scalar(8))).
result(outcome(o_4_XX_),decrease_over_time(resource(r_1_XX_),scalar(8))).

precondition(timer_elapsed(patrol_entity_e_2_XX__XX__XX_),outcome(patrol_entity_e_2_XX__XX__XX_)).
result(outcome(patrol_entity_e_2_XX__XX__XX_),rotates(entity(e_2_XX_),ccw,scalar(30))).
result(outcome(patrol_entity_e_2_XX__XX__XX_),increase(resource(r_2_XX_),scalar(1))).

precondition(timer_elapsed(pingpong_entity_e_2_XX__XX__XX_),outcome(pingpong_entity_e_2_XX__XX__XX_)).
result(outcome(pingpong_entity_e_2_XX__XX__XX_),rotates(entity(e_2_XX_),cw,scalar(180))).
result(outcome(pingpong_entity_e_2_XX__XX__XX_),modify(increase,resource(r_2_XX_),resource(r_1_XX_))).
result(outcome(pingpong_entity_e_2_XX__XX__XX_),increase(resource(r_1_XX_),scalar(1))).

precondition(control_event(button(mouse,held)),outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),backward,resource(r_1_XX_))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,moves(entity(e_2_XX_),forward,scalar(5))).
result(tick,increase_over_time(property(entity(e_1_XX_),health),scalar(2))).

reading(produces,relation(entity(e_1_XX_),property(entity(e_1_XX_),health))).
reading(goal(reduce),resource(r_1_XX_)).
reading(bad,resource(r_1_XX_)).
reading(bad,outcome(pingpong_entity_e_2_XX__XX__XX_)).
reading(good,outcome(o_4_XX_)).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_1_XX_)).
reading(difficulty,resource(r_1_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(stakes(low),resource(r_2_XX_)).
==========
<ul>
<li>games/lecture_4.lp</li>
<li>The goal is to reduce stress</li>
<li>The player controls the game by<ul>
<li>
	clicking on a [[red|circle]]
</li>
<li>
	holding the mouse button
</li>
</ul></ul>
