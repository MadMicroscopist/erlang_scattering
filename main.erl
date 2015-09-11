-module(main).
-export([start/1, counter/2, loop/0, stop/1]).

start(N_e) ->
    register(server, self()),
    spawn(main, counter, [N_e,[]]),
    receive
        {message, Msg} ->
            io:format("Recieved message ~p", Msg);
        {stop, List} ->
            List
        after 1000 ->
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
