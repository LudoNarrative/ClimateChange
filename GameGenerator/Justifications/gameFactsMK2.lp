
physicsLogic(ball,spring).
graphicalLogic(ball,visible).
graphicalLogic(square,visible).
collisionLogic(ball,square).
controlLogic(click).


precondition(time,drain).
result(drain,decreases(confidence)).

precondition(control_event(click),gain).
precondition(collides(ball,square,true),gain).
result(gain,increases(confidence)).

precondition(control_event(click),loss).
precondition(collides(ball,square,false),loss).
result(loss,decreases(confidence)).

precondition(below(confidence,0), lose).
result(lose,game_loss).
