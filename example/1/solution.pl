floor(0, []).
floor(NF,[40|M]) :- floor(F, M), NF is F+1.
floor(NF,[41|M]) :- floor(F, M), NF is F-1.
floor(F,[_|M])   :- floor(F, M).

main :-
  read_line_to_codes(user_input,M),
  floor(F,M),
  write(F).
