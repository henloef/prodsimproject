
function [Edof, node_coords, dof] = utkrager() 
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
n_elements = 1; %number of beam elements
L = 100; %mm distance between hinges
E = 2.1e5; %N/mm^2 elastic modulus

Edof = [1 1 2 3 4 5 6];
node_coords = [0 0; L 0];
dof = [1 2 3;
       4 5 6];