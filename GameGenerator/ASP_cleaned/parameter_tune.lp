
1{initialize(set_value(R,V)) : V = 0..10} 1:- resource(R).

1 {actual(O,compare(Dir,R,V))  : V = 0..10} 1:-  precondition(compare(Dir,R),O).
1 {actual(O,modify(Dir,R,V))  : V = 1} 1:-  result(O,modify(Dir,R)).


%%%%%%%%%%%%
:- occurred(_,T,O),
	T < timesteps,
	result(O,mode_change(_)).
	
z_mode_change(Timeline,M,T,O):- occurred(Timeline,T,O),
	
	result(O,mode_change(M)).
onlyOne :- occurred(Timeline,T,O),
   1 {occurred(_,T,O)} 1.
:- not onlyOne.
%:- not condition_violated(_,_).

%% SIM
#const timesteps = 10.
#const timelines = 10.
timestep(0..timesteps).
timelines {timeline(T) : T = 1..timelines}.

at(T,0,R,V) :- 
	initialize(set_value(R,V)),
	timeline(T).

at(T,0,E,V) :-
	V = #sum{N,L : initialize(add(E,scalar(N),L))},
	 initialize(add(E,_,_)),
	 timeline(T).


condition_violated(Timeline,T,O) :- 
	actual(O,compare(ge,R,V)),
	at(Timeline,T,R,RV),
	RV < V.
	

condition_violated(Timeline,T,O) :- 
	actual(O,compare(le,R,V)),
	at(Timeline,T,R,RV),
	RV > V.

condition_violated(Timeline,T,O) :- 
	precondition(overlaps(E1,E2,true),O),
	at(Timeline,T,E2,C2),
	C2 < 1,
	timeline(Timeline),
	timestep(T).
	
condition_violated(Timeline,T,O) :- 
	precondition(overlaps(E1,E2,true),O),
	at(Timeline,T,E1,C1),
	C1 < 1,
	timeline(Timeline),
	timestep(T).
	
	
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

not_chosen(Timeline,T,O,Model) :-
		player_model(O,Model),
		timeline(Timeline),
		timestep(T),
		not chosen(Timeline,T,O,Model).
	
times_chosen(Timeline,Model,Times) :-
    timeline(Timeline),
    player_model(_,Model),
    Times = {chosen(Timeline,T,O,Model)}.
	
times_not_chosen(Timeline,Model,Times) :-
    timeline(Timeline),
    player_model(_,Model),
    Times = {not_chosen(Timeline,T,O,Model)}.
    

unlikelihood(Timeline,NegativeLogLikelihood) :-
    NegativeLogLikelihood = #sum{
				WillAttempt*1 : times_chosen(Timeline,player_will_attempt,WillAttempt);
				MightAttempt*4 : times_chosen(Timeline,player_might_attempt,MightAttempt);
				WillAvoid*8 : times_chosen(Timeline,player_will_avoid,WillAvoid);
				Undetermined*8 : times_chosen(Timeline,player_will_avoid,Undetermined);
				NotWillAttempt*24 : times_not_chosen(Timeline,player_will_attempt,NotWillAttempt);
				NotMightAttempt*12 : times_not_chosen(Timeline,player_might_attempt,NotMightAttempt);
				NotWillAvoid*8 : times_not_chosen(Timeline,player_will_avoid,NotWillAvoid);
				NotUndetermined*8 : times_not_chosen(Timeline,player_will_avoid,NotUndetermined)},
    timeline(Timeline).

outcome(O) :- precondition(_,O).	
outcomes(N) :- N = {outcome(O)}.	
	
	
:- unlikelihood(Timeline,NegativeLogLikelihood),
   NegativeLogLikelihood <3*timesteps*Outcomes,
   outcomes(Outcomes).
	

% unlikelihood(Total) :-
    % Total = #sum{NegativeLogLikelihood,Timeline :unlikelihood(Timeline,NegativeLogLikelihood)}.

% :- unlikelihood(NegativeLogLikelihood),
   % NegativeLogLikelihood > 2*timesteps*timelines.
% :- unlikelihood(NegativeLogLikelihood),
   % NegativeLogLikelihood < timesteps*timelines.

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

occurred(Timeline,T, O,add(E,scalar(V),L)) :-
	occurred(Timeline,T,O),
	result(O,add(E,scalar(V),L)).

