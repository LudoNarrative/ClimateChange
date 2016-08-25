

entity(e1). singular(e1).
entity(e2). singular(e2).

initialize(add(e1)).
initialize(delete(e2)).

precondition(control_event(click(e1)), o1).
precondition(absent(e2), o1).
result(o1, add(e2)).

precondition(control_event(click(e2)), o2).
result(o2, delete(e2)).


% resource(r1).
% entity(e1). singular(e1).
% % entity(e2). singular(e2).
% 
% precondition(control_event(click(e1)), o1).
% result(o1, increase(r1)).
% % result(o1, add(e2)).
% 
% % precondition(present(e2), o2).
% % precondition(control_event(click(e2)), o2).
% % result(o2, delete(e2)).
