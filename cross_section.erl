-module(cross_section).
-export([fill_cs_table/1]).

fill_cs_table(FileName) -> fill_cs_table(FileName, read).

read_file(Name, Mode) ->
    {ok, Device} = file:open(Name, Mode),
    read_each_line(Device, []).

read_each_line(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), lists:reverse(Accum);
        Line -> read_each_line(Device, [string:tokens(Line, "\n ") | Accum])
    end.

fill_cs_table(FileName, Mode) ->
    List = read_file(FileName, Mode),
    %mixer:mixer(List). %function, wich makes a list of turples from list of lists.
    probability:calculate(mixer:mixer(List)).
