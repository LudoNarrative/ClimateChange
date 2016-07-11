
entity(bomber).
entity(basket).
entity(bomb).

singular(bomber).
singular(basket).
many(bomb).


initialize(set_sprite(bomb,bomb)).


resource(points).
resource(bombsPerLevel).
resource(bombsLeft).

resource(lives).
resource(bomber,duration).
resource(bomber,direction).
resource(bomber,timeTilNextBomb).
resource(paused).

timerLogic(bomber,change_direction,duration,loop).

precondition(eq(paused,false),change_direction(bomber)).
precondition(timerElapsed(bomber,change_direction), change_direction(bomber)).
result(change_direction(bomber), set(direction,random_choice(east,west))).

timerLogic(bomber,throw_bomb,timeTilNextBomb,loop).
precondition(eq(paused,false),throw_bomb(bomber)).
precondition(timerElapsed(bomber,throw_bomb), throw_bomb(bomber)).
result(throw_bomb(bomber), add(bomb)).
result(throw_bomb(bomber), decrease(bombsLeft,low)).

precondition(eq(paused,false),tick).
result(tick, moves(bomber,direction)).
result(tick, moves(bomb,south)).

precondition(overlaps(bomb,basket),defuse).
result(defuse,delete(bomb)).
result(defuse,increase(score,low)).


precondition(control_event(right_arrow,held),move_right).
result(move_right,moves(basket,  east , low)).

precondition(control_event(left_arrow,held),move_left).
result(move_left,moves(basket,  west , low)).


precondition(overlaps(bomb,screen_bottom),lose_life).
result(lose_life,decrease(lives,low)).
result(lose_life,set(paused,true)).

precondition(le(lives,0),lose).
result(lose, mode_change(game_loss)).

