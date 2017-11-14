clc, clear, close all

%% Properties
E = 2.1e5; %% N/mm^2
thickness = 10; % mm
width = 100; % mm
H = 400; % height mm
max_load = -5e4; % N

increments = 100;
max_iterations = 50;
max_residual = 0.01;
iteration = 1;

f_magnitude = 0:max_load/increments: max_load;
inc = 1:100;
res_plot = zeros(length(inc),1);

%% Create geometry
[Edof, Coord_0,  Dof] = utkrager(2);
total_dof = size(Coord_0,1)*3;

%% Section and material properties
[A, I] = area_properties(thickness, width);
ep = [E A I];

%% Boundary conditions
bc = [1 0; 2 0; 3 0];

%% Solve
a = zeros(total_dof,1);
for i=1:increments
    f = load_vector_utkrager(Edof, f_magnitude(i));
    while iteration <= max_iterations
        [K, fi] = global_K_internal_force(Edof, Coord_0, a, ep);
        r = f - fi; 
        [d_a, q_dummy] = solveq(K, r, bc);
        a = a + d_a;
        
        % Check threshold for residual
        r_sum = sqrt(r'*r); %Root sum squared
%         res_plot(i) = r_sum + f_magnitude(i);
        if r_sum < max_residual
            break
        end
        iteration = iteration + 1;
    end
    iteration = 1;
end

%% Plot deformed
Coord = new_coord(Coord_0,a);
[Ex, Ey] = coordxtr(Edof, Coord, Dof, 2);
plotpar = [2 2 1];
sfac = 1;
Ed = extract(Edof, a);
eldisp2(Ex, Ey, Ed, plotpar, sfac);

% figure
% plot(inc, res_plot)

% figure
% plot(displacement, abs(load))
% xlabel('displacement [mm]')
% ylabel('load [N]')
% 
% figure
% plot(displacement, residual)
% xlabel('displacement [mm]')
% ylabel('internal force [N]')