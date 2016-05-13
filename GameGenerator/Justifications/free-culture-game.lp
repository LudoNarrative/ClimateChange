


entity(producer).
entity(new_idea).
entity(consumer).
entity(vectorialist).
entity(cursor).

singular(vectorialist).
singular(cursor).
multiple(producer).
multiple(consumer).
multiple(new_idea).

resource(ideasAbsorbed, producer).
resource(ideasFed, consumer).
resource(old_ideas).

physicsLogic(cursor, follows(mouse_cursor)).
physicsLogic(cursor, pushing).
phyiscsLogic(vectorialist, continuousMotion).
physicsLogic(vectorialist, pulling).

overlapLogic(new_idea, producer).
overlapLogic(new_idea, vectorialist).
overlapLogic(vectorialist, consumer).

controlLogic(mouse_cursor, cursor).

%%%% Mechanics %%%%

%% Mechanic (1): Producers make new ideas
%% XXX capture producer precondition?
precondition(slow_timeout, gen_idea).
result(gen_idea, spawn(new_idea)).

%% Mechanic (2): The cursor exerts force on ideas.
precondition(near(cursor, new_idea), push_idea(cursor)).
result(push_idea(Entity), move_away(new_idea, Entity))
  :- physicsLogic(Entity, pushing).

%% Mechanic (3): The vectorialist moves toward groups of new ideas.
precondition(far(vectorialist, new_idea), scan).
result(scan, move_toward(vectorialist, new_idea)).

%% Mechanic (4): The vectorialist pulls in new ideas.
precondition(near(vectorialist, new_idea), pull_idea(vectorialist)).
result(pull_idea(Entity), move_toward(new_idea, Entity))
  :- physicsLogic(Entity, pulling).

%% Mechanic (5): Collision between new ideas and vectorialist
%%                kills new idea & increases old ideas.
precondition(collide(new_idea, vectorialist), commodify).
result(commodify, delete(new_idea)).
result(commodify, increase(old_ideas, med)).

%% Mechanic (6): Collision between new idea & producer increases
%                ideasAbsorbed.
precondition(collide(new_idea, producer), learn).
result(learn, increase(ideasAbsorbed, mid)).

%% Mechanic (7): ideasAbsorbed decreases with time.
precondition(tick, forget).
result(tick, decrease(ideasAbsorbed, low)).

%% Mechanic (8): If ideasAbsorbed goes to 0, producer turns into consumer.
precondition(le(ideasAbsorbed, 0), convert_producer).
result(convert_producer, delete(producer)).
result(convert_producer, spawn(consumer)).

%% Initializations
% XXX ???
initialize(set_to(ideasAbsorbed,10)).


initialize(set_sprite(producer, green_person)).
initialize(set_sprite(consumer, grey_person)).
initialize(set_sprite(vectorialist, evil_robot)).

%% The goal is to prevent producers turning into consumers.
goal(prevent(convert_producer)).

