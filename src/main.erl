-module(main).
-export([start/3, waiting/3, counter/4, watcher/2, electron/3]).
-include("electron.hrl").

%start simulation for N_e electrons
start(N_e, Material, Energy) ->
    register(server, spawn(main, waiting, [N_e, Material, Energy])).

waiting(N_e, Material, Energy) ->
    spawn(main, counter, [N_e,[], Material, Energy]),
    receive
        {stop, _List} ->
            %io:format("Spawned ~p~n", [List]),
            unregister(server),
            ok;
        _Message ->
            _Message
    end.

counter(0, List, _Material, _Energy) ->
    stop(List);
counter(N_e, List, Material, Energy) ->
    Pid = spawn(main, watcher, [Material, Energy]),
    counter(N_e-1, [{N_e, Pid}|List], Material, Energy).

watcher(Material, Energy) ->
    spawn(main, electron, [self(), Material, Energy]),
    receive
        {_Pid, {_, bse, _, _, {X,Y}, _ }} ->
            %io:format("BSE-message from coordinates of ~p received from ~p~n", [{X,Y}, Pid]),
            write_file("../data/"++"test_write.dat", [read,write, append], [X, Y]);
        {_Pid, _Msg} ->
                ok
        end.

electron(Pid, Material, Energy) ->
    Electron = #electron{el_energy = Energy},
    M = cross_section:fill_cs_table("eMcs" ++ Material++ ".dat"),
    Mat = material:choise(Material),
    NewElectron = electron:scattering(Electron, M, Mat),
    %NewElectron = {1.0e3, 0.75, searcher:search(1.0e3, 0.75, cross_section:fill_cs_table("eMcsAl.dat"))},
    Pid ! {self(), NewElectron}.


stop(List) ->
    server ! {stop, List}.

write_file(Name, Mode, Data) ->
    {ok, Device} = file:open(Name, Mode),
    io:format(Device, "~p~n", [Data]),
    file:close(Device).
