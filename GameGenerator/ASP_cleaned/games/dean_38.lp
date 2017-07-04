label(resource(r_1_XX_),composure).
label(resource(r_2_XX_),tension).
label(entity(e_1_XX_),yourself).
label(entity(e_2_XX_),help).
label(entity(e_3_XX_),harm).
label(resource(r_1_XX_),r(1),private).
label(resource(r_2_XX_),r(2),private).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

singular(entity(e_1_XX_)).

many(entity(e_2_XX_)).
many(entity(e_3_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_sprite(entity(e_3_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_3_XX_),green)).

timer_logic(timer(wander_entity_e_2_XX__XX__XX_),scalar(7),loop).
timer_logic(timer(wander_entity_e_3_XX__XX__XX_),scalar(3),loop).

initialize(set_value(resource(r_1_XX_),scalar(8))).
initialize(set_value(resource(r_2_XX_),scalar(8))).

precondition(control_event(button(mouse,held)),outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),forward,scalar(7))).

precondition(le(resource(r_1_XX_),scalar(0)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(game_loss)).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(property(entity(e_1_XX_),health),scalar(4))).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(4))).
result(outcome(o_2_XX_),delete(entity(e_3_XX_))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),increase(property(entity(e_1_XX_),health),scalar(36))).
result(outcome(o_3_XX_),add(entity(e_2_XX_),scalar(1),location(top,center))).
result(outcome(o_3_XX_),delete(entity(e_2_XX_))).

precondition(timer_elapsed(wander_entity_e_2_XX__XX__XX_),outcome(wander_entity_e_2_XX__XX__XX_)).
result(outcome(wander_entity_e_2_XX__XX__XX_),rotate_to(entity(e_2_XX_),random_int(scalar(0),scalar(360)))).

precondition(timer_elapsed(wander_entity_e_3_XX__XX__XX_),outcome(wander_entity_e_3_XX__XX__XX_)).
result(outcome(wander_entity_e_3_XX__XX__XX_),rotate_to(entity(e_3_XX_),random_int(scalar(0),scalar(360)))).
result(outcome(wander_entity_e_3_XX__XX__XX_),increase(property(entity(e_2_XX_),health),scalar(10))).
result(outcome(wander_entity_e_3_XX__XX__XX_),add(entity(e_3_XX_),scalar(1),location(bottom,right))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_2_XX_),forward,scalar(3))).
result(tick,moves(entity(e_3_XX_),forward,scalar(3))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
result(tick,look_at(entity(e_3_XX_),entity(e_1_XX_),furthest)).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),furthest)).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(good,property(entity(e_1_XX_),health)).
reading(produces,relation(entity(e_2_XX_),property(entity(e_1_XX_),health))).
reading(bad,tick).
reading(bad,outcome(o_3_XX_)).
reading(good,outcome(o_3_XX_)).
reading(good,outcome(o_2_XX_)).
reading(good,entity(e_2_XX_)).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_3_XX_),player)).
reading(hurt,relation(entity(e_1_XX_),entity(e_3_XX_))).
reading(defend_against,entity(e_3_XX_)).
reading(survive,entity(e_3_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(help,relation(entity(e_3_XX_),player)).
reading(help,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(tradeoff,outcome(o_3_XX_)).
reading(stakes(low),resource(r_2_XX_)).
==========
<ul>
<li>The goal is to produce r(1)</li>

<li>The player will do this by<ul>
<li>
attempting to make a [[green|circle]] and [[red|circle]] touch
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>
	holding the mouse button
</li>
</ul></ul>
