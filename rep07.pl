% rep05: 第7回 演習課題レポート
% 提出日: 2024年5月19日
% 学籍番号: 34714037
% 名前: 加藤薫
%
/*
問題7.3 (教科書p.175)

    述語ground(Term)を，具体化されていない変数がTermに含まれない
    なら真となるように定義せよ．
*/
gnd(Term) :-
    nonvar(Term),       % Term is not a variable
    Term =.. [F|Args],          % Decompose the term into a list
    check_all_ground(Args). % Check if all elements of the list are ground

% Helper predicate to check if all elements of the list are ground
check_all_ground([]).       % Base case: empty list is ground
check_all_ground([H|T]) :-
    gnd(H),              % Check if head is ground
    check_all_ground(T).    % Recursively check the tail

/*（実行例）
atom(F1),
    Args = [F2|_],
    (var(F2),!,fail);
    gnd(F2).

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


(説明)
traceの実行結果からも分かるように、マッチする場合はnaf(First=Term)でfailが呼び出され下のルールcanunify([First|Rest],Term,[First|List]) :- canunify(Rest,Term,List).を適用して第一引数を第三引数の結果リストに追加している。マッチしない場合はnaf(First=Term)でtrueとなり、下のルールを呼び出さないようにカットして後ろにあるcanunify(Rest,Term,List)が実行される。要素を消去していって第一引数と第三引数が空になれば成功である。
ちなみに下のように値を具体化しても述語の出力結果としては正しくできた。
canunify2([First|Rest],Term,[First|List]) :- First=Term,!,canunify(Rest,Term,List). 
canunify2([First|Rest],Term,List) :- canunify(Rest,Term,List). 
*/