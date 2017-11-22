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

% Sākotnēji 'nokopējam' otro sarakstu un nostādam kā rezultātu, kuram tiks pievienotas vērtības no pirmā saraksta.
append_lists([], L, L).
% Katru pirmā saraksta elementu pievienojam rezultāta sarakstam.
append_lists([Head | Tail], List, [Head | Result]) :- append_lists(Tail, List, Result).

% Iterē caur vāŗdnīcas tupļiem un atslēgām kuras sakrīt ar padoto, savāc sarakstu ar iegūtajām vērtībām.
values_by_key(_, [], []).
values_by_key(Key, [(Key, Value) | Tail], [Value | Accumulate]) :- values_by_key(Key, Tail, Accumulate).
values_by_key(Key, [(Miss, _) | Tail], Accumulate) :-
	dif(Key, Miss),
	values_by_key(Key, Tail, Accumulate).

% Iterē caur dotajām atslēgām, katrai atrod atbilstošās vērtības no vārdnīcas.
% Interesanti vai būtu bijis iespējams izveidot bez sarakstu apvienošanas.
find_values_for_keys([], _, []).
find_values_for_keys([Key | Tail], Dict, Result) :-
	values_by_key(Key, Dict, ValuesForKey),
	find_values_for_keys(Tail, Dict, ValuesForRest),
	append_lists(ValuesForKey, ValuesForRest, Result).

create_tuples(_, [], []).
create_tuples(Key, [Value | Tail], [(Key, Value) | Accumulate]) :- create_tuples(Key, Tail, Accumulate).

% Iterē caur pirmās vārdnīcas elementiem, paņemot tās elementu atslēgas un vērtības.
% Tekošo vērtību izmantojam kā atslēgu meklējot vērtības otrā vārdnīcā.
% No tekošās atslēgas un atrastajām B vārdnīcas vērtībām izveidojam jaunos tuple elementus.
% Katras iterācijas rezultējošu jauniegūtās vārdnīcas elementu sarakstu apvienojam ar rekursīvi iegūtajiem pārējiem sarakstiem.
find_values_as_keys([], _, []).
find_values_as_keys([(Key, Value) | Tail], DictB, Result) :-
	values_by_key(Value, DictB, ValuesForKey),
	create_tuples(Key, ValuesForKey, A_B_Tuples),
	find_values_as_keys(Tail, DictB, Rest_A_B_Tuples),
	append_lists(A_B_Tuples, Rest_A_B_Tuples, Result).

if_then_else(P, Q, R) :- P, !, Q.
if_then_else(P, Q, R) :- R.

last_element([Last | []], Last).
last_element([Head | Tail], Last) :- last_element(Tail, Last).

until_p(Dict, Result) :-
	last_element(Result, Last),
	bb(Dict, Dict, BBResult).

% Šim predikātam ir iespējams atrast esošu risinājumu StackOverflow. Nelaidīšu garām iespēju to pielāgot/aprakstīt savā risinājumā.
% https://stackoverflow.com/questions/36306362/prolog-find-list-elements-in-a-list-of-tuples
aa(A, B, C) :-
	find_values_for_keys(A, B, Values),
	my_unique(Values, C).

bb(A, B, C) :-
	find_values_as_keys(A, B, Values),
	my_unique(Values, C).

cc(A, B) :-
	bb(A, A, Inter),
	append_lists(A, Inter, Appended),
	my_unique(Appended, B).

% cc(A, B) :-
% 	until_p(A, B).


% X=[aa, def]
testCase_aa(aa([a, c], [(a, aa), (bb, bbb), (c, def)], X)).
% X=[c, d, e]
testCase_aa(aa([a, b], [(a, c), (a, d), (b, c), (b, e), (c, f)], X)).

% X=[(a, c), (a, d)]
testCase_bb(bb([(a, b)], [(b,c), (b,d)], X)).
% X=[(a, c), (a, d), (e, c), (e, d)]
testCase_bb(bb([(a, b), (e, b)], [(b,c), (b,d)], X)).
% X=[(a ,c)]
testCase_bb(bb([(a, b), (a, d), (a, e)], [(b,c), (d,c)],X)).

