
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
subs([_|Tail],[_|Sub]) :- subs(Tail,Sub).
subs([_|Tail],Sub) :- subs(Tail,Sub).
/*（実行例）     

(説明)
[_, _, _]で３要素をもつリストを表現できる。concを使う場合、結合前のリストの片方を変数とすれば結合後のリストからもう片方の結合前のリストを消すことができる。

(b)リストLからその最初の３つの要素と最後の３つの要素を消したL2を作る目標の系列を書け．
?- conc(L1, [_, _, _], L), conc([_, _, _], L2, L1).
または　?- conc([_, _, _], L1, L), conc(L2, [_, _, _], L1).
（実行例）
?- conc(L1, [_, _, _], [a,b,c,d,e,f,g]), conc([_, _, _], L2, L1).
L1 = [a, b, c, d],
L2 = [d] ;
false.

?- conc(L1, [_, _, _], [a,b,c,d,e]), conc([_, _, _], L2, L1).
false.

[trace]  ?- conc(L1, [_, _, _], [a,b,c,d,e,f,g]), conc([_, _, _], L2, L1).
   Call: (11) conc(_44404, [_44342, _44348, _44354], [a, b, c, d, e, f, g]) ? creep
   Call: (12) conc(_46124, [_44342, _44348, _44354], [b, c, d, e, f, g]) ? creep
   Call: (13) conc(_46944, [_44342, _44348, _44354], [c, d, e, f, g]) ? creep
   Call: (14) conc(_47764, [_44342, _44348, _44354], [d, e, f, g]) ? creep
   Call: (15) conc(_48584, [_44342, _44348, _44354], [e, f, g]) ? creep
   Exit: (15) conc([], [e, f, g], [e, f, g]) ? creep % 事実conc([], L, L).と一致
   Exit: (14) conc([d], [e, f, g], [d, e, f, g]) ? creep
   Exit: (13) conc([c, d], [e, f, g], [c, d, e, f, g]) ? creep
   Exit: (12) conc([b, c, d], [e, f, g], [b, c, d, e, f, g]) ? creep
   Exit: (11) conc([a, b, c, d], [e, f, g], [a, b, c, d, e, f, g]) ? creep
   Call: (11) conc([_44414, _44420, _44426], _44434, [a, b, c, d]) ? creep
   Call: (12) conc([_44420, _44426], _44434, [b, c, d]) ? creep
   Call: (13) conc([_44426], _44434, [c, d]) ? creep
   Call: (14) conc([], _44434, [d]) ? creep
   Exit: (14) conc([], [d], [d]) ? creep % 事実conc([], L, L).と一致
   Exit: (13) conc([c], [d], [c, d]) ? creep
   Exit: (12) conc([b, c], [d], [b, c, d]) ? creep
   Exit: (11) conc([a, b, c], [d], [a, b, c, d]) ? creep
L1 = [a, b, c, d],
L2 = [d] ;
   Redo: (15) conc(_48584, [_44342, _44348, _44354], [e, f, g]) ? creep
   Call: (16) conc(_62710, [_44342, _44348, _44354], [f, g]) ? creep
   Call: (17) conc(_63530, [_44342, _44348, _44354], [g]) ? creep
   Call: (18) conc(_64350, [_44342, _44348, _44354], []) ? creep
   Fail: (18) conc(_64350, [_44342, _44348, _44354], []) ? creep
   Fail: (17) conc(_63530, [_44342, _44348, _44354], [g]) ? creep
   Fail: (16) conc(_62710, [_44342, _44348, _44354], [f, g]) ? creep
   Fail: (15) conc(_48584, [_44342, _44348, _44354], [e, f, g]) ? creep
   Fail: (14) conc(_47764, [_44342, _44348, _44354], [d, e, f, g]) ? creep
   Fail: (13) conc(_46944, [_44342, _44348, _44354], [c, d, e, f, g]) ? creep
   Fail: (12) conc(_46124, [_44342, _44348, _44354], [b, c, d, e, f, g]) ? creep
   Fail: (11) conc(_44404, [_44342, _44348, _44354], [a, b, c, d, e, f, g]) ? creep
false.

(説明)
concは１度に１つのリストしか消すことができないので、２つのconcを連言でつなぐ。


問題3.2 (教科書p.73)
    関係
       las(Item,List)
    を，ItemがListの最後の要素であるように定義せよ．
(a)conc関係を使うプログラム */
lasa(Item,List) :- conc(_, [Item], List).
/*（実行例）
?- lasa(c,[a,b,c]).
true ;
false.

?- lasa(a,[a,b,c]).
false.

?- lasa(a,[a]).
true ;
false.

?- lasa([a,b,c],c).
false.

[trace]  ?- lasa(c,[a,b,c]).
   Call: (10) lasa(c, [a, b, c]) ? creep
   Call: (11) conc(_3908, [c], [a, b, c]) ? creep
   Call: (12) conc(_4654, [c], [b, c]) ? creep
   Call: (13) conc(_5474, [c], [c]) ? creep
   Exit: (13) conc([], [c], [c]) ? creep % 事実conc([], L, L).と一致
   Exit: (12) conc([b], [c], [b, c]) ? creep
   Exit: (11) conc([a, b], [c], [a, b, c]) ? creep % _=[a, b], Item=c, List=[a, b, c]
   Exit: (10) lasa(c, [a, b, c]) ? creep
true .

(説明)
concを使ってListを２つのリストに分割し、そのうち右側のリストの要素がItemだけであっても成立するかを調べる。conc([X|L1], L2, [X|L3]) :- conc(L1, L2, L3).によりリストの先頭を消去しながら調べている。
*/

