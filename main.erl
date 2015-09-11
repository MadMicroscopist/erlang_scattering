-module(main).
-export([start/1, waiting/1, counter/2, loop/0, stop/1]).

start(N_e) ->
    register(server, spawn(main, waiting, [N_e])).

waiting(N_e) ->
    spawn(main, counter, [N_e,[]]),
    receive
        {message, Msg} ->
            io:format("Recieved message ~p~n", [Msg]);
        {stop, List} ->
            io:format("Process list is ~p~n", [List]),
            unregister(server),
            ok
    end.

stop(List) ->
    server ! {stop, List}.

counter(0, List) ->
    stop(List);
counter(N_e, List) ->
    Pid = spawn(main, loop, []),
    counter(N_e-1, [{N_e, Pid}|List]).

loop() ->
    server ! {message, "hello"}.
