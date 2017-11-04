function [Ke, fe]=nonlinbeam2e(ex, ey, ep)
%NONLINBEAM Summary of this function goes here
%   Detailed explanation goes here


%Forming the deformational displacement vector

I_1 = [1, 0]; % global x direction vector
I_2 = [0, 1]; % global y direction vector

global_coord_system = [I_1,I_2];

x1_0 = [ex(1) ey(1)];
x2_0 = [ex(2) ey(2)];

[T_0, xc_0] = makeXTilde(x1_0,x2_0);

xtilde1_0 = T_0(x1_0-xc_0);
xtilde2_0 = T_0(x2_0-xc_0);

% perform step??

x1_n = [1 1];
x2_n = [1 1];

[T_n xc_n] = makeXTilde(x1_n,x2_n);


xtilde1_n = T_n(x1_n-xc_n);
xtilde2_n = T_n(x2_n-xc_n);

utilde_d1 = (xtilde1_n-xtilde1_0);
utilde_d2 = (xtilde2_n-xtilde2_0);




%%Local coordinate unit vectors(BOX 2.2 PHd)

%Make node vectors from global origo. Node 1 is leftmost node, node 2 is
%right most node.

x1_0 = [ex(1) ey(1)];
x2_0 = [ex(2) ey(2)];











EDDV; %element deformational displacement vector


end

