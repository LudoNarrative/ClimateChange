label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),concentration,write).
label(entity(e_2_XX_),e(2)).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).

singular(entity(e_1_XX_)).

many(entity(e_2_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_sprite(entity(e_2_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),blue)).

timer_logic(timer(t_1_XX_),scalar(3),loop).

pool(entity(e_1_XX_),location(top,left),random,random).
pool(entity(e_1_XX_),location(top,center),random,random).
pool(entity(e_1_XX_),location(top,right),random,random).
pool(entity(e_1_XX_),location(middle,left),random,random).
pool(entity(e_1_XX_),location(middle,center),random,random).
pool(entity(e_1_XX_),location(middle,right),random,random).
pool(entity(e_1_XX_),location(bottom,left),random,random).
pool(entity(e_1_XX_),location(bottom,center),random,random).
pool(entity(e_1_XX_),location(bottom,right),random,random).
pool(entity(e_2_XX_),location(top,left),ordered,random).
pool(entity(e_2_XX_),location(top,center),ordered,random).
pool(entity(e_2_XX_),location(top,right),ordered,random).
pool(entity(e_2_XX_),location(middle,left),ordered,random).
pool(entity(e_2_XX_),location(middle,center),ordered,random).
pool(entity(e_2_XX_),location(middle,right),ordered,random).
pool(entity(e_2_XX_),location(bottom,left),ordered,random).
pool(entity(e_2_XX_),location(bottom,center),ordered,random).
pool(entity(e_2_XX_),location(bottom,right),ordered,random).

boundary(closed).

initialize(set_value(resource(r_1_XX_),scalar(10))).

precondition(control_event(button(mouse,held)),outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),decrease_over_time(resource(r_1_XX_),scalar(1))).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),rotates(entity(e_1_XX_),cw,scalar(5))).

precondition(control_event(button(mouse,held)),outcome(o_1_XX_)).
precondition(ge(amount(clear),resource(r_1_XX_)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),set_value(resource(r_1_XX_),amount(clear))).
result(outcome(o_1_XX_),increase_over_time(resource(r_1_XX_),scalar(16))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(o_2_XX_),delete(entity(e_2_XX_))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),mode_change(game_loss)).

precondition(ge(resource(r_1_XX_),scalar(9)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),set_value(resource(r_1_XX_),amount(clear))).

precondition(timer_elapsed(t_1_XX_),outcome(o_5_XX_)).
result(outcome(o_5_XX_),set_value(resource(r_1_XX_),amount(clear))).
result(outcome(o_5_XX_),add(entity(e_2_XX_),scalar(1),pool(entity(e_2_XX_)))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
result(tick,moves(entity(e_1_XX_),forward,scalar(7))).
result(tick,moves(entity(e_2_XX_),left,scalar(5))).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(consumes,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(bad,tick).
reading(bad,outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
reading(bad,outcome(o_5_XX_)).
reading(bad,outcome(o_2_XX_)).
reading(good,outcome(o_2_XX_)).
reading(good,outcome(o_1_XX_)).
reading(bad,entity(e_1_XX_)).
reading(bad,entity(e_2_XX_)).
reading(hand_eye_coordination,game).
reading(risk_reward,control_event(button(mouse,held))).
reading(risk_reward,overlaps(entity(e_1_XX_),entity(e_2_XX_),true)).
reading(risk_reward,overlaps(entity(e_1_XX_))).
reading(risk_reward,overlaps(entity(e_2_XX_))).
reading(maintenance,resource(r_1_XX_)).
reading(sharing,relation(resource(r_1_XX_),entity(e_2_XX_))).
reading(tradeoff,outcome(o_2_XX_)).
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_hurts,relation(outcome(click_to_spin_entity_e_1_XX__XX__XX_),resource(r_1_XX_))).
reading(risk,outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
reading(risk,outcome(o_1_XX_)).
==========
<ul>
<li>games/lecture_dodgeMode_25.lp</li>
<li>GOAL:<ul>
<li>Produce concentration</li>
</ul></li>

<li>SUBGOALS:<ul>
<li>
	holding the mouse button
	 at the same time as
having amount(clear) be high
</li>
</ul></li>
<li>CONTROLS:<ul>
<li>	controlling [[red|triangle]] by making it rotate 
by holding the mouse button
</li>
</ul></ul>
