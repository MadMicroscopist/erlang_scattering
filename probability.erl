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

h_calc({E, Angle, Value}) ->
    A = Angle*math:pi()/180,
    {E, Angle, Value*A*math:sin(A)}.

t_calc(List, Head) ->
    calc(hd(List), Head, tl(List), [Head]).

calc({E, Angle2, Value2}, {_, Angle1, _Value1}, List, NewList)->
    case Angle2 of
        180.0 ->[{E, Angle2, Value2*(Angle2-Angle1)*math:pi()/180*math:sin((Angle2-1)*math:pi()/180)}|NewList];
        _  -> calc(hd(List), {E, Angle2, Value2}, tl(List), [{E, Angle2, Value2*(Angle2-Angle1)*math:pi()/180*math:sin(Angle2*math:pi()/180)}|NewList])
    end.
