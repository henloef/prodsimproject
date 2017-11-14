clc, clear, close all

%% Properties
E = 2.1e5; %% N/mm^2
thickness = 10; % mm
width = 100; % mm
[A, I] = area_properties(thickness, width);
ep = [E A I];

%% Create geometry
[Edof, Coord,  Dof] = circular_arch(20);
bc = [1 0; 2 0; 61 0; 62 0];

%% Load
max_load = -26.7e3; % N
f = load_vector(Edof, max_load);

%% Solve
% Create stiffness matrix
K = global_stiffness(Edof, Coord, ep);
[a,r] = solveq(K, f, bc);
max_disp = max(abs(a));

%% Plots
title_prefix = 'Direct stiffness,';

% Plot deformed
[Ex, Ey] = coordxtr(Edof, Coord, Dof, 2);
plotpar = [2 2 1];
sfac = 1;
Ed = extract(Edof, a);
eldisp2(Ex, Ey, Ed, plotpar, sfac);
title(strcat(title_prefix, ' geometry last increment'))
saveas(gcf,'../fig/task2_geometry.png')

% Plot load displacement
figure
plot([0 max_disp],[0 abs(max_load)])
title(strcat(title_prefix, ' load/displacement'))
xlabel('displacement [mm]')
ylabel('load [N]')
grid on
saveas(gcf,'../fig/task2_load_disp.png')