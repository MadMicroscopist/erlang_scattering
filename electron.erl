-module(electron).
-export([rotate/3]).
-include("electron.hrl").

rotate(Theta, Phi, Electron) ->
    S = math:sin(Theta),
    C = math:cos(Theta),
    Cp = math:cos(Phi),
    CC = C*Cp,
    CS = C*math:sin(Phi),
    SC = S*Cp,
    SS = S*math:sin(Phi),

    E1 = 	CC * element(1,Electron#electron.el_r_matrix) 	+ CS * element(1+3,Electron#electron.el_r_matrix) 	- S * element(1+6,Electron#electron.el_r_matrix),
    E4 = 	-S * element(1,Electron#electron.el_r_matrix) + Cp * element(1+3,Electron#electron.el_r_matrix),
    E7 =  	SC * element(1,Electron#electron.el_r_matrix) 	+ SS * element(1+3,Electron#electron.el_r_matrix) 	+ C * element(1+6,Electron#electron.el_r_matrix),
    E2 = 	CC * element(2,Electron#electron.el_r_matrix) 	+ CS * element(2+3,Electron#electron.el_r_matrix) 	- S * element(3+6,Electron#electron.el_r_matrix),
    E5 = 	-S * element(2,Electron#electron.el_r_matrix) + Cp * element(2+3,Electron#electron.el_r_matrix),
    E8 =  	SC * element(2,Electron#electron.el_r_matrix) 	+ SS * element(2+3,Electron#electron.el_r_matrix) 	+ C * element(3+6,Electron#electron.el_r_matrix),
    E3 = 	CC * element(3,Electron#electron.el_r_matrix) 	+ CS * element(3+3,Electron#electron.el_r_matrix) 	- S * element(3+6,Electron#electron.el_r_matrix),
    E6 = 	-S * element(3,Electron#electron.el_r_matrix) + Cp * element(3+3,Electron#electron.el_r_matrix),
    E9 =  	SC * element(3,Electron#electron.el_r_matrix) 	+ SS * element(3+3,Electron#electron.el_r_matrix) 	+ C * element(3+6,Electron#electron.el_r_matrix),

    NewElectron = Electron#electron{el_r_matrix = {E1,E2,E3,E4,E5,E6,E7,E8,E9}},
    io:format("Rotation result is ~p~n", [NewElectron]).
