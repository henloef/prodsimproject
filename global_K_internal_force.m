function [ K, fi ] = global_K_internal_force(Edof, Coord_0, a, ep)
% [K, fi]=global_K_internal_force( Edof, Coord_0, a, ep )
%--------------------------------------------------------------------
% PURPOSE
% Generate global stiffness matrix and internal forces for a structure
%
% INPUT:  Edof = topology matrix
%         Coord_0 = original global coordinate matrix
%         a = total displacement
%         ep = [E A I] modulus of elasticity, area, moment of inertia
% OUTPUT: K = global stiffness matrix
%         fi = global internal forces
%--------------------------------------------------------------------
total_dof = size(Coord_0,1)*3;
n_elements = size(Edof,1);
K = zeros(total_dof);
fi = zeros(total_dof, 1);

dof = 1;
for i=1:n_elements
    % Original and current coordinates
    ex_n = transpose(Coord_0(i:i+1,1)+[a(dof) a(dof+3)]');
    ey_n = transpose(Coord_0(i:i+1,2)+[a(dof+1) a(dof+4)]');
    a_0 = [Coord_0(i,:) 0 Coord_0(i+1,:) 0];
    a_n = [a_0(1:3)+a(dof:dof+2)' a_0(4:6)+a(dof+3:dof+5)'];
    
    % Element stiffness matrix
    Ke = beam2e(ex_n, ey_n, ep);
    fie = nonlinbeam2e(a_0, a_n, ep);
    %fie = zeros(6,1); %only for testing
    % Add to global stiffness and internal force
    K = assem(Edof(i,:), K, Ke);
    fi = assem_fi(Edof(i,:), fi, fie);
    
    dof = dof + 3;
end