% /*(b)concを使わないプログラム*/
lasb(Item,[Item]).
lasb(Item, [Head|Tail]) :- lasb(Item,Tail).

/*（実行例）
?- lasb(c,[a,b,c]).
true ;
false.

?- lasb(a,[a,b,c]).
false.

?- lasb(a,[a]).
true ;
false.

?- lasb([a,b,c],c).
false.

[trace]  ?- lasb(c,[a,b,c]).
   Call: (10) lasb(c, [a, b, c]) ? creep
   Call: (11) lasb(c, [b, c]) ? creep
   Call: (12) lasb(c, [c]) ? creep
   Exit: (12) lasb(c, [c]) ? creep % 事実lasb(Item,[Item]).と一致
   Exit: (11) lasb(c, [b, c]) ? creep
   Exit: (10) lasb(c, [a, b, c]) ? creep
true .

(説明)
Listの先頭を繰り返し消去し、最後にItemの要素だけが残るか調べる。[Head|Tail] :- Tailとすれば先頭要素を消去できる。事実とルールを記述すれば再帰的に呼び出せる。


問題3.4 (教科書p.79)
    リストを逆転させる関係
        rev(List,ReversedList)
    を定義せよ，たとえばrev([a,b,c,d],[d,c,b,a]).

*/
rev([], []).
rev(A, [First|Rest]) :- rev(B, Rest), conc(B, [First], A).
% または rev([First|Rest],A) :- rev(Rest, B), conc(B, [First], A).
/*（実行例）
?- rev([a,b,c,d],[d,c,b,a]).
true.

?- rev([a,b,c,d],[a,b,c,d]).
false.

?- rev([a,b,c,d],[c,b,a]).
false.

[trace]  ?- rev([a,b],[b,a]).
   Call: (10) rev([a, b], [b, a]) ? creep
   Call: (11) rev(_57736, [a]) ? creep
   Call: (12) rev(_58548, []) ? creep
   Exit: (12) rev([], []) ? creep % 事実rev([], []).と一致
   Call: (12) conc([], [a], _57736) ? creep
   Exit: (12) conc([], [a], [a]) ? creep % conc(B, [First], A)が成立
   Exit: (11) rev([a], [a]) ? creep
   Call: (11) conc([a], [b], [a, b]) ? creep
   Call: (12) conc([], [b], [b]) ? creep
   Exit: (12) conc([], [b], [b]) ? creep
   Exit: (11) conc([a], [b], [a, b]) ? creep
   Exit: (10) rev([a, b], [b, a]) ? creep
true.

(説明)
revの中の片方のリストの先頭ともう片方のリストの最後尾が一致するか確認した後、それらの要素を消去する。revの中の２つのリストのどちらかから先頭Firstを消去し、リストBとFirstを連結したら元のリストAになるようにリストBを決める。


問題3.9 (教科書p.79) 
    関係
        dividelist(List,List1,List2)
    を，Listの要素がほぼ同じ長さのList1とList2に分割されるように定義せよ．たとえば
        dividelist([a,b,c,d,e],[a,c,e],[b,d]).
*/
dividelist([],[],[]).
dividelist([X],[X],[]).
dividelist([X,Y|List1],[X|List2],[Y|List3]) :- dividelist(List1,List2,List3).
/*（実行例）
?- dividelist([a,b,c,d],[a,c],[b,d]).
true.

?- dividelist([a,b,c,d,e],[a,c,e],[b,d]).
true ;
false.

?- dividelist([a,b,c,d],[a,b],[c,d]).
false.

?- dividelist([a,b,c,d],[a,c,e],[b,d]).
false.

?- dividelist([a,b,c,d,e],[b,d],[a,c,e]).
false.

[trace]  ?- dividelist([a,b,c,d,e],[a,c,e],[b,d]).
   Call: (10) dividelist([a, b, c, d, e], [a, c, e], [b, d]) ? creep
   Call: (11) dividelist([c, d, e], [c, e], [d]) ? creep
   Call: (12) dividelist([e], [e], []) ? creep
   Exit: (12) dividelist([e], [e], []) ? creep % 事実dividelist([X],[X],[]).と一致
   Exit: (11) dividelist([c, d, e], [c, e], [d]) ? creep
   Exit: (10) dividelist([a, b, c, d, e], [a, c, e], [b, d]) ? creep
true .

(説明)
左のリストの先頭と真ん中のリストの先頭が一致するかどうか、左のリストの先頭の次の要素と右のリストの先頭が一致するかどうかを確認した後、それらの要素を消去する。左のリストの要素が偶数の場合はすべての要素が消え、左のリストの要素が奇数の場合は真ん中のリストに多く分配するため、事実はdividelist([],[],[]).とdividelist([X],[X],[]).の２つを用意する。
*/

