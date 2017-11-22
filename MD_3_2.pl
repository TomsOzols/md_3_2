% % https://stackoverflow.com/a/12177841
% delMember(_, [], []).
% delMember(X, [X|Xs], Y) :-
%     delMember(X, Xs, Y), !.
% delMember(X, [T|Xs], [T|Y]) :-
%     delMember(X, Xs, Y).

% % delMemberList([], [], []).
% delMemberList([Head | Tail], List, [Inter | Result]) :-
%     delMember(Head, List, Inter),
%     delMemberList(Tail, Inter, Result).


myappend([], L, L).
myappend([H | T], L, [H | X]) :- append(T, L, X).

myValueAppend(Val, L, [Val | L]).

if_then_else(P, Q, R) :- P, !, Q.
if_then_else(P, Q, R) :- R.

member(X, [X | L]).
member(X, [A | L]) :- member(X, L).

hasMember(X, L) :- member(Y, L), =(X, Y).

hasKey(Xkey, (Key, Value)) :- =(Xkey, Key).
tupleValue((Key, Value)) :- Value.

doNothing(X, L).

getValuesByKey(Xkey, List, Values) :-
	member(Ltuple, List),
	if_then_else(
		hasKey(Xkey, Ltuple),
		myValueAppend(tupleValue(Ltuple), C, C),
		doNothing(Ltuple, C)
	).
%	hasKey(Xkey, Tuples),
%	values(Tuples).

searchAndAddUnique(X, B, C) :-
	getValuesByKey(X, B, Values),
	member(Xvalue, Values),
	if_then_else(
		hasMember(Xvalue, C),
		doNothing(Xvalue, C),
		myValueAppend(Xvalue, C, C)
	).

% This actually has a complete solution available in SO.
% https://stackoverflow.com/questions/36306362/prolog-find-list-elements-in-a-list-of-tuples
aa(A, B, C) :- member(X, A), searchAndAddUnique(X, B, C).

% C=[aa, def]
testCaseaa(aa([a, c], [(a, aa), (bb, bbb), (c, def)], C)).
% C=[c, d, e]
testCaseaa(aa([a, b], [(a, c), (a, d), (b, c), (b, e), (c, f)], C)).
