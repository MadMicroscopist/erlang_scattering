-module(material).
-export([fill_cs_table/2]).
%-import(file_searcher, [read_file/2]).
-include("electron.hrl").
-define(Punctuation,"[ | , | \\ . | ; | : | \\ t | \\ n | \\ ( | \\ ) ] + " ).

read_file(Name, Mode) ->
    {ok, Device} = file:open(Name, Mode),
    read_each_line(Device, []).

read_each_line(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), lists:reverse(Accum);
        Line -> read_each_line(Device, [re:split(Line, ?Punctuation) | Accum])
    end.

fill_cs_table(FileName, Mode) ->
    List = read_file(FileName, Mode),
    mixer:mixer(List). %function, wich makes a list of turples from list of lists.
