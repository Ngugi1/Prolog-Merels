:- use_module([library(lists),
            io]).
%%%% 3.4 BOARD REPRESENTATION 
% Player one is just player one  
is_player1('A').
is_player2('B').

% Checks if a Character is either of the players' character
is_merel(Character) :- 
    is_player1(Character).
is_merel(Character) :- 
    is_player2(Character).

% Check that Player1 and Player2 are different and that
other_player(Player1, Player2) :-
    is_merel(Player1),
    is_merel(Player2),
    Player1 \= Player2.
%  Points on the baord 
% Begin defining points on board 
point(a).
point(b).
point(c).
point(d).
point(e).
point(f).
point(g).
point(h).
point(i).
point(j).
point(k).
point(l).
point(m).
point(n).
point(o).
point(p).
point(q).
point(r).
point(s).
point(t).
point(u).
point(v).
point(w).
point(x).

% End definition of points on board
% A valid pair represents a valid merel and a valid point on the board.
pair(point_merel(Point,Merel), Point, Merel) :- 
    is_merel(Merel),
    point(Point).



%%%% Begin defining rows  - horizontal
row(a,b,c).
row(d,e,f).
row(g,h,i).
row(j,k,l).
row(m,n,o).
row(p,q,r).
row(s,t,u).
row(v,w,x).

%%%% Begin defining rows  - vertical
row(a,j,v).
row(d,k,s).
row(g,l,p).
row(b,e,h).
row(q,t,w).
row(i,m,r).
row(f,n,u).
row(c,o,x).

%%% End defining vertical and horizontal rows 

% %%%%% Defining connected points 
connected(a,b).
connected(a,j).

connected(b, a).
connected(b, e).
connected(b,c).

connected(c, b).
connected(c, o).

connected(d,e).
connected(d,k).

connected(e, d).
connected(e, f).
connected(e, h).
connected(e, b).

connected(f, e).
connected(f, n).

connected(g, h).
connected(g, l).

connected(h, g).
connected(h,i).
connected(h,e).

connected(i, h).
connected(i, m).

connected(j, a).
connected(j, k).
connected(j,v).

connected(k,j).
connected(k,l).
connected(k,d).
connected(k,s).

connected(l,k).
connected(l,g).
connected(l,p).

connected(m,n).
connected(m, r).
connected(m, i).

connected(n,m).
connected(n,u).
connected(n,f).
connected(n,o).

connected(o, n).
connected(o, c).
connected(o, x).

connected(p,l).
connected(p,q).

connected(q, r).
connected(q, p).
connected(q,t).

connected(r, q).
connected(r, m).

connected(s,k).
connected(s,t).

connected(t,s).
connected(t, q).
connected(t, u).
connected(t, w).

connected(u, t).
connected(u, n).

connected(v, j).
connected(v, w).

connected(w, v).
connected(w,x).
connected(w,t).


connected(x, w).
connected(x,o).

%%%% End defining the connected points 

%%% Board is represented as a pair of player and points they have occupied on the board - initially, the board is empty 
initial_board([]).
%%%%%% 

%%% You lose if you have two pieces left  

% and_the_winner_is(Board, Player) :- 
%     findall(Player ,merel_on_board(point_merel(Point, Player), Board), Pieces1)).
%     % Pieces1 > 2,
    % other_player(Player, Other),
    % findall(Other ,merel_on_board(point_merel(Point1, Other), Board), Pieces2)),
    % length(Pieces1) < 3. 

%%%%%% merel_on_board/2 checks if a merel is on the board 
% If the first element on the board is the pair we are looking for, succeed if it actually represents a valid merel_point
% . The merel is on the board
merel_on_board(point_merel(_Point, _Merel), []) :- fail.

% If the Head is not the pair we are looking for, we keep looking into the rest of the list
merel_on_board(point_merel(Point, Merel), [point_merel(Point, Merel)|_Tail]).
merel_on_board(point_merel(Point, Merel), [_Head|Tail]) :- 
    merel_on_board(point_merel(Point, Merel), Tail).

%%%%% 
opponent_with_two_merels_on_board(Board, Player) :- 
    is_merel(Player),
    findall(Point, merel_on_board(point_merel(Point, Player), Board), Points),
    length(Points, L),
    L > 2,
    other_player(Player, Other),
    findall(Point1, merel_on_board(point_merel(Point1, Other), Board), Points1),
    length(Points1, L2),
    L2 < 3.

% 


find_connected_points(Points,ConnectedPoints) :- 
    find_connected_points_helper(Points, [], ConnectedPoints).
find_connected_points_helper([], AllPointsSeenSoFar, AllPointsSeenSoFar).
find_connected_points_helper([Point|Rest],ConnectedPointsSoFar, ConnectedPoints) :- 
    findall(Other, connected(Point, Other), Connections),
    append(Connections, ConnectedPointsSoFar, AllPointsSeenSoFar),
    find_connected_points_helper(Rest, AllPointsSeenSoFar, ConnectedPoints).
