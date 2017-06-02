
1{initialize(set_value(R,V)) : V = 0..10} 1:- resource(R).

1 {actual(O,compare(Dir,R,V))  : V = 0..10} 1:-  precondition(compare(Dir,R),O).
1 {actual(O,modify(Dir,R,V))  : V = 1} 1:-  result(O,modify(Dir,R)).



:- occurred(T,O),
	T < timesteps,
	result(O,mode_change(_)).

:- not condition_violated(_,_).

%% SIM
#const timesteps = 10.
#const timelines = 3.

timelines {timeline(T) : T = 1..timelines}.

at(T,0,R,V) :- 
	initialize(set_value(R,V)),
	timeline(T).



condition_violated(Timeline,T,O) :- 
	actual(O,compare(ge,R,V)),
	at(Timeline,T,R,RV),
	RV < V.
	

condition_violated(Timeline,T,O) :- 
	actual(O,compare(le,R,V)),
	at(Timeline,T,R,RV),
	RV > V.
	
occurred(Timeline,T,O) :- 
	player_model(O,_),
	not condition_violated(Timeline,T,O),
	T <= timesteps,
	at(Timeline,T,_,_).

	
occurred(Timeline,T, O,modify(Dir,R,V)) :-
	occurred(Timeline,T,O),
	actual(O,modify(Dir,R,V)).

at(Timeline,T+1,R,RV1) :- 
	Increase = #sum{ V : occurred(Timeline,T, O,modify(increase,R,V)) },
	Decrease = #sum{ V : occurred(Timeline,T, O,modify(decrease,R,V)) },
	RV1 = RV + Increase-Decrease,
	at(Timeline,T,R,RV),
	T <= timesteps.

%

resource(resource(r2)).
resource(resource(r1)).

player_model(tick,must_happen).
player_model(outcome(win),must_happen).
player_model(outcome(o1),must_happen).
player_model(outcome(o2) ,player_will_attempt) .



precondition(compare(ge,resource(r2)),outcome(win)).
result(outcome(win),mode_change(game_win)).

precondition(compare(ge,resource(r1)),outcome(o1)).
result(outcome(o1),modify(increase,resource(r2))).


precondition(control_event(click(entity(e1))),outcome(o2)).
result(outcome(o2),modify(increase,resource(r1))).

