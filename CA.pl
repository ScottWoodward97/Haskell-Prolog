edge(a,b,5).
edge(b,a,5).
edge(b,c,3).
edge(c,a,2).
edge(c,d,4).
edge(d,b,6).
edge(c,f,4).
edge(f,c,4).
edge(e,c,5).
edge(f,e,7).
edge(g,a,3).
edge(d,g,8).
edge(e,g,2).
edge(f,h,3).
edge(h,i,2).
edge(i,j,3).
edge(j,h,4).
edge(d,h,1).
edge(j,f,6).
%edge(l,k,-1).
%edge(k,l,4).
%edge(a,z,-2).

vertex(a).
vertex(b).
vertex(c).
vertex(d).
vertex(e).
vertex(f).
vertex(g).
vertex(h).
vertex(i).
vertex(j).

costFS(a,20).
costFS(b,10).
costFS(c,5).
costFS(d,8).
costFS(e,12).
costFS(f,18).
costFS(g,9).
costFS(h,7).
costFS(i,14).
costFS(j,2).

%%%%%%%% QUESTION 1 %%%%%%%%

checkGraph :- edgeCheck(_,_), fail.
checkGraph.

edgeCheck(X,Y) :- edge(X,Y,_), 
((\+vertex(X), format("Endpoint ~a of edge (~a,~a) is not a valid vertex.", [X,X,Y]),nl);
(\+vertex(Y), format("Endpoint ~a of edge (~a,~a) is not a valid vertex.", [Y,X,Y]),nl)).

edgeCheck(X,Y):- edge(X,Y,W), 
((W < 1, format("Edge (~a,~a) has weight ~a.", [X,Y,W]),nl);
(edge(Y,X,W2), W =\= W2, format("Edge (~a,~a) has weight ~a and edge (~a,~a) has weight ~a.", [X,Y,W,Y,X,W2]),nl)).

%%%%%%%% QUESTION 2 %%%%%%%%

member(X,L):- memberHelp(X,L).
memberHelp(X,[X|_]):- !.
memberHelp(X,[_|T]):- memberHelp(X,T).

isSet([]):- !.
isSet([H|T]):- \+member(H,T), isSet(T).

lastElement(Z,L):- lastHelp(Z,L).
lastHelp(Z,[H|[]]):- !, Z==H.
lastHelp(Z,[_|T]):- lastHelp(Z,T).

append([],L2,L2).
append([H|L1],L2,[H|L]):- append(L1,L2,L).

intersect(A,B,C):- intersectHelp(A,B,C,[]).
intersectHelp([],_,S,S):- !.
intersectHelp([H|T],B,C,S):- ((member(H,B), \+member(H,S), !, append(S,[H],S2), intersectHelp(T,B,C,S2)); intersectHelp(T,B,C,S)).

%%%%%%%% QUESTION 3 %%%%%%%%

path(X,Y):- X\==Y, pathHelper(X,Y,[]), !.
pathHelper(X,X,_).
pathHelper(X,Y,VISITED):- edge(X,Z,_), \+member(Z,VISITED), pathHelper(Z,Y,[X|VISITED]).

pathRoute(X,Y,L):- X\==Y, routeHelper(X,Y,L,[]).
routeHelper(X,X,L,P):- append(P,[X],L).
routeHelper(X,Y,L,P):- edge(X,Z,_), \+member(Z,P),append(P,[X],P2),routeHelper(Z,Y,L,P2).

wPath(X,Y,W):- pathRoute(X,Y,Path), wAdd(Path, W, 0).
wAdd([_|[]],W,W).
wAdd([A,B|T],W,Tot):- edge(A,B,X), Tot2 is Tot+X, wAdd([B|T],W,Tot2). 

wPathRoute(X,Y,L,W):- pathRoute(X,Y,L), wAdd(L,W,0).

pathAvoidSetRoute(X,Y,SET,L):- avoidHelper(X,Y,SET,L,[]).
avoidHelper(X,X,_,L,P):- append(P,[X],L).
avoidHelper(X,Y,SET,L,P):- edge(X,Z,_),\+member(Z,SET), \+member(Z,P), append(P,[X],P2),avoidHelper(Z,Y,SET,L,P2).

