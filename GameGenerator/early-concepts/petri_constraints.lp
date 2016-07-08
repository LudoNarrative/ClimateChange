source(X) :- source(X,_,_).
sink(X) :- sink(X,_,_).
converter(X) :- converter(X,_,_).

modObject(X) :- availableObject(X).
modObject((X,Y)) :- hyponymChain(XC,X),hyponymChain(YC,Y),availableObject(X),availableObject(Y), X != Y, relationship(_,(XC,YC),_).
modObject((X,Y)) :- hyponymChain(XC,X),hyponymChain(YC,Y),availableObject(X),availableObject(Y), X != Y, relationship(_,_,(XC,YC)).

object(X) :- modObject(X).
object(X) :- hyponym(X,_).
object(X) :- hyponym(_,X).


hyponymChain(O1,O1) :- object(O1).
hyponymChain(O1,O2) :- hyponym(O1,O2).
hyponymChain(O1,O3) :- hyponymChain(O1,O2),hyponymChain(O2,O3).

minSources {activeSource(NAME,PRECONDITIONS,POSTCONDITIONS) : source(NAME), modObject(PRECONDITIONS), modObject(POSTCONDITIONS)} maxSources.
minSinks {activeSink(NAME,PRECONDITIONS,POSTCONDITIONS) : sink(NAME), modObject(PRECONDITIONS), modObject(POSTCONDITIONS)} maxSinks.

minConverters {activeConverter(NAME,PRECONDITIONS,POSTCONDITIONS) : converter(NAME), modObject(PRECONDITIONS),modObject(POSTCONDITIONS)} maxConverters.

relationship(N) :- source(N).
relationship(N) :- sink(N).
relationship(N) :- converter(N).

relationship(N,PRE,POST) :- source(N,PRE,POST).
relationship(N,PRE,POST) :- sink(N,PRE,POST).
relationship(N,PRE,POST) :- converter(N,PRE,POST).

activeRelationship(N) :- activeSource(N,_,_).
activeRelationship(N) :- activeSink(N,_,_).
activeRelationship(N) :- activeConverter(N,_,_).

minRelationships {activeRelationship(NAME) : relationship(NAME)} maxRelationships.

:- activeRelationship(N),not activeSource(N,_,_),not activeSink(N,_,_),not activeConverter(N,_,_).

activeObject(X) :- activeSource(_,X,_).
activeObject(X) :- activeSource(_,_,X).
activeObject(X) :- activeConverter(_,X,_).
activeObject(X) :- activeConverter(_,_,X).
activeObject(X) :- activeSink(_,X,_).


goodSource(N,PRE,POST) :- activeSource(N,PRE,POST),  source(N,PRE_C,POST_C), hyponymChain(PRE_C,PRE), hyponymChain(POST_C,POST). 
goodSource(N,PRE,POST) :- PRE = (PRE_X,PRE_Y),activeSource(N,(PRE_X,PRE_Y),POST),  source(N,(PRE_C_X,PRE_C_Y),POST_C), hyponymChain(PRE_C_X,PRE_X),  hyponymChain(PRE_C_Y,PRE_Y),hyponymChain(POST_C,POST). 


goodSource(N,PRE,POST) :- goodSource(N,PRE_C,POST), hyponymChain(PRE_C,PRE).
goodSource(N,PRE,POST) :- goodSource(N,PRE,POST_C), hyponymChain(POST_C,POST).

goodSource(N,PRE_C,POST) :- goodSource(N,PRE,POST), hyponymChain(PRE_C,PRE).
goodSource(N,PRE,POST_C) :- goodSource(N,PRE,POST), hyponymChain(POST_C,POST).


%goodConverter(N,PRE,POST) :- goodConverter(N,PRE_C,POST), hyponymChain(PRE_C,PRE).
%goodConverter(N,PRE,POST) :- goodConverter(N,PRE,POST_C), hyponymChain(POST_C,POST).

%goodConverter(N,PRE_C,POST) :- goodConverter(N,PRE,POST), hyponymChain(PRE_C,PRE).
%goodConverter(N,PRE,POST_C) :- goodConverter(N,PRE,POST), hyponymChain(POST_C,POST).

%goodConverter(N,PRE,POST) :- activeConverter(N,PRE_C,POST_C),  converter(N,PRE_C,POST_C), hyponymChain(PRE_C,PRE), hyponymChain(POST_C,POST). 
goodConverter(N,PRE,POST) :- activeConverter(N,PRE,POST), converter(N,PRE_C,POST_C), hyponymChain(PRE_C,PRE),hyponymChain(POST_C,POST).


goodSink(N,PRE,POST) :- activeSink(N,PRE,POST),  sink(N,PRE_C,POST_C), hyponymChain(PRE_C,PRE), hyponymChain(POST_C,POST). 

badSink(N,PRE,POST) :- activeSink(N,PRE,POST), not activeObject(PRE).
badSink(N,PRE,POST) :- activeSink(N,PRE,POST), not activeObject(POST).

:- badSink(N,PRE,POST), activeSink(N,PRE,POST).
:- not goodSink(N,PRE,POST), activeSink(N,PRE,POST).
:- not goodSource(N,PRE,POST), activeSource(N,PRE,POST).
:- not goodConverter(N,PRE,POST), activeConverter(N,PRE,POST).