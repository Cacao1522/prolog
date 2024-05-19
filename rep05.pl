% rep05: 第5回 演習課題レポート
% 提出日: 2024年5月19日
% 学籍番号: 34714037
% 名前: 加藤薫
%
/*
問題5.2 (教科書p.133)

    次の関係は正数，零，負数の３つに数を分類する．
        class(Number,positive) :- Number>0.
        class(0,zero).
        class(Number,negative) :- Number<0.
    この手続きを，カットを使ってもっと効率的に定義せよ．
*/
class(Number,positive) :- Number>0,!.
class(0,zero) :- !.
class(Number,X) :- Number>=0,!,fail.
class(Number,negative) .

/*（実行例）
?- class(1,positive).
true.

?- class(0,positive).
false.

?- class(-1,positive).
false.

?- class(1,zero).
false.

?- class(0,zero).
true.

?- class(-1,zero).
false.

?- class(1,negative).
false.

?- class(0,negative).
false.

?- class(-1,negative).
true.

?- class(1,X).
X = positive.

?- class(0,X).
X = zero.

?- class(-1,X).
X = negative.

(説明)
カットを使わない場合と比べると一番下のルールclass(Number,negative).はNumberのチェックを省略できるという点で効率的に定義できている。
教科書の例解だと?- class(1,negative).と?- class(0,negative).の質問でtrueになってしまう。これは上２つのルールを満たさない場合はすべて一番下のルールに流れてしまうからである。
解決するには一番下のルールをclass(Number,negative) :- Number<0.とするか、class(0,zero) :- !.の後でNumberが0以上のものをはじくためにclass(Number,X) :- Number>=0,!,fail.を実行するといいと思う。

問題5.3 (教科書p.133)  

    数のリストを正数のリスト（0も含む）と，負のリストに分割する手続き
        split(Numbers,Positives,Negatives)
    を定義せよ．たとえば，
        split([3,-1,0,5,-2],[3,0,5],[-1,-2])
    カットを使うプログラム splitA/3 と，使わないプログラム splitB/3 の２つを考えよ．
*/
splitA([],[],[]). % % 最後にすべての引数が空になれば成功
splitA([X|L],[X|L1],L2) :- X>=0,!,splitA(L,L1,L2). % 第一引数の要素が正の場合、第二引数に追加
splitA([X|L],L1,[X|L2]) :- splitA(L,L1,L2). % 第一引数の要素が負の場合、第三引数に追加

splitB([],[],[]).
splitB([X|L],[X|L1],L2) :- X>=0,splitB(L,L1,L2).
splitB([X|L],L1,[X|L2]) :- X<0,splitB(L,L1,L2).

/*（実行例）
?- splitA([-1,0,3],[0,3],[-1]).
true.

?- splitA([-1,0,3],[3],[0,-1]).
false.

?- splitA([-1,0,3],[3,0],[-1]).
false.

?- splitA([-1,0,3],[0,2],[-1]).
false.

?- splitB([1,0,3],[1,0,3],[]).
true ;
false.

?- splitB([1,0,3],[1,3],[0]).
false.

[trace]  ?- splitA([-1,-2,3],X,Y).
   Call: (12) splitA([-1, -2, 3], _297438, _297440) ? creep
   Call: (13) -1>=0 ? creep
   Fail: (13) -1>=0 ? creep
   Redo: (12) splitA([-1, -2, 3], _297438, _297440) ? creep
   Call: (13) splitA([-2, 3], _297438, _301288) ? creep
   Call: (14) -2>=0 ? creep
   Fail: (14) -2>=0 ? creep
   Redo: (13) splitA([-2, 3], _297438, _301288) ? creep
   Call: (14) splitA([3], _297438, _304548) ? creep
   Call: (15) 3>=0 ? creep
   Exit: (15) 3>=0 ? creep
   Call: (15) splitA([], _305368, _304548) ? creep
   Exit: (15) splitA([], [], []) ? creep
   Exit: (14) splitA([3], [3], []) ? creep
   Exit: (13) splitA([-2, 3], [3], [-2]) ? creep
   Exit: (12) splitA([-1, -2, 3], [3], [-1, -2]) ? creep
X = [3],
Y = [-1, -2].

[trace]  ?- splitB([-1,-2,3],X,Y).
   Call: (12) splitB([-1, -2, 3], _332616, _332618) ? creep
   Call: (13) -1>=0 ? creep
   Fail: (13) -1>=0 ? creep
   Redo: (12) splitB([-1, -2, 3], _332616, _332618) ? creep
   Call: (13) -1<0 ? creep
   Exit: (13) -1<0 ? creep
   Call: (13) splitB([-2, 3], _332616, _336438) ? creep
   Call: (14) -2>=0 ? creep
   Fail: (14) -2>=0 ? creep
   Redo: (13) splitB([-2, 3], _332616, _336438) ? creep
   Call: (14) -2<0 ? creep
   Exit: (14) -2<0 ? creep
   Call: (14) splitB([3], _332616, _341318) ? creep
   Call: (15) 3>=0 ? creep
   Exit: (15) 3>=0 ? creep
   Call: (15) splitB([], _343758, _341318) ? creep
   Exit: (15) splitB([], [], []) ? creep
   Exit: (14) splitB([3], [3], []) ? creep
   Exit: (13) splitB([-2, 3], [3], [-2]) ? creep
   Exit: (12) splitB([-1, -2, 3], [3], [-1, -2]) ? creep
X = [3],
Y = [-1, -2] ;
   Redo: (14) splitB([3], _332616, _341318) ? creep
   Call: (15) 3<0 ? creep
   Fail: (15) 3<0 ? creep
   Fail: (14) splitB([3], _332616, _341318) ? creep
   Fail: (13) splitB([-2, 3], _332616, _336438) ? creep
   Fail: (12) splitB([-1, -2, 3], _332616, _332618) ? creep
false.

(説明)
第一引数の要素を順に調べ、要素が正の場合は第二引数に追加し、要素が負の場合は第三引数に追加する。
カットを使う場合はX>=0を満たす場合、下のルールは探索されず、下のルールはX>=0を満たさない場合、つまりX<0の場合のみ実行されるため、下のルールにX<0を加える必要はない。
カットを使和ない場合はX>=0を満たす場合も下のルールは探索されるため、当然下のルールにX<0を加える必要がある。

問題5.6 (教科書p.137)  

        canunify(List1,Term,List2)

    という述語を定義せよ．ここで，List2はTermとマッチする
    List1の要素から作られるリストである．
    ただし，このマッチによって値の具体化はなされないとする．
    例えば，

        ?- canunify([X,b,t(Y)],t(a),List).
        List=[X,t(Y)]

    X,Yとt(a)とのマッチによって具体化が生じるけれども，
    X,Yは具体化されてはいけない点に注意せよ．
*/
naf(P) :- P,!,fail.
naf(_).
canunify([],_,[]). % 最後に第一引数と第三引数が空になれば成功
canunify([First|Rest],Term,List) :- naf(First=Term),!,canunify(Rest,Term,List). % First=Termが成立しない場合はカット
canunify([First|Rest],Term,[First|List]) :- canunify(Rest,Term,List). % First=Termが成り立つ場合、つまりマッチする場合は第一引数を第三引数に追加