occurred(Timeline,T, O,delete(E)) :-
	occurred(Timeline,T,O),
	result(O,delete(E)).

	
at(Timeline,T+1,resource(R),RV1) :- 
	Increase = #sum{ V,O : occurred(Timeline,T, O,modify(increase,resource(R),V)) },
	Decrease = #sum{ V,O : occurred(Timeline,T, O,modify(decrease,resource(R),V)) },
	RV1 = RV + Increase-Decrease,
	at(Timeline,T,resource(R),RV),
	T < timesteps.

at(Timeline,T+1,entity(E),RV1) :- 
	Increase = #sum{ V,O : occurred(Timeline,T, O,add(entity(E),scalar(V),_)) },
	Decrease = #sum{ 1,O : occurred(Timeline,T, O,delete(entity(E))) },
	RV1 = RV + Increase-Decrease,
	at(Timeline,T,entity(E),RV),
	T < timesteps.

	
	
%%%%%%%%%%%%%%%%%%%%%%%%

% player_model(tick,must_happen).
% entity(entity(e(1))).
% entity(entity(e(2))).
% resource(resource(r(1))).
% resource(resource(r(2))).


% precondition(tick,tick).
% result(tick,apply_restitution(entity(e(1)),entity(e(1)))).
% result(tick,apply_restitution(entity(e(2)),entity(e(2)))).
% result(tick,move(entity(e(2)),direction(forward))).



% precondition(timer_elapsed(t(2)),outcome(o(4))).
% result(outcome(o(4)),modify(decrease,resource(r(1)))).

% precondition(timer_elapsed(patrol(entity(e(2)))),outcome(o(3))).
% result(outcome(o(3)),modify(decrease,resource(r(2)))).

% precondition(timer_elapsed(t(1)),outcome(o(1))).
% result(outcome(o(1)),add(entity(e(1)),scalar(1),location(bottom,right))).


% precondition(compare(le,resource(r(1))),outcome(o(2))).
% result(outcome(o(2)),mode_change(narrative_gating)).



% precondition(compare(le,resource(r(2))),outcome(patrol(entity(e(2))))).
% precondition(overlaps(entity(e(1)),entity(e(2)),true),outcome(patrol(entity(e(2))))).
% result(outcome(patrol(entity(e(2)))),rotates(entity(e(2)),cw,scalar(90))).
% result(outcome(patrol(entity(e(2)))),modify(increase,resource(r(1)))).
% result(outcome(patrol(entity(e(2)))),delete(entity(e(1)))).



% initialize(add(entity(e(1)),scalar(1),location(bottom,left))).
% initialize(add(entity(e(1)),scalar(1),location(top,center))).
% initialize(add(entity(e(1)),scalar(1),location(bottom,right))).
% initialize(add(entity(e(2)),scalar(1),location(top,left))).
% initialize(add(entity(e(2)),scalar(1),location(bottom,center))).
% initialize(add(entity(e(2)),scalar(1),location(top,right))).
% initialize(set_draggable(entity(e(1)),true)).
% player_model(outcome(patrol(entity(e(2)))),player_will_attempt).
% player_model(outcome(o(1)),must_happen).
% player_model(outcome(o(2)),must_happen).
% player_model(outcome(o(3)),must_happen).
% player_model(outcome(o(4)),must_happen).
% initialize(set_color(entity(e(1)),red)).
% initialize(set_sprite(entity(e(1)),circle)).
% initialize(set_sprite(entity(e(2)),circle)).
% initialize(set_color(entity(e(2)),blue)).




% resource(resource(r2)).
% resource(resource(r1)).


% initialize(add(entity(e1),scalar(1),location(top,right))).
% initialize(add(entity(e1),scalar(1),location(bottom,right))).

% player_model(tick,must_happen).
% player_model(outcome(win),must_happen).
% player_model(outcome(o1),must_happen).
% player_model(outcome(o2) ,player_will_attempt) .



% precondition(compare(ge,resource(r2)),outcome(win)).
% result(outcome(win),mode_change(game_win)).

% precondition(compare(ge,resource(r1)),outcome(o1)).
% result(outcome(o1),modify(increase,resource(r2))).


% precondition(control_event(click(entity(e1))),outcome(o2)).
% result(outcome(o2),modify(increase,resource(r1))).