% Check if the points connected to player merels are empty 

legal_moves(Board, Player, LegalMoves) :- 
    find_player_merels(Board, Player, PlayerMerels),
    find_connected_points(PlayerMerels, ConnectedPoints),
    find_legal_moves(ConnectedPoints, Player, Board, [] ,LegalMoves).

find_legal_moves([],_Player, _Board, FinalMoves, FinalMoves).
find_legal_moves([Point|Rest], Player, Board, LegalMovesSoFar, LegalMoves) :-
    (merel_on_board(point_merel(Point, _),  Board)
     ->
                find_legal_moves(Rest, Player, Board, LegalMovesSoFar, LegalMoves);
                find_legal_moves(Rest, Player, Board, [Point | LegalMovesSoFar], LegalMoves)).
    


find_player_merels(Board, Player, Points) :- 
    % This gets you all merels on a board of a particular player 
    findall(Point, merel_on_board(point_merel(Point, Player), Board), Points).
    % See if this player has any legal moves.
    




and_the_winner_is(Board, Player) :- 
    opponent_with_two_merels_on_board(Board, Player).

and_the_winner_is(Board, Player) :- 
    is_merel(Player),
    legal_moves(Board, Player, LegalMoves),
    length(LegalMoves, L),
    L > 2,
    other_player(Player, Other),
    legal_moves(Board, Other, LegalMoves1),
    length(LegalMoves1, L1),
    L1 < 1.


%%%%%% 3.6 - Running the game with two human players
play :- 
    welcome, 
    initial_board( Board ),
    display_board( Board ),
    is_player1( Player ),
    play(12, Player, Board ).

play(0, Player, Board) :-
     check_winner(Player, Board),
check_winner(Player, Board) :-
    and_the_winner_is(Board, Player),
     report_winner(Player).
    
play(0, Player, Board) :- 
    other_player(Player, Other),
    [point_merel(Point, Other) | _] = Board,
    find_player_merels(Board, Other, Merels),
    check_for_mill(Point, Merels),
    get_remove_point(Other, RPoint, Board),
    delete(Board, point_merel(RPoint, _), NBoard),
    display_board(NBoard),
    % Check if there is a winner
    check_winner(Board)

    % Let the Player now continue 
    get_legal_move(Player, OldPoint, NewPoint, NBoard),
    report_move(Player, OldPoint, NewPoint),
    delete(NBoard, point_merel(OldPoint, Player), UpdatedBoard),
    NewBoard = [point_merel(NewPoint, Player)| UpdatedBoard],
    display_board(NewBoard),
    play(0, Other, NewBoard).

play(0, Player, Board) :-
        get_legal_move(Player, OldPoint, NewPoint, Board),
        report_move(Player, OldPoint, NewPoint),
        delete(Board, point_merel(OldPoint, Player), UpdatedBoard),
        NewBoard = [point_merel(NewPoint, Player)| UpdatedBoard],
        display_board(NewBoard),
        other_player(Player, Other),
        play(0, Other, NewBoard).
% If nobody won, check if the player who just played formed any mills
% check if new mills were formed before the next player starts his game
play(MerelsLeft, Player, Board) :-
    other_player(Player, Other),
    [point_merel(Point, Other) | _] = Board,
    find_player_merels(Board, Other, Merels),
    check_for_mill(Point, Merels),
    get_remove_point(Other, RPoint, Board),
    delete(Board, point_merel(RPoint, _), NBoard),
    display_board(NBoard),

    % Allow the other player to continue
    get_legal_place(Player, LegalPoint, NBoard),
    NewBoard = [point_merel(LegalPoint, Player) | NBoard],
    report_move(Player, LegalPoint),
    NewMerelsLeft is MerelsLeft - 1,
    display_board(NewBoard),
    play(NewMerelsLeft, Other, NewBoard).


play(MerelsLeft, Player, Board) :- 
    get_legal_place(Player, Point, Board),
    NewBoard = [point_merel(Point, Player) | Board],
    report_move(Player, Point),
    display_board(NewBoard),
    other_player(Player, Other),
    NewMerelsLeft is MerelsLeft - 1,
    play(NewMerelsLeft, Other, NewBoard).         

check_for_mill(Point, Merels) :- 
    row(Point, Point1, Point2),
    member(Point1, Merels),
    member(Point2, Merels).

check_for_mill(Point, Merels) :- 
    row(Point1, Point, Point2),
    member(Point1, Merels),
    member(Point2, Merels).

check_for_mill(Point, Merels) :- 
    row(Point1, Point2, Point),
    member(Point1, Merels),
    member(Point2, Merels).
    



    


    


    






