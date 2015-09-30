-module(searcher).
-export([search_value/2]).

search_value({Energy, Angle}, List) ->
    search_energy({Energy, Angle}, List, []).

search_energy({Energy, Angle}, List, E0) ->
    Temp = element(1, element(1, hd(hd(List)))),
    case ( Temp < Energy ) of
        false when Energy < 3.0e4 -> search_angle({medium, E0, hd(List)}, Angle);
        false when Energy == Temp -> search_angle({exact, hd(List)}, Angle);
        true  when Energy < 0.5e1 -> search_angle({exact, hd(List)}, Angle);
        true -> search_energy({Energy, Angle}, tl(List), hd(List))
    end.

search_angle(Data, Angle) ->
    case element(1, Data) of
        exact -> ex;
        medium -> med
    end.