wPathAvoidSetRoute(X,Y,SET,L,W):- pathAvoidSetRoute(X,Y,SET,L), wAdd(L,W,0).

shortestPath(X,Y,L,W):- findall(P, pathRoute(X,Y,P),[PH|PT]), wAdd(PH,WH,0), shortestHelp(PT,L,W,PH,WH).
shortestHelp([],L,W,L,W).
shortestHelp([H|T],L,W,Path,Small):- wAdd(H,W2,0), ((W2<Small, shortestHelp(T,L,W,H,W2),!); shortestHelp(T,L,W,Path,Small)).

shortestPathAvoidSet(X,Y,SET,L,W):- findall(P, pathAvoidSetRoute(X,Y,SET,P),[PH|PT]), wAdd(PH,WH,0), shortestHelp(PT,L,W,PH,WH).

connectedGraph:- findall(E, edgeFind(_,_,E), Es), pathAll(Es).
edgeFind(X,Y,(X,Y)):- vertex(X), vertex(Y), X\==Y.
pathAll([]).
pathAll([(X,Y)|T]):- path(X,Y), !,pathAll(T).

%%%%%%%% QUESTION 4 %%%%%%%%

buildSST(T):- vertex(X), findall(Y, vertex(Y), Ys), delete(Ys, X, L), length(L,N), buildSSTHelper(N,X,[X],T).
buildSSTHelper(K,Prev,ACC,RES):- K > 0, vertex(X), edge(Prev,X,_), \+ member(X,ACC),
								K1 is K - 1, append(ACC,[X],ACC2), buildSSTHelper(K1, X, ACC2, RES).
buildSSTHelper(0,X,[H|T],RES):- edge(X,H,_), append([H|T],[H],RES).

buildSSTWithStart(X,[H|T]):- buildSST([H|T]),H==X.

%%%%%%%% QUESTION 5 %%%%%%%%
			
buildSafeSetFSWithinBudget(B,S):- findall(X,vertex(X),Xs), subsets(Xs, S), safeFSCheck(Xs,S), costOfSetFS(S,C), C=<B.
safeFSCheck([],_):- !.
safeFSCheck(L,[H|T]):- findDist(H, Vs), removeListFromList([H|Vs],L,L2), safeFSCheck(L2,T). 

removeListFromList([],L,L).
removeListFromList([H|T],L1,L):- delete(L1,H,L2), removeListFromList(T,L2,L).

subsets([], []).
subsets([H|T], [H|T2]):- subsets(T, T2).
subsets([_|T], T2):- subsets(T, T2).

costOfSetFS([],0).								
costOfSetFS([H|T],C):- costFS(H,P),costOfSetFS(T,C1), C is P + C1. 

findDist(X,Vs):- vertex(X), findall(Y, (vertex(Y), Y\==X),Ys), distHelp(X,Vs,Ys,[]).
distHelp(_,L,[],L).
distHelp(X,Vs,[Y|Ys],L):- ((checkDistance(X,Y),!, distHelp(X,Vs,Ys,[Y|L]));distHelp(X,Vs,Ys,L)) .

checkDistance(X,Y):- wPath(X,Y,D), D =< 5 ,!.

computeMinCostSafety(BMIN):- findall(X,vertex(X),Xs), findall(Sub, subsets(Xs,Sub),Ss), costOfSetFS(Xs,C), minHelp(Xs, Ss, C, BMIN).
minHelp(_,[],C,C).
minHelp(Xs, [SH|ST], C, BMIN):- safeFSCheck(Xs,SH), !, costOfSetFS(SH,Cost), ((Cost < C, minHelp(Xs, ST, Cost, BMIN),!); minHelp(Xs, ST, C, BMIN)).
minHelp(Xs, [_|ST], C, BMIN):-  minHelp(Xs, ST, C, BMIN).

buildMinCostSafeFS(BMIN, S):- computeMinCostSafety(BMIN), buildSafeSetFSWithinBudget(BMIN,S).