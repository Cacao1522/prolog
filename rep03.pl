% rep03: 第3回 演習課題レポート
% 提出日: 2024年4月27日
% 学籍番号: 34714037
% 名前: 加藤薫
%
%
% [述語の説明]
% mem(X,Y): XがY中に出現するなら真である
% conc(L1,L2,L3): リストL1とリストL2を連結するとリストL3になるなら真である
% /*ここから本当のPrologプログラムを書く*/
mem(X,[X | Tail]).
mem(X, [Head | Tail]) :- mem(X, Tail).

conc([], L, L).
conc([X|L1], L2, [X|L3]) :- conc(L1, L2, L3).

del(X,[X|Tail],Tail).
del(X,[Y|Tail],[Y|Tail1]) :-del(X,Tail,Tail1).
insert(X,List,BiggerList) :- del(X,BiggerList,List).
/*
問題3.8 (教科書p.79)

    関係
    	subs(Set,Subset)
    を定義せよ．ただし，SetとSubsetは集合を表すリストである．この関
    係は，部分集合関係を調べるだけではなく，与えられた集合の可能な部
    分集合をすべて生成するためにも使えるようにしたい．たとえば
    	?- subs([a,b,c],S).
    	S=[a,b,c];
    	S=[b,c];
    	S=[c];
    	S=[];
    	S=[a,c];
    	S=[a];
    	…  */

subs([],[]).
subs([Head|Tail],[Head|Sub]) :- subs(Tail,Sub).
subs([_|Tail],Sub) :- subs(Tail,Sub).

permutation([],[]).
permutation([X|L],P) :- permutation(L,L1),insert(X,L1,P).
subs2(A,P) :- subs(A,B),permutation(B,P).
/*（実行例）     

(説明)


問題3.11 (教科書p.80)

関係
	flat(List,FlatList)
を定義せよ．ただしListはリストのリストで，FlatListはListの部分リスト(またはそのまた部分リスト)の要素が
平板なリストとなるように，Listを平滑化したものである．たとえば，
	?-flat([a,b,[c,d],[],[[[e]]],f],L).
	  L=[a,b,c,d,e,f]*/

flat([],[]).
flat(X,[X]).
flat([Head|Tail],List) :- flat(Head,FlatHead),flat(Tail,FlatTail),conc(FlatHead,FlatTail),conc(FlatHead,FlatTail,List).

/*（実行例）


(説明)
concは１度に１つのリストしか消すことができないので、２つのconcを連言でつなぐ。


問題3.12 (教科書p.85)  
    :- op(300,xfx,plays).
    :- op(200,xfy,and).
というオペレータ定義を仮定すると，次の2つの項は構文的に正しいオブジェクトである．
    Term1 = jimmy plays football and squash
    Term2 = susan plays tennis and basketball and volleyball
これらの項はPrologによりいかに解釈されるか．その主関数子と構造を示せ．*/


/*（実行例）


(説明)
concを使ってListを２つのリストに分割し、そのうち右側のリストの要素がItemだけであっても成立するかを調べる。conc([X|L1], L2, [X|L3]) :- conc(L1, L2, L3).によりリストの先頭を消去しながら調べている。

問題3.21 (教科書p.92)  
手続き
    bet(N1,N2,X)
が，与えられた２つの整数N1,N2に対して，制約N1≦X≦N2を満たすすべての整数Xをバックトラックにより
生成するよう定義せよ．
*/
lasb(Item,[Item]).
lasb(Item, [Head|Tail]) :- lasb(Item,Tail).

/*（実行例）


(説明)


問題3.9-別解
conc(A, B, C)とlength(D, E)(p.90)を用いてdividelist(F, G, H)の別解dividelist2(F, G, H)を定義せよ．
lengthは組込み述語が存在するので述語名をlenとせよ．

*/
rev([], []).
rev(A, [First|Rest]) :- rev(B, Rest), conc(B, [First], A).
% または rev([First|Rest],A) :- rev(Rest, B), conc(B, [First], A).
/*（実行例）


(説明)
revの中の片方のリストの先頭ともう片方のリストの最後尾が一致するか確認した後、それらの要素を消去する。revの中の２つのリストのどちらかから先頭Firstを消去し、リストBとFirstを連結したら元のリストAになるようにリストBを決める。

*/

