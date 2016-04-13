
graphic(ball).
graphic(square).
graphic(face).


resource(confidence).

graphicLogic(face,confidence).

physicsLogic(ball,spring).


collisionLogic(ball,square).
controlLogic(click).

precondition(time,drain).
result(drain,decreases(confidence,1)).

precondition(control_event(click),gain).
precondition(collides(ball,square,true),gain).
result(gain,increases(confidence,2)).

precondition(control_event(click),loss).
precondition(collides(ball,square,false),loss).
result(loss,decreases(confidence,2)).

precondition(below(confidence,0), lose).
result(lose,game_loss).

