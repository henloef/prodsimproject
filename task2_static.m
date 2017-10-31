clc, clear all

%% Properties
E = 2.1e5; %% N/mm^2
thickness = 10; % mm
width = 100; % mm
H = 400; % height mm
max_load = -200; % N
steps = 100;
dimensionless = 0;

%% Create geometry
[Edof, Coord,  Dof] = circular_arch();

%% Create stiffness matrix
[A, I] = area_properties(thickness, width);
ep = [E A I];
K = global_stiffness(Edof, Coord, ep);

%% Boundary conditions and load
bc = [1 0; 2 0; 61 0; 62 0];
load = zeros(1,steps);
displacement = zeros(1,steps);

%% Main loop
for i = 1:steps
    % Load vector
    magnitude = max_load/steps*i;
    f = load_vector(Edof, magnitude);
    % Solve
    [a,r] = solveq(K, f, bc);
    
    if dimensionless == 1
        load(i) = abs(magnitude)/(E*A);
        displacement(i) = abs(min(a))/H;
    else
        load(i) = abs(magnitude);
        displacement(i) = abs(min(a));        
    end
end

%% Plot response curve

plot(displacement, load);
    
if dimensionless == 1
    xlabel('Dimensionless displacement u/H')
    ylabel('Dimensionless load P/EA')
else
    xlabel('Displacement [mm]')
    ylabel('Load [N]')    
end

% Abaqus gir 0.3849
% Matlab gir 0.4993
disp(max(displacement));

%% Plot geometry
%[Ex, Ey] = coordxtr(Edof, Coord, Dof, 2);
%eldraw2(Ex,Ey)