% 'Izveidos' jaunu sarakstu kurā nav sastopama X padotā vērtība
remove_all_X(_, [], []).
remove_all_X(X, [X | Tail], Accumulate) :- remove_all_X(X, Tail, Accumulate).
remove_all_X(X, [Y | Tail], [Y | Accumulate]) :-
	dif(X, Y), % Šo izmantojam '!' vietā. Cik saprašana atļauj, tad šis ļauj predikātam atpazīt to ka predikāta gadījumi ar Head vai X ir atšķirīgi.
	remove_all_X(X, Tail, Accumulate).

% Iterēs cauri pirmajam sarakstam, katru vērtību padodot remove_all_X predikātam, jauniegūto sarakstu bez tekošā elementa (un tam vienādiem),
% Pēc tam laižam cauri šim pašam predikātam. Katru apskatīto vērtību pievienojam rezultāta sarakstam.
% Rezultātā iegūst sarakstu no elementiem kas sarakstā neatkārtojas.
my_unique([], []).
my_unique([Head | Tail], [Head | Accumulate]) :-
	remove_all_X(Head, Tail, WithoutX),
	my_unique(WithoutX, Accumulate).

% unique_find_values_for_keys(Keys, Dict, Result) :-
% 	find_values_for_keys(Keys, Dict, Values),
% 	my_unique(Values, Result).

% Sākotnēji 'nokopējam' otro sarakstu un nostādam kā rezultātu, kuram tiks pievienotas vērtības no pirmā saraksta.
append_lists([], L, L).
% Katru pirmā saraksta elementu pievienojam rezultāta sarakstam.
append_lists([Head | Tail], List, [Head | Result]) :- append_lists(Tail, List, Result).

find_values_for_keys([], _, []).
find_values_for_keys([Key | Tail], Dict, Result) :-
	values_by_key(Key, Dict, ValuesForKey),
	find_values_for_keys(Tail, Dict, ValuesForRest),
	append_lists(ValuesForKey, ValuesForRest, Result).

values_by_key(_, [], []).
values_by_key(Key, [(Key, Value) | Tail], [Value | Accumulate]) :- values_by_key(Key, Tail, Accumulate).
values_by_key(Key, [(Miss, _) | Tail], Accumulate) :-
	dif(Key, Miss),
	values_by_key(Key, Tail, Accumulate).

if_then_else(P, Q, R) :- P, !, Q.
if_then_else(P, Q, R) :- R.

% Šim predikātam ir iespējams atrast esošu risinājumu StackOverflow. Nelaidīšu garām iespēju to pielāgot/aprakstīt savā risinājumā.
% https://stackoverflow.com/questions/36306362/prolog-find-list-elements-in-a-list-of-tuples
aa(A, B, C) :-
	find_values_for_keys(A, B, Values),
	my_unique(Values, C).

% C=[aa, def]
testCaseaa(aa([a, c], [(a, aa), (bb, bbb), (c, def)], C)).
% C=[c, d, e]
testCaseaa(aa([a, b], [(a, c), (a, d), (b, c), (b, e), (c, f)], C)).
