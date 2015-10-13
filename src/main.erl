-module(main).
-export([start/2, waiting/2, counter/3, watcher/1, electron/2]).
-include("electron.hrl").

%start simulation for N_e electrons
start(N_e, Material) ->
    register(server, spawn(main, waiting, [N_e, Material])).

waiting(N_e, Material) ->
    spawn(main, counter, [N_e,[], Material]),
    receive
        {stop, List} ->
            io:format("Spawned ~p~n", [List]),
            unregister(server),
            ok;
        _Message ->
            _Message
    end.

counter(0, List, _Material) ->
    stop(List);
counter(N_e, List, Material) ->
    Pid = spawn(main, watcher, [Material]),
    counter(N_e-1, [{N_e, Pid}|List], Material).

watcher(Material) ->
    spawn(main, electron, [self(), Material]),
    receive
        {Pid, Msg} ->
            io:format("Message ~p received from ~p~n", [Msg, Pid]);
        _Other ->
            _Other
        end.

electron(Pid, Material) ->
    Electron = #electron{},
    M = cross_section:fill_cs_table("eMcs" ++ Material++ ".dat"),
    Mat = material:choise(Material),
    NewElectron = electron:scattering(Electron, 10, M, Mat),
    %NewElectron = {1.0e3, 0.75, searcher:search(1.0e3, 0.75, cross_section:fill_cs_table("eMcsAl.dat"))},
    Pid ! {self(), NewElectron}.


stop(List) ->
    server ! {stop, List}.
