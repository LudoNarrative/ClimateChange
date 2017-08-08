label(entity(e_1_XX_),yourself).
label(entity(e_2_XX_),help).
label(entity(e_3_XX_),harm).
label(resource(r_1_XX_),composure,write).
label(resource(r_2_XX_),tension,read_only).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

singular(entity(e_1_XX_)).

many(entity(e_2_XX_)).
many(entity(e_3_XX_)).

initialize(set_draggable(entity(e_1_XX_),true)).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
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

timer_logic(timer(t_1_XX_),scalar(7),loop).
timer_logic(timer(t_2_XX_),scalar(7),loop).

pool(entity(e_1_XX_),location(middle,center),random,random).
pool(entity(e_2_XX_),location(top,left),random,ordered).
pool(entity(e_2_XX_),location(top,right),random,ordered).
pool(entity(e_2_XX_),location(bottom,center),random,ordered).
pool(entity(e_3_XX_),location(top,center),ordered,random).
pool(entity(e_3_XX_),location(bottom,left),ordered,random).
pool(entity(e_3_XX_),location(bottom,right),ordered,random).

boundary(torus).

initialize(set_value(resource(r_1_XX_),scalar(0))).
initialize(set_value(resource(r_2_XX_),scalar(9))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease_over_time(property(entity(e_2_XX_),health),scalar(4))).
result(outcome(o_1_XX_),decrease_over_time(resource(r_1_XX_),scalar(1))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
precondition(le(resource(r_2_XX_),scalar(8)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(36))).
result(outcome(o_2_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).
result(outcome(o_2_XX_),delete(entity(e_2_XX_))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_3_XX_)).
precondition(ge(resource(r_1_XX_),scalar(8)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),mode_change(narrative_progress)).

precondition(timer_elapsed(t_1_XX_),outcome(o_4_XX_)).
result(outcome(o_4_XX_),increase(property(entity(e_1_XX_),health),scalar(6))).

precondition(timer_elapsed(t_2_XX_),outcome(o_5_XX_)).
result(outcome(o_5_XX_),decrease(resource(r_1_XX_),scalar(2))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(2))).
result(tick,decrease_over_time(resource(r_2_XX_),scalar(3))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
result(tick,moves(entity(e_3_XX_),right,scalar(3))).
result(tick,moves(entity(e_2_XX_),right,scalar(3))).
result(tick,look_at(entity(e_3_XX_),entity(e_1_XX_),random)).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),random)).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(bad,tick).
reading(bad,outcome(o_1_XX_)).
reading(good,outcome(o_2_XX_)).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_3_XX_),player)).
reading(hurt,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(dodge,entity(e_3_XX_)).
reading(survive,entity(e_3_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(difficulty,3).
reading(difficulty,resource(r_1_XX_)).
reading(difficulty,resource(r_2_XX_)).
==========
<ul>
<li>games/dean_12.lp</li>
<li>The goal is to produce composure</li>
<li>The player controls the game by<ul>
<li>
	clicking-and-dragging [[red|circle]]s
</li>
</ul></ul>
