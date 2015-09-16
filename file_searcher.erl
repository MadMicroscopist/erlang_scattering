-module(file_searcher).
-export([read_file/2]).

read_file(Name, Mode) ->
    {ok, Device} = file:open(Name, Mode),
    read_charachters(Device, []).
    %read_each_line(Device, []).

read_each_line(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), array:from_list(lists:reverse(Accum));
        Line -> read_each_line(Device, [Line | Accum])
    end.

read_charachters(Device, Accum) ->
    case file:read(Device, 40) of
        newline -> read_charachters(Device, [[]|Accum]);
        eof -> file:close(Device), lists:reverse(Accum);
        Char -> read_charachters(Device, [Char|Accum])
    end.
