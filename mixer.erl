-module(mixer).
-export([mixer/1]).

mixer(Main) ->
    mixer3(hd(Main), mixer1(tl(Main),[]), []).

mixer1(Tail, List) ->
    case Tail of
        [] -> lists:reverse(List);
        _  -> mixer1(tl(Tail), [mixer2(hd(Tail))|List])
    end.

mixer2(Energy) ->
    {hd(Energy), lists:delete(lists:last(Energy), tl(Energy)), lists:last(Energy)}.

mixer3(Angle, List1, List) ->
    case List1 of
        [] -> lists:reverse(List);
        _  -> mixer3(Angle, tl(List1), [mixer4(Angle, hd(List1))|List])
    end.

mixer4(Angle, {E, List2, S_full}) ->
    lists:reverse([{erlang:list_to_float(E), full, erlang:list_to_float(S_full)}|mixer5(E, lists:zip(Angle, List2), [])]).

mixer5(E, List3, List) ->
    case List3 of
        [] -> List;
        _  -> mixer5(E, tl(List3), [mixer6(E, hd(List3))|List] )
    end.

mixer6(E, {Angle, Sigma}) ->
    {erlang:list_to_float(E), erlang:list_to_float(Angle), erlang:list_to_float(Sigma)}.
