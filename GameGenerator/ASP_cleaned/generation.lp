
entity(e(N)) :- N = 1..min_entities.
{ entity(e(M)) } :- entity(e(M-1)), M=(min_entities+1)..max_entities.

resource(r(N)) :- N = 1..min_resources.
{ resource(r(M)) } :- resource(r(M-1)), M=(min_resources+1)..max_resources.


outcome(o(N)) :- N = 1..min_outcomes.
{ outcome(o(M)) } :- outcome(o(M-1)), M=(min_outcomes+1)..max_outcomes.

1 {outcome(tick)}.

timer(t(N)) :- N = 1..min_timers.
{ timer(t(M)) } :- timer(t(M-1)), M=(min_timers+1)..max_timers.

{ avatar(e(1)) }.


indirectControls(click_and_drag;
		 %click_and_click;click_and_aim;
		 drawn_to_cursor;repeled_from_cursor).


1 {controlScheme(ENTITY,SCHEME) : indirectControls(SCHEME)} 1 :- entity(ENTITY).



controlLogic(draggable(ENTITY)) :- controlScheme(ENTITY,click_and_drag).
outcome(drawn_to_cursor(ENTITY)) :- controlScheme(ENTITY,drawn_to_cursor).
outcome(repeled_from_cursor(ENTITY)) :- controlScheme(ENTITY,repeled_from_cursor).      

  
%cursor is electromagnet
precondition(control_event(button(mouse_button, held)),drawn_to_cursor(ENTITY)) :- 
    outcome(drawn_to_cursor(ENTITY)). 
result(drawn_to_cursor(ENTITY), move(ENTITY,towards(cursor))):-
    outcome(drawn_to_cursor(ENTITY)).

%cursor is opposite polarity (well, same polarity) electromagnet
precondition(control_event(button(mouse_button, held)),repeled_from_cursor(ENTITY)) :- 
    outcome(repeled_from_cursor(ENTITY)). 
result(repeled_from_cursor(ENTITY), move(ENTITY,away(cursor))):-
    outcome(repeled_from_cursor(ENTITY)).

place(E) :- entity(E).
location(-1..1,-1..1).
place(location(X,Y)) :- location(X,Y).

{precondition(control_event(click(ENTITY)),outcome(OUTCOME))
 : entity(ENTITY), outcome(OUTCOME)}.

{precondition(compare((ge;le),RESOURCE),outcome(OUTCOME))
 : resource(RESOURCE), outcome(OUTCOME)}.

{precondition(control_event(button(BUTTON,STATE)),OUTCOME) 
  : buttons(BUTTON),buttonStates(STATE), outcome(OUTCOME)}.

{precondition(overlaps(ENTITY1,ENTITY2,P),OUTCOME) :
 outcome(OUTCOME),
 entity(ENTITY1),
 entity(ENTITY2),
 polarity(P)}.

{precondition(timerElapsed(Timer), Outcome)
  : outcome(Outcome), timer(Timer)}.



%%%%%%%%%%%

{result(OUTCOME,delete(ENTITY)) : entity(ENTITY), outcome(OUTCOME)}.
% or added to a location
{result(Outcome, add(Entity)) : } 
:- entity(Entity), outcome(Outcome).

% resources can increase
{result(OUTCOME,modify(increase,RESOURCE))
  : outcome(OUTCOME),resource(RESOURCE)}.
% or decrease
{result(OUTCOME,modify(decrease,RESOURCE)) 
  : outcome(OUTCOME),resource(RESOURCE)}.


min_end_outcomes 
{result(OUTCOME,mode_change(MODE)) : modes(MODE), outcome(OUTCOME)}
max_end_outcomes.


precondition(tick,tick) :- outcome(tick).


1{many(Entity);singular(Entity)}1 :- entity(Entity).
