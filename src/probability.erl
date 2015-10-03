-module(probability).
-export([calculate/1]).

calculate(List) -> calculate(List, []).

calculate(List, NewList) ->
    case List of
        [] -> lists:reverse(NewList);
        _ -> calculate(tl(List), [calculate_single(hd(List))|NewList])
    end.

calculate_single(List) ->
    lists:reverse([lists:last(List)|t_calc(tl(List), h_calc(hd(List)))]).
%this function recalculate the first element of a list seperately
h_calc({E, Angle, Value}) ->
    A = Angle*math:pi()/180,
    {E, Angle, Value*A*math:sin(A)}.

t_calc(List, Head) ->
    calc(hd(List), Head, tl(List), [Head], element(3, Head), [element(3, Head)]).
%this function recalculates cross section values
calc({E, Angle2, Value2}, {_, Angle1, _Value1}, List, NewList, Accum, Acc_list)->
    case Angle2 of
        180.0 -> Temp = Value2*(Angle2-Angle1)*math:pi()/180*math:sin((Angle2-1)*math:pi()/180), sort([{E, Angle2, Temp}|NewList], [Temp+Accum|Acc_list], Temp+Accum, []);
        _  -> Temp = Value2*(Angle2-Angle1)*math:pi()/180*math:sin(Angle2*math:pi()/180), calc(hd(List), {E, Angle2, Temp}, tl(List), [{E, Angle2, Temp}|NewList], Accum+Temp, [Accum+Temp|Acc_list])
    end.
%this function normalizes probability values list
sort(List, Accum, V, NewList) ->
    case List of
        [] -> lists:reverse(NewList);
        _ -> sort(tl(List), tl(Accum), V, [setelement(3, hd(List), hd(Accum)/V)|NewList])
    end.
