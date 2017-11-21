function [fi,K]=nonlinbeam2e(a_0, a_n, ep) 
% [fi]=nonlinbeam2e(a_0, a_n, Ke)
%--------------------------------------------------------------------
% PURPOSE
% Generate elemental internal force vector. 
% 

% INPUT:  a_0 - Nodal coordinates for element in zero-configuration.
%         a_n - Nodal coordinates for current configuration.
%         must be formulated a_0 = [x01 y01 r01 x02 y02 r02], for zero
%         -configuration for node 1 and 2.
%       
%         Ke - element stiffness generated from beam2e
%
% OUTPUT: fi - elemental internal force vector.
%
%       fi = [Fx1 Fy1 Mr1 Fx2 Fy2 Mr2], 
% 
%       Fxn - Local horizontal force in node n
%       Fyn - Local vertical force node n
%       Mrn - Moment node n
%       
        
%--------------------------------------------------------------------


ex = [a_0(1) a_0(4) a_n(1) a_n(4)]; %[x10 x20 x1n x2n]
ey = [a_0(2) a_0(5) a_n(2) a_n(5)]; %[y10 y20 y1n y2n]
erot = [a_0(3) a_0(6) a_n(3) a_n(6)]; %[r10 r20 r1n r2n]

x1_0 = [ex(1) ey(1)]; %Coordinate vector to node 1, zero-config
x2_0 = [ex(2) ey(2)]; %Coordinate vector to node 2, zero-config

[T_0, xc_0] = makeXTilde(x1_0,x2_0); %global to local coordinate tranformation for zero-configuration.

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
v_0 = [T_0(1,1) T_0(1,2) 0]; %Parallell vector 0-configuration
v_n = [T_n(1,1) T_n(1,2) 0]; %Parallell vector n-configuration
v_horizontal = [1 0 0]; %Global horizontal vector

%Global angle in reference to local coordinate system. 
globalAngle = asin((-v_horizontal(1))*(-v_n(2))-v_horizontal(2)*v_n(1)); 

%Calculating global elemental rigid rotation angle with reference
%to 0-configuration.
theta_rigid_total_cross = ((-v_0(1))*(-v_n(2))-v_0(2)*v_n(1)); 
theta_rigid_total = asin(theta_rigid_total_cross); 

%Nodal total deformational rotation.
thetatilde_d1 = erot(3)-theta_rigid_total;
thetatilde_d2 = erot(4)-theta_rigid_total;


vtilde_d = [utilde_d1(1); utilde_d1(2); thetatilde_d1;
			utilde_d2(1); utilde_d2(2); thetatilde_d2];



c = cos(globalAngle);
s = sin(globalAngle);
globalTrans =   [c   -s    0    0    0   0;
                 s    c    0    0    0   0;
                 0    0    1    0    0   0;
                 0    0    0    c   -s   0;
                 0    0    0    s    c   0;
                 0    0    0    0    0   1];

%fe=G'*fle;
 b=[ ex(4)-ex(3); ey(4)-ey(3) ];
  L=sqrt(b'*b);  

 E=ep(1);  A=ep(2);  I=ep(3);
 
Kle=[E*A/L   0            0      -E*A/L      0          0 ;
         0   12*E*I/L^3   6*E*I/L^2  0   -12*E*I/L^3  6*E*I/L^2;
         0   6*E*I/L^2    4*E*I/L    0   -6*E*I/L^2   2*E*I/L;
       -E*A/L  0            0       E*A/L      0          0 ;
         0   -12*E*I/L^3 -6*E*I/L^2  0   12*E*I/L^3  -6*E*I/L^2;
         0   6*E*I/L^2    2*E*I/L    0   -6*E*I/L^2   4*E*I/L];

fi_local = Kle*vtilde_d;
fi_spin = [-fi_local(2);
            fi_local(1); 
            0; 
            -fi_local(5); 
            fi_local(4); 
            0;];
G = [ 0 -1/L 0 0 1/L 0];
Kle = Kle + fi_spin*G;

fi = (globalTrans)*fi_local;
K = globalTrans*Kle*globalTrans';




end

