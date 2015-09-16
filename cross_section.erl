-module(cross_section).
-export([create_tables/1, close_tables/0, add_cs/1, get_cs/1]).

create_tables(FileName) ->
    ets:new(csMott, [named_table]),
    dets:open_file(usrDisk, [{file, FileName}]).

close_tables() ->
    ets:delete(csMott),
    dets:close(usrDisk).

add_cs(CS) ->
    ets:insert(csMott, CS),
    dets:insert(usrDisk, CS),
    ok.

get_cs({Energy, Angle}) ->
    case ets:lookup(csMott, {Energy, Angle}) of
        [{{Energy, Angle}, Value}] -> {ok, Value};
        [] -> {error, instance}
    end.
