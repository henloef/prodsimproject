function [ K, fi ] = global_K_internal_force(Edof, Coord_0, a, ep)
% [K, fi]=global_K_internal_force( Edof, Coord_0, a, ep )
%--------------------------------------------------------------------
% PURPOSE
%  Returns the area and second moment of inertia of a circular section
%
% INPUT:  Edof = topology matrix
%         Coord_0 = original global coordinate matrix
%         a = total displacement
%         ep = [E A I] modulus of elasticity, area, moment of inertia
% OUTPUT: K = global stiffness matrix
%         fi = global internal forces
%--------------------------------------------------------------------
total_dof = size(Coord,1)*3;
n_elements = size(Edof,1);
K = zeros(total_dof);
fi = zeros(total_dof, 1);

for i=1:n_elements
    %% This section is not finished
    % Elements stiffness matrix
    ex = transpose(Coord(i:i+1,1));
    ey = transpose(Coord(i:i+1,2));
    Ke = nonlinbeam2e(ex, ey, ep);
    % Add to global stiffness matrix
    K = assem(Edof(i,:), K, Ke);

end

