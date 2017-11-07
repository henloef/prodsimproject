function [ K ] = global_stiffness( Edof, Coord, ep )
% [K]=global_stiffness( Edof, Coord, ep )
%--------------------------------------------------------------------
% PURPOSE
% Generate global stiffness matrix for a structure
%
% INPUT:  Edof = topology matrix
%         Coord = global coordinate matrix
%         ep = [E A I] modulus of elasticity, area, moment of inertia
% OUTPUT: K : global stiffness matrix
%--------------------------------------------------------------------
total_dof = size(Coord,1)*3;
n_elements = size(Edof,1);
K = zeros(total_dof);

for i=1:n_elements
    % Elements stiffness matrix
    ex = transpose(Coord(i:i+1,1));
    ey = transpose(Coord(i:i+1,2));
    Ke = beam2e(ex, ey, ep);
    % Add to global stiffness matrix
    K = assem(Edof(i,:), K, Ke);
end