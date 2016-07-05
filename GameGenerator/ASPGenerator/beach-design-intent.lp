#const min_entities = 1.
#const max_entities = 2.
#const min_resources = 1.
#const max_resources = 2.
#const min_outcomes = 2.
#const max_outcomes = 5.

#const min_end_outcomes = 1.
#const max_end_outcomes = 1.
#const max_resource_change_per = 2.
#const max_conditions_per = 2.
 
%% Background/easy task; not timing based.
:- not isEasy.
:- outcome(tick).
% :- outcome(O), not playerInfluences(O).

%% Progress increases monotonically with task
hasProgress :- monotonicallyIncreases(Resource).
:- not hasProgress.

%% Task represents a caring/helpful action
%% Task represents a *gradual* action

%% Narrative stops at certain points if progress is under a threshold


