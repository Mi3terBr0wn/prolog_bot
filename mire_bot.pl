players_comm(Stream):-
  format(atom(Command), 'players~n', []),
  write('Command: '),write(Command),write('\n'),
  write(Stream, Command),
  flush_output(Stream).
change_room(Stream) :-
  %exit([_,Direction]),
  exit([Direction|_]),
  exit(Directions), write('All directions: '), write(Directions),
  write('\n'),
  write('Current direction: '),write(Direction),write('\n'),%%%
  format(atom(Command), 'move ~w~n', [Direction]),
  write('Command: '),write(Command),write('\n'),
  write(Stream, Command),
  flush_output(Stream),
  retractall(exit(_)),
   read_loop(Stream).
change_room(_).
main(Level) :-
   setup_call_cleanup(
     tcp_connect(localhost:3333, Stream, []),
    (parse_hello(Stream),
     %begining(Stream),
     hard_level(Level, Time),
     loop(Stream, Time)),
     close(Stream)).
read_loop(Stream) :-
  read_stream(Stream, Tokens),
  phrase(enter, Tokens, _),!;
  read_loop(Stream).

move_loop(_, 0, _).
move_loop(Stream, Count, Time_local) :-
  Count > 0,
  process(Stream),
  S is Count - 1, 
  sleep(Time_local),
  move_loop(Stream, S, Time_local).

command_in_room(Stream, Time) :-

  move_loop(Stream, 1, Time),
  
  look(Stream).

loop(Stream, Time) :-
  read_loop(Stream),
  write("\n bot enter the room \n"),
  command_in_room(Stream, Time),
  loop(Stream, Time).
 
