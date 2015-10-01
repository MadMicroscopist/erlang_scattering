-module(searcher).
%-export([search/3]).
-export([search/3, middle/5]).
search(Energy, Value, List) ->
    search_energy(Energy, Value, List, hd(List)).

search_energy(Energy, Value, List, E0) ->
    Temp = element(1, hd(hd(List))),
    case ( Temp < Energy ) of
        false when Energy < 3.0e4 -> search_value_1(E0, hd(List), Value, Energy);
        false when Energy == Temp -> search_value(hd(List), Value);
        true  when Energy =< 0.5e1 -> search_value(hd(List), Value);
        true -> search_energy(Energy, Value, tl(List), hd(List))
    end.

%function for case of exact energy matching
search_value(List, Value) -> search_value(List, Value, 0, 0).

search_value(List, Value, A0, V0) ->
    Temp = element(3, hd(List)),
    case element(3, hd(List)) > Value of
        false when Temp == Value -> element(2, hd(List));
        false -> middle(A0, V0, element(2, hd(List)), Temp, Value);
        true  -> search_value(tl(List), Value, element(2, hd(List)), Temp)
    end.

%function for case of middle value
search_value_1(Min, Max, Value, Energy) ->
    A = search_value(Min, Value, 0, 0),
    B = search_value(Max, Value, 0, 0),
    middle(A, element(1,hd(Min)), B, element(1, hd(Min)), Energy).

middle(Angle_min, Value_min, Angle_max, Value_max, Value) ->
    (Value*(Angle_max - Angle_min) + Angle_min*Value_max - Angle_max*Value_min)/(Value_max-Value_min).