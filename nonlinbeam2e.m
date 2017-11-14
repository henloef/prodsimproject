function [fi]=nonlinbeam2e(a_0, a_n, Ke) 


%Assume that elDof contains the deformations from element degree of freedom x,y,rot for each node 
%NONLINBEAM Summary of this function goes here
%   Detailed explanation goes here


%Forming the deformational displacement vector
I_1 = [1, 0]; % global x direction vector
I_2 = [0, 1]; % global y direction vector



ex = [a_0(1) a_0(4) a_n(1) a_n(4)];
ey = [a_0(2) a_0(5) a_n(2) a_n(5)];
erot = [a_0(3) a_0(6) a_n(3) a_n(6)];

x1_0 = [ex(1) ey(1)];
x2_0 = [ex(2) ey(2)];

[T_0, xc_0] = makeXTilde(x1_0,x2_0);

xtilde1_0 = T_0*((x1_0-xc_0)');
xtilde2_0 = T_0*((x2_0-xc_0)');



x1_n = [ex(3) ey(3)];

x2_n = [ex(4) ey(4)];

[T_n, xc_n] = makeXTilde(x1_n,x2_n);


xtilde1_n = T_n*((x1_n-xc_n)');
xtilde2_n = T_n*((x2_n-xc_n)');

utilde_d1 = (xtilde1_n-xtilde1_0);
utilde_d2 = (xtilde2_n-xtilde2_0);





%% Finding deformational rotations


%Finding angle between rigid body translation

v_0 = [T_0(1) T_0(2) 0]; %Parallell vector 0 config
v_n = [T_n(1) T_n(2) 0]; %Parallell vector n config
v_horizontal = [1 0 0];

rigidTransAngle = asin(v_0(1)*v_n(2)-v_0(2)*v_n(1));
globalAngle = asin(v_n(1)*v_horizontal(2)-v_n(2)*v_horizontal(1));

deltaTotalAngle_1 = erot(3)-erot(1);
deltaTotalAngle_2 = erot(4)-erot(2);


thetatilde_d1 = deltaTotalAngle_1 - rigidTransAngle;
thetatilde_d2 = deltaTotalAngle_2 - rigidTransAngle;



vtilde_d = [utilde_d1(1); utilde_d1(2); thetatilde_d1; utilde_d2(1); utilde_d2(2); thetatilde_d2];



c = cos(globalAngle);
s = sin(globalAngle);
globalTrans =   [c   -s    0    0    0   0;
                 s    c    0    0    0   0;
                 0    0    1    0    0   0;
                 0    0    0    c   -s   0;
                 0    0    0    s    c   0;
                 0    0    0    0    0   1];



fi = globalTrans'*Ke*vtilde_d;




end

