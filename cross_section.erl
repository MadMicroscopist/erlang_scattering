-module(cross_section).
-export([create_tables/1, close_tables/0, fill_cs_table/2, get_cs/1]).

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
    Normal_list = probability:calculate(mixer:mixer(List)),
    filling(Normal_list),
    ok.

filling(List) ->
    case List of
        [] -> ok;
        _  -> fill_line(hd(List)), filling(tl(List))
    end.

fill_line(List) ->
    case List of
        [] -> ok;
        _  -> add_cs({{element(1, hd(List)), element(2, hd(List))}, element(3, hd(List))}), fill_line(tl(List))
    end.
