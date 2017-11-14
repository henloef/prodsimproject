
function [Edof, node_coords, dofs] = utkrager(n_elements) 
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
n_nodes = n_elements+1;

Edof = zeros(n_elements, 7);
node_coords = zeros(n_nodes, 2);
dofs = zeros(n_nodes, 3);

    dof = 1;
    for i = 1:n_elements
        Edof(i,:) = [i dof dof+1 dof+2 dof+3 dof+4 dof+5];
        dof = dof + 3;
    end    
    dof = 1;
    for i = 1:n_nodes        
        node_coords(i,:) = [(i-1)/(n_nodes-1)*L 0];
        dofs(i,:) = [dof dof+1 dof+2];
        dof = dof + 3;
    end

end