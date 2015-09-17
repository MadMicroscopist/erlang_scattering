-module(material).
-export([fill_cs_table/2]).
%-import(file_searcher, [read_file/2]).
-include("electron.hrl").
-define(Punctuation,"[ | , | \\ . | ; | : | \\ t | \\ n | \\ ( | \\ ) ] + " ).

read_file(Name, Mode) ->
    {ok, Device} = file:open(Name, Mode),
    read_each_line(Device, []).

read_each_line(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), lists:reverse(Accum);
        Line -> read_each_line(Device, [re:split(Line, ?Punctuation) | Accum])
    end.

fill_cs_table(FileName, Mode) ->
    List = read_file(FileName, Mode),
    mixer(List, []).

mixer([H|T], List) ->
    case T of
        [ ] ->  mixer2(H, lists:reverse(List), []);
        [A|B] -> mixer([H|B], [mixer1(A)|List])
    end.

mixer1([A|B]) ->
    case B of
        [] -> [];
        _  -> {A, B}
    end.

mixer2(A, [Ht|Tt], List) ->
    case Tt of
        []  -> lists:reverse(List);
        %[] -> mixer2(A, [Ht], [mixer3(A, Ht, [])|List]);
        _  -> mixer2(A, Tt, [mixer3(A, Ht, [])|List])
    end.
mixer3([H|T],{E, [Hc|Tc]}, List) ->
    case T of
        [] -> lists:reverse([mixer4(E,Tc),{{E,H},Hc}|List]);
        _  -> mixer3( T, {E, Tc}, [{{E,H},Hc}|List])
    end.

mixer4(E,T) ->
    {{E, full}, T}.
