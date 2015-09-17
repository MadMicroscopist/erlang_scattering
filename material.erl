-module(material).
-export([fill_cs_table/2]).
-include("electron.hrl").

fill_cs_table(FileName, Mode) ->
    List = file_searcher:read_file(FileName, Mode),
    mixer(List, []).

mixer([H|T], List) ->
    case T of
        [ ] ->  mixer2(H,List, []);
        [A|B] -> mixer([H|B], mixer1(A, List))
    end.

mixer1([A|B], List) ->
    case B of
        [] -> List;
        [C|T]  -> mixer1([A|T],[{A,C}|List] )
    end.

mixer2([Ha|Ta], [Ht|Tt], List) ->
    case Ta of
        [] -> [mixer3(Tt,[])|List];
        _  -> mixer2(Ta, Tt, [{Ha, Ht}|List])
    end.
mixer3([{A, B}|T],List) ->
    case T of
        [] -> [{{full, A},B}|List];
        _  -> mixer3(T,[{{full, A},B}|List])
    end.
