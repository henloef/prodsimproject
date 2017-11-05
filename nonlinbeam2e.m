function [Ke, fe]=nonlinbeam2e(Edof_0, Edof_n) %Assume that elDof contains the deformations from element degree of freedom x,y,rot for each node 
%NONLINBEAM Summary of this function goes here
%   Detailed explanation goes here


%Forming the deformational displacement vector

I_1 = [1, 0]; % global x direction vector
I_2 = [0, 1]; % global y direction vector

global_coord_system = [I_1,I_2];

ex = [Edof_0(1) Edof_0(4) Edof_n(1) Edof_n(4)];
ey = [Edof_0(2) Edof_0(5) Edof_n(2) Edof_n(5)];
erot = [Edof_0(3) Edof_0(6) Edof_n(3) Edof_n(6)];

x1_0 = [ex(1) ey(1)];
x2_0 = [ex(2) ey(2)];

[T_0, xc_0] = makeXTilde(x1_0,x2_0);

xtilde1_0 = T_0(x1_0-xc_0);
xtilde2_0 = T_0(x2_0-xc_0);



x1_n = [ex(3) ey(3)];

x2_n = [ex(4) ey(4)];

[T_n xc_n] = makeXTilde(x1_n,x2_n);


xtilde1_n = T_n(x1_n-xc_n);
xtilde2_n = T_n(x2_n-xc_n);

utilde_d1 = (xtilde1_n-xtilde1_0);
utilde_d2 = (xtilde2_n-xtilde2_0);





%% Finding deformational rotations


%Finding the nodal deformation rotation

%Finding noce coordinates in respect to local coordinate system of
%0-configuration

x1_n_local = T_0\x1_n;
x2_n_local = T_0\x2_n;



alpha = atan((x2_n_local(2) - x1_n_local(2))/(x2_n_local(1)-x1_n_local(1))); %[radians]



R_a = [alpha+erot(3) alpha+erot(4)];
  

Rtilde_d = T_n*R_a*T_0';

c = cos(theta);
s = sin(theta);

R = [c  -s  0; s  c  0; 0  0  1];











EDDV; %element deformational displacement vector


end

