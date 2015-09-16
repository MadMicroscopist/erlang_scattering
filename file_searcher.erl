-module(file_searcher).
-export([read_file/2, read_each_line/2]).
-define(Punctuation,"[ | , | \\ . | ; | : | \\ t | \\ n | \\ ( | \\ ) ] + " ).

read_file(Name, Mode) ->
    {ok, Device} = file:open(Name, Mode),
    read_each_line(Device, []).

read_each_line(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), lists:reverse(Accum);
        Line -> read_each_line(Device, [re:split(Line, ?Punctuation) | Accum])
    end.
