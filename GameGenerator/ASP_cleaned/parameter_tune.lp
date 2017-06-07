
1{initialize(set_value(R,V)) : V = 0..10} 1:- resource(R).

1 {actual(O,compare(Dir,R,V))  : V = 0..10} 1:-  precondition(compare(Dir,R),O).
1 {actual(O,modify(Dir,R,V))  : V = 1} 1:-  result(O,modify(Dir,R)).


%%%%%%%%%%%%
:- occurred(_,T,O),
	T < timesteps,
	result(O,mode_change(_)).

onlyOne :- occurred(Timeline,T,O),
   1 {occurred(_,T,O)} 1.
:- not onlyOne.
%:- not condition_violated(_,_).

%% SIM
#const timesteps = 10.
#const timelines = 6.
timestep(0..timesteps).
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

chosen(Timeline,T,O) :-
    player_model(O,must_happen),
    timeline(Timeline),
    timestep(T).

{chosen(Timeline,T,O)}  :-
    player_model(O,player_will_attempt),
    timeline(Timeline),
    timestep(T).

chosen(Timeline,T,O,Model) :-
    chosen(Timeline,T,O),
    player_model(O,Model).

times_chosen(Timeline,Model,Times) :-
    timeline(Timeline),
    player_model(_,Model),
    Times = {chosen(Timeline,T,O,Model)}.
    

unlikelihood(Timeline,NegativeLogLikelihood) :-
    NegativeLogLikelihood = #sum{WillAttempt*1 : times_chosen(Timeline,player_will_attempt,WillAttempt);
				 MightAttempt*4 : chosen(Timeline,player_might_attempt,MightAttempt);
				 WillAvoid*8 : chosen(Timeline,player_will_avoid,WillAvoid)},
    timeline(Timeline).

:- unlikelihood(Timeline,NegativeLogLikelihood),
   NegativeLogLikelihood > 4*timesteps.

unlikelihood(Total) :-
    Total = #sum{NegativeLogLikelihood,Timeline :unlikelihood(Timeline,NegativeLogLikelihood)}.

:- unlikelihood(NegativeLogLikelihood),
   NegativeLogLikelihood > 2*timesteps*timelines.
:- unlikelihood(NegativeLogLikelihood),
   NegativeLogLikelihood < timesteps*timelines.

%#maximize{ NegativeLogLikelihood : unlikelihood(NegativeLogLikelihood)}.

%Unlikelihood
%in log_1.1 => 1/2 ~= 8, 7/10 ~= 4, 9/10 ~= 1

occurred(Timeline,T,O) :- 
	chosen(Timeline,T,O),
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
	T < timesteps.

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

