#const minSources = 1.
#const maxSources = 1.
#const minSinks = 1.
#const maxSinks = 1.
#const minConverters = 1.
#const maxConverters = 1.


availableObject(player).
availableObject(friend).
availableObject(banana).
availableObject(plate).

%%% KNOWLEDGE ENGINEERING

source(offers,somebody,something).
sink(eats,somebody,food).
converter(serves,plate,food).

hyponym(somebody,friend).
hyponym(somebody,player).
hyponym(something,plate).
hyponym(food,banana).


%%%%%%%%%%%%%%% CONSTRAINTS
source(X) :- source(X,_,_).
sink(X) :- sink(X,_,_).
converter(X) :- converter(X,_,_).

object(X) :- hyponym(X,_).
object(X) :- hyponym(_,X).

hyponymChain(O1,O1) :- object(O1).
hyponymChain(O1,O2) :- hyponym(O1,O2).
hyponymChain(O1,O3) :- hyponymChain(O1,O2),hyponymChain(O2,O3).

minSources {activeSource(NAME,PRECONDITIONS,POSTCONDITIONS) : source(NAME), availableObject(PRECONDITIONS), availableObject(POSTCONDITIONS)} maxSources.
minSinks {activeSink(NAME,PRECONDITIONS,POSTCONDITIONS) : sink(NAME), availableObject(PRECONDITIONS), availableObject(POSTCONDITIONS)} maxSinks.

minConverters {activeConverter(NAME,PRECONDITIONS,POSTCONDITIONS) : converter(NAME), availableObject(PRECONDITIONS),availableObject(POSTCONDITIONS)} maxConverters.

activeObject(X) :- activeSource(_,X,_).
activeObject(X) :- activeSource(_,_,X).
activeObject(X) :- activeConverter(_,_,X).
activeObject(X) :- activeSink(_,X,_).


goodSource(N,PRE,POST) :- activeSource(N,PRE,POST),  source(N,PRE_C,POST_C), hyponymChain(PRE_C,PRE), hyponymChain(POST_C,POST). 


badConverter(N,PRE,POST) :- activeConverter(N,PRE,POST), not goodSource(_,_,PRE), not goodConverter(N,_,PRE).

goodConverter(N,PRE,POST) :- activeConverter(N,PRE,POST),  converter(N,PRE_C,POST_C), hyponymChain(PRE_C,PRE), hyponymChain(POST_C,POST). 

goodSink(N,PRE,POST) :- activeSink(N,PRE,POST),  sink(N,PRE_C,POST_C), hyponymChain(PRE_C,PRE), hyponymChain(POST_C,POST). 

badSink(N,PRE,POST) :- activeSink(N,PRE,POST), not activeObject(PRE).
badSink(N,PRE,POST) :- activeSink(N,PRE,POST), not activeObject(POST).


:- badConverter(N,PRE,POST), activeConverter(N,PRE,POST).
:- badSink(N,PRE,POST), activeSink(N,PRE,POST).
:- not goodSink(N,PRE,POST), activeSink(N,PRE,POST).
:- not goodSource(N,PRE,POST), activeSource(N,PRE,POST).
:- not goodConverter(N,PRE,POST), activeConverter(N,PRE,POST).
