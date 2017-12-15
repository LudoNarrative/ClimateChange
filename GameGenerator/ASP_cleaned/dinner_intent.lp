#const min_entities = 1.
#const max_entities = 2.
#const min_resources = 1.
#const max_resources = 2.
#const min_outcomes = 2.
#const max_outcomes = 6.
#const min_timers = 0.
#const max_timers = 2.

#const min_end_outcomes = 1.
#const max_end_outcomes = 1.
#const max_resource_change_per = 2.
#const max_conditions_per = 2.

required(sharing).
required(maintenance).


label(resource(r(1)),satiation,write) :- reading(good,resource(r(1))).
:- not  reading(good,resource(r(1))).

label(resource(r(2)),appetite,private) :- cooldown(ge,O,resource(r(2))),
					  1 {player_model(O,player_will_attempt);
					     player_model(O,player_must_do)}.
label(resource(r(2)),fullness,private) :- cooldown(le,_,resource(r(2))),
					  1 {player_model(O,player_will_attempt);
					     player_model(O,player_must_do)}.


acceptable_labels(appetite;fullness).

:- label(resource(r(2)),Label,private),
   not acceptable_labels(Label).

:- resource(r(2)),
   not label(resource(r(2)),_,private).


label(entity(e(1)),food).
label(entity(e(2)),friend).

:- 1 {pool(entity(e(1)),_,_,_)} 1.


:- not reading(sharing,relation(entity(e(1)),entity(e(2)))).

is_consumed(O) :- precondition(overlaps(entity(e(1))),O),
	       result(O,delete(entity(e(1)))),
	       result(O,modify(increase,resource(r(1)))).
:- not is_consumed(_).

:- result(O,modify(increase,resource(r(1)))),
   not is_consumed(O).

:- not reading(maintenance,resource(r(1))).
:- not action(mode_change(narrative_gating)).
:- 2 {action(mode_change(N))}.


:- total_count(entity(e(2)),N),
   N > 3.
:- total_count(entity(e(2)),N),
   N < 2.


:- not constant(entity(e(2))).


%:- action(add(entity(e(2)),_)).
%:- action(delete(entity(e(2)))).

%:- not entity(entity(wall)).


%:- not relative(_,_,_).

