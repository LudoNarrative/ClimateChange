
has_mechanic(travel, player, choose_destination).
has_mechanic(travel, player, commit).
has_mechanic(travel, system, generate_destination).
has_mechanic(travel, system, delete_destination).
has_mechanic(travel, system, process_itinerary).
% the set of available destinations
  has_pool(travel, map, destination).
has_meter(travel, money).
has_meter(travel, fame).
has_meter(travel, carbon).

% has_stat(destination, cost, numeric).
% has_stat(destination, fame, numeric).
% has_stat(destination, carbon, numeric).
% has_stat(destination, selected, bool).

% generate destinations
enables(timeout, generate_destination).
add_to_pool(generate_destination, destination, map).

% delete available destination
enables(timeout, delete_destination).
remove_from_pool(delete_destination, map).

% choosing destinations
enables(in_pool(map, D), choose_destination(D)).
change_stat(choose_destination(D), selected(D), true).


% commit
enable(commit, process_itinerary).
aggregate(process_itinerary, itinerary).


increase(process_itinerary, fame).




