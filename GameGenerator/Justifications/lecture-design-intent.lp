#const min_entities = 2.
#const max_entities = 2.
#const min_resources = 1.
#const max_resources = 1.
#const min_outcomes = 3.
#const max_outcomes = 5.
:- not good(r1).
:- not condition(tick).
denotes(r1,confidence).

:- not timingChallengeGoal.
:- not worseWithTime(r1).
:- isEasy.

:- physicsLogic(e1,mapping(control_event(left_arrow,pressed),east,low)).

% Something something cultural knowledge about confidence
% face communicates confidence


%%%% IT ESSENTIALLY RECREATED THE LECTURE GAME!!!!


% precondition(lt(r1,high),o1)
% precondition(overlaps(e1,e3,true),o1)
% result(o1,mode_change(game_loss))


% precondition(control_event(mouse_button,pressed),o3)
% precondition(overlaps(e1,e3,true),o3)
% result(o3,change_color(e1,magenta,high))
% result(o3,increases(r1,low))
% result(o3,set_sprite(e3,happy_face))
% result(o3,change_color(e3,dark_grey,mid))
% result(o3,set_sprite(e1,anxious_face))
% result(o3,mode_change(playing))


% precondition(control_event(mouse_button,pressed),o4)
% precondition(overlaps(e1,e3,false),o4)
% result(o4,set_sprite(e3,happy_face))
% result(o4,change_color(e1,magenta,high))
% result(o4,change_color(e3,yellow,mid))
% result(o4,set_sprite(e1,circle))
% result(o4,decreases(r1,low))


% precondition(tick,o5)
% result(o5,decreases(r1,low))