/*（実行例）
?- canunify([X,a,b,t(Y),t(t(A))],b,Z).
Z = [X, b].

?- canunify([X,b,t(Y)],t(a),[X]).
false.

?- canunify([X,b,t(Y)],t(a),[X,b,t(Y)]).
false.

[trace]  ?- canunify([X,b,t(Y)],t(a),List).
   Call: (12) canunify([_9270, b, t(_9282)], t(a), _9300) ? creep
   Call: (13) naf(_9270=t(a)) ? creep
   Call: (14) _9270=t(a) ? creep
   Exit: (14) t(a)=t(a) ? creep
   Call: (14) fail ? creep
   Fail: (14) fail ? creep
   Fail: (13) naf(_9270=t(a)) ? creep
   Redo: (12) canunify([_9270, b, t(_9282)], t(a), _9300) ? creep
   Call: (13) canunify([b, t(_9282)], t(a), _16408) ? creep
   Call: (14) naf(b=t(a)) ? creep
   Call: (15) b=t(a) ? creep
   Fail: (15) b=t(a) ? creep
   Redo: (14) naf(b=t(a)) ? creep
   Exit: (14) naf(b=t(a)) ? creep
   Call: (14) canunify([t(_9282)], t(a), _16408) ? creep
   Call: (15) naf(t(_9282)=t(a)) ? creep
   Call: (16) t(_9282)=t(a) ? creep
   Exit: (16) t(a)=t(a) ? creep
   Call: (16) fail ? creep
   Fail: (16) fail ? creep
   Fail: (15) naf(t(_9282)=t(a)) ? creep
   Redo: (14) canunify([t(_9282)], t(a), _16408) ? creep
   Call: (15) canunify([], t(a), _27734) ? creep
   Exit: (15) canunify([], t(a), []) ? creep % 第一引数と第三引数が空になったので成功
   Exit: (14) canunify([t(_9282)], t(a), [t(_9282)]) ? creep
   Exit: (13) canunify([b, t(_9282)], t(a), [t(_9282)]) ? creep
   Exit: (12) canunify([_58, b, t(_60)], t(a), [_58, t(_60)]) ? creep
List = [X, t(Y)].

(説明)
traceの実行結果からも分かるように、マッチする場合はnaf(First=Term)でfailが呼び出され下のルールcanunify([First|Rest],Term,[First|List]) :- canunify(Rest,Term,List).を適用して第一引数を第三引数の結果リストに追加している。マッチしない場合はnaf(First=Term)でtrueとなり、下のルールを呼び出さないようにカットして後ろにあるcanunify(Rest,Term,List)が実行される。要素を消去していって第一引数と第三引数が空になれば成功である。
ちなみに下のように値を具体化しても述語の出力結果としては正しくできた。
canunify2([First|Rest],Term,[First|List]) :- First=Term,!,canunify(Rest,Term,List). 
canunify2([First|Rest],Term,List) :- canunify(Rest,Term,List). 
*/