

entity(ball).
entity(paddle_player).
entity(paddle_computer).

singular(ball).
singular(paddle_player).
singular(paddle_computer).

resource(score_player).
resource(score_computer).

resource(player_start).
resource(computer_start).

precondition(eq(player_start,true),player_serve).
precondition(control_event(space,pressed),player_serve).
result(player_serve, set(player_serve,false)).
result(player_serve,apply_impulse(ball, vector(north_east))).


precondition(eq(computer_start,true),computer_serve).
result(computer_serve, set(computer_serve,false)).
result(computer_serve,apply_impulse(ball, vector(north_west))).


precondition(control_event(up_arrow,held),move_up).
result(move_up,moves(paddle_player,  north , low)).

precondition(control_event(down_arrow,held),move_down).
result(move_down,moves(paddle_player,  south , low)).

precondition(above(paddle_computer,ball), move_up_computer).
result(move_up_computer,moves(paddle_computer,  north , low)).

precondition(below(paddle_computer,ball),move_down_computer).
result(move_down_computer,moves(paddle_computer,  south , low)).

precondition(overlaps(ball,screen_left),computer_score).
result(computer_score,set(player_serve,true)).
result(computer_score,increase(score_computer,low)).

precondition(overlaps(ball,paddle_computer),computer_hit).
result(computer_hit,reflect_velocity(ball,collision_normal(ball,paddle_computer))).


precondition(overlaps(ball,paddle_player),player_hit).
result(player_hit,reflect_velocity(ball,collision_normal(ball,player_hit))).

precondition(overlaps(ball,screen_right),player_score).
result(player_score,set(player_serve,true)).
result(player_score,increase(score_player,low)).


precondition(ge(score_player,high),win).
result(win, mode_change(game_win)).

precondition(ge(score_computer,high), lose).
result(lose, mode_change(game_loss)).
