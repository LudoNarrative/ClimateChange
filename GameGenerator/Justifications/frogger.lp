

entity(start).
entity(frog).
entity(car). %different classes of cars? some sort of type system?
entity(end).

entity(lower_left).
entity(middle_right).
entity(upper_left).

resource(timeTil_lower).
resource(timeTil_middle).
resource(timeTil_upper).

resource(lives).


%start/end - should there be something like a respawnLogic?
% similarly, spawnLogic?  - feels like I want something a bit more
% interpretable than timers and checking if on screen, etc. 

many(car).

overlapLogic(car,frog).

controlLogic(arrows).


% Maybe steal from VGDL for different controller types? 
% https://github.com/EssexUniversityMCTS/gvgai/wiki/Avatar-Sprites
% not a fan of MovingAvatar as a name
% also not a fan of lack of composability - i.e. Flak should be shooting + horizontal
% also it's weird that the 2 shooting avatars have different affordances
% so, here are my thoughts 
% physicsLogic(ENTITY, mapping(control_event(KEY), MOVEMENTLOGIC,AMOUNT)).
% MOVEMENTLOGIC = {north,south,east,west,forward,backward,left,right,clockwise,counterclockwise}
% AMOUNT being in some sort of reference frame that makes sense
%       probably not being reasoned about - but say tiles per second and rotations 
%       in degrees
% and also - 
% physicsLogic(ENTITY,faces_forward) - entity faces last absolute direction moved
% 
% probably also have things like - friction (or drag) 
% 
% that's for keys, for mouse, I say something like follow, face_towards,
%  move_towards, accelerate_towards, etc.
physicsLogic(frog,mapping(control_event(up_arrow,pressed),north,1)).
physicsLogic(frog,mapping(control_event(down_arrow,pressed),south,1)).
physicsLogic(frog,mapping(control_event(left_arrow,pressed),west,1)).
physicsLogic(frog,mapping(control_event(right_arrow,pressed),east,1)).
physicsLogic(frod,face_towards).


modeLogic(playing).
modeLogic(gameLoss).
modeLogic(gameWin).

precondition(overlaps(frog,car),squish).
result(squish, decreases(lives,1)).
result(squish, move_to(frog,start)).

precondition(overlaps(frog,end),win).
result(win,mode_change(game_win)).

precondition(below(lives,0),lose).
result(lose,mode_change(game_lose)).


