function [ fi ] = assem_fi( Edofe, fi, fie )
% [fi]=assem_fi( Edofe, fi, fie )
%--------------------------------------------------------------------
% PURPOSE
%  Assemble the element internal forces into the global internal forces
%
% INPUT:  Edofe = topology matrix for element, dim = 7x1
%         fi = global internal forces vector, dim = n_dofx1
%         fie = element internal forces, dim = 6x1
% OUTPUT: fi = global internal forces, dim = n_dofx1
%--------------------------------------------------------------------
for i = 1:length(fie)
    fi(Edofe(i+1)) = fie(i);
end

end

