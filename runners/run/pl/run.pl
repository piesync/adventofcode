main([Part | _]) :-
  consult("/solution.pl"),
  read_stream_to_codes(user_input, I),
  call(Part, X, I),
  write(X), nl.
