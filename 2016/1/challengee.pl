:- use_module(library(dcg/basics)).

b(I,B) :- moves(M,I,[]),
    path([p(0,0)|LS],0,M),
    crossing([p(0,0)|LS],_,C,_),
    blocks(p(0,0),C,B).

a(I,B) :- moves(M,I,[]),
    path([p(0,0)|LS],0,M),
    last(LS,E),
    blocks(p(0,0),E,B).

crossing(P,A,X,B) :- append(A,[X|B],P),
    member(X,A),
    select(X,A,AX),
    not(member(X,AX)).

blocks(p(X1,Y1),p(X2,Y2),B) :- B is abs(X2-X1)+abs(Y2-Y1).

path([_],_,[]).
path([p(X1,Y1)|[p(X2,Y2)|PS]],D,[m|MS]) :-
    trans(dp(D,X1,Y1),dp(D,X2,Y2),m),
    path([p(X2,Y2)|PS],D,MS).
path([p(X,Y)|PS],D1,[M|MS]) :-
    trans(dp(D1,X,Y),dp(D2,X,Y),M),
    path([p(X,Y)|PS],D2,MS).

trans(dp(D1,X,Y),dp(D2,X,Y),t(T)) :- D2 is mod(D1+T,4).
trans(dp(0,X,Y1),dp(0,X,Y2),m) :- Y2 is Y1 + 1.
trans(dp(2,X,Y1),dp(2,X,Y2),m) :- Y2 is Y1 - 1.
trans(dp(1,X1,Y),dp(1,X2,Y),m) :- X2 is X1 + 1.
trans(dp(3,X1,Y),dp(3,X2,Y),m) :- X2 is X1 - 1.

moves([T|X]) --> turn(T), walk(Z), moremoves(Y), { append(Z,Y,X) }.
moremoves(X) --> ", ", moves(X).
moremoves([]) --> [].

walk(M) --> integer(X), { repeat(m,X,M) }.
repeat(_,0,[]).
repeat(E,N2,[E|ES]) :- N1 is N2-1, repeat(E,N1,ES).

turn(t(1)) --> "R".
turn(t(-1)) --> "L".
