-module(write_to_file).
-export([write_file/3]).

write_file(Name, Mode, Data) ->
    {ok, Device} = file:open(Name, Mode),
    io:format(Device, "~p~n", [Data]),
    file:close(Device).
