-module(main).
-export([start/1, waiting/1, counter/2, electron/1, watcher/0, stop/1]).
-include("electron.hrl").

%start simulation for N_e electrons
start(N_e) ->
    register(server, spawn(main, waiting, [N_e])).

waiting(N_e) ->
    spawn(main, counter, [N_e,[]]),
    receive
        {stop, List} ->
            io:format("Spawned ~p~n", [List]),
            unregister(server),
            ok;
        _Message ->
            _Message
    end.

counter(0, List) ->
    stop(List);
counter(N_e, List) ->
    Pid = spawn(main, watcher, []),
    counter(N_e-1, [{N_e, Pid}|List]).

watcher() ->
    spawn(main, electron, [self()]),
    receive
        {Pid, Msg} ->
            io:format("Message ~p received from ~p~n", [Msg, Pid]);
        _Other ->
            _Other
        end.

electron(Pid) ->
    Electron = #electron{},
    Pid ! {self(), Electron}.


stop(List) ->
    server ! {stop, List}.
