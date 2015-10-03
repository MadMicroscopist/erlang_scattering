-module(electron).
-export([scattering/2]).
-include("electron.hrl").

scattering(Electron, Counter) ->
    %instant state of scattering angles and step lenght are taken by random number generation
    seed_random(),
    Theta = 3.14159*get_random(),
    Phi = 2*3.14159*get_random() - 3.14159,
    Lenght = 10*get_random(),
    %scattering evaluation
    New2 = step(Lenght, rotate(Theta, Phi, Electron)),
    %scattering result observation
    case New2#electron.el_flag of
        bse ->                              %if electron flag in scattering act was changed to bse, return current state and message about x and y coordinates of its exit point
            io:format("Backscattering happens, exit coordinates are: x  ~p, y ~p~n", [element(1,New2#electron.el_xy_coor),element(2,New2#electron.el_xy_coor)]),
            New2;
        primary when Counter > 0 ->         %if electron flag save the same value, print its current stage and evaluate call of scattering function from curren electron state
            io:format("Scattering result is ~p~n", [New2]),
            scattering(New2, Counter-1);
        _Other ->                           %if any other state was received, return current electron state. It's place for error handler.
            New2
    end.

rotate(Theta, Phi, Electron) ->
    S = math:sin(Theta),
    C = math:cos(Theta),
    Cp = math:cos(Phi),
    CC = C*Cp,
    CS = C*math:sin(Phi),
    SC = S*Cp,
    SS = S*math:sin(Phi),
    %calculation of electron rotational matrix changes because of scattering on Theta and Phi angles
    E1 = 	CC * element(1,Electron#electron.el_r_matrix) 	+ CS * element(1+3,Electron#electron.el_r_matrix) 	- S * element(1+6,Electron#electron.el_r_matrix),
    E4 = 	-S * element(1,Electron#electron.el_r_matrix) + Cp * element(1+3,Electron#electron.el_r_matrix),
    E7 =  	SC * element(1,Electron#electron.el_r_matrix) 	+ SS * element(1+3,Electron#electron.el_r_matrix) 	+ C * element(1+6,Electron#electron.el_r_matrix),
    E2 = 	CC * element(2,Electron#electron.el_r_matrix) 	+ CS * element(2+3,Electron#electron.el_r_matrix) 	- S * element(3+6,Electron#electron.el_r_matrix),
    E5 = 	-S * element(2,Electron#electron.el_r_matrix) + Cp * element(2+3,Electron#electron.el_r_matrix),
    E8 =  	SC * element(2,Electron#electron.el_r_matrix) 	+ SS * element(2+3,Electron#electron.el_r_matrix) 	+ C * element(3+6,Electron#electron.el_r_matrix),
    E3 = 	CC * element(3,Electron#electron.el_r_matrix) 	+ CS * element(3+3,Electron#electron.el_r_matrix) 	- S * element(3+6,Electron#electron.el_r_matrix),
    E6 = 	-S * element(3,Electron#electron.el_r_matrix) + Cp * element(3+3,Electron#electron.el_r_matrix),
    E9 =  	SC * element(3,Electron#electron.el_r_matrix) 	+ SS * element(3+3,Electron#electron.el_r_matrix) 	+ C * element(3+6,Electron#electron.el_r_matrix),

    Electron#electron{el_r_matrix = {E1,E2,E3,E4,E5,E6,E7,E8,E9}}.

step(Lenght, Electron) ->
    Z_temp = element(9,Electron#electron.el_r_matrix)*Lenght + Electron#electron.el_z_coor,     %calculation of temporary electron Z coordinate
    case (Z_temp =< 0) of
        true when Electron#electron.el_z_coor>0 ->   %if Z will negative and its previous sate was positive (its not first scattering), cut electron trajectory to 0 and recalculate corresponding step lenght
            NewLenght = Lenght* Electron#electron.el_z_coor/(Electron#electron.el_z_coor - Z_temp),
            NewZ = 0,
            NewX	= element(1, Electron#electron.el_xy_coor) + element(7, Electron#electron.el_r_matrix) * NewLenght,
            NewY	= element(2, Electron#electron.el_xy_coor) + element(8, Electron#electron.el_r_matrix) * NewLenght,
            NewFlag = bse,
            Electron#electron{el_flag = NewFlag, el_z_coor = NewZ, el_xy_coor = {NewX, NewY}};
        true ->     %this case means what electron's first scattering gives us backscattering
            NewFlag = bse,
            Electron#electron{el_flag = NewFlag};
        false ->    %it's a usual scattering act without backscattering
            NewZ = Z_temp,
            NewX	= element(1, Electron#electron.el_xy_coor) + element(7, Electron#electron.el_r_matrix) * Lenght,
            NewY	= element(2, Electron#electron.el_xy_coor) + element(8, Electron#electron.el_r_matrix) * Lenght,
            Electron#electron{el_z_coor = NewZ, el_xy_coor = {NewX, NewY}}
    end.
%random number generation seed
seed_random() ->
    random:seed(erlang:phash2([node()]),
	              erlang:monotonic_time(),
		      erlang:unique_integer()).
%generate a float random number from 0 to 1.0              
get_random() ->
    random:uniform().
