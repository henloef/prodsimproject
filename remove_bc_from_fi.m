function [ fi ] = remove_bc_from_fi( fi, bc )
% [fi]=remove_bc_from_fi( fi, bc )
%--------------------------------------------------------------------
% PURPOSE
%  Removes the internal forces from internal forces where dof is fixed
%
% INPUT:  fi = global internal forces vector
%         bc = boundary condition matrix
% OUTPUT: fi : global internal forces vector
%--------------------------------------------------------------------
n_fixed_dofs = size(bc,1);

for dof = 1:n_fixed_dofs
    fi(bc(dof, 1)) = bc(dof, 2);
end

end

