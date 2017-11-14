
function [Edof, node_coords, dof] = utkrager(n_elements) 
% [Edof, node_coords, dof] = utkrager() 
%--------------------------------------------------------------------
% PURPOSE
% Generate a simple beam element with the one end fixed
% OUTPUT: Edof = topology matrix
%         node_coords = global coordinate matrix
%         dof = global nodal dof matrix
%--------------------------------------------------------------------
R = 1000; %mm radius
H = 400; %mm height
h = 10; %mm thickness
L = 100; %mm distance between hinges
E = 2.1e5; %N/mm^2 elastic modulus
    if n_elements == 1
        Edof = [1 1 2 3 4 5 6];
        node_coords = [0 0; L 0];
        dof = [1 2 3;
               4 5 6];
    elseif n_elements == 2
        Edof = [1 1 2 3 4 5 6;
                2 4 5 6 7 8 9];
        node_coords = [0 0; L/2 0; L 0];
        dof = [1 2 3;
               4 5 6;
               7 8 9];
    end
end