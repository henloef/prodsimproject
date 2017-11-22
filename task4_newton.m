clc, clear, close all

%% Properties
E = 2.1e5; %% N/mm^2
thickness = 10; % mm
width = 100; % mm
[A, I] = area_properties(thickness, width);
ep = [E A I];

%% Increments and iterations
increments = 50;
max_iterations = 20;
max_residual = 0.01;

%% Load
max_load = -26.7e3; % N
f_magnitude = 0 : max_load/(increments-1) : max_load;

%% Placeholders for plots
r_plot = zeros(increments,max_iterations);
u_plot = zeros(increments,1);

%% Create geometry
[Edof, Coord_0,  Dof] = circular_arch(20);
total_dof = size(Coord_0,1)*3;
bc = [1 0; 2 0; 61 0; 62 0];

%% Solve
a = zeros(total_dof,1);
iteration = 1;
for i=1:increments
    f = load_vector(Edof, f_magnitude(i));
    while iteration <= max_iterations
        [K, fi] = global_K_internal_force(Edof, Coord_0, a, ep);
        fi = remove_bc_from_fi(fi, bc);
        r = f - fi; 
        [d_a, q_dummy] = solveq(K, r, bc);
        a = a + d_a;
        
        % Check threshold for residual
        r_sum = sqrt(r'*r); %Root sum squared
        r_plot(i, iteration) = r_sum;
        if r_sum < max_residual
            break
        end
        iteration = iteration + 1;
    end
    u_plot(i) = max(abs(a));
    iteration = 1;
end

%% Plots
title_prefix = 'Comparison,';

% Plot deformed
Coord = new_coord(Coord_0,a);
[Ex, Ey] = coordxtr(Edof, Coord, Dof, 2);
plotpar = [2 2 1];
sfac = 1;
Ed = extract(Edof, a);
eldisp2(Ex, Ey, Ed, plotpar, sfac);
title(strcat(title_prefix, ' geometry last increment'))
%saveas(gcf,'../fig/task4_geometry.png')

% Plot residual
figure
plot([1:1:max_iterations],r_plot(3,:))
title(strcat(title_prefix, ' residual last increment'))
xlabel('iteration')
ylabel('residual [N]')
grid on
%saveas(gcf,'../fig/task4_residual.png')

% Plot load displacement
abaqus = csvread('./abaqus_data/nonlingeom26700N.csv');
primary = csvread('../task5_response_primary.csv');
secondary = csvread('../task5_response_secondary.csv');
figure; hold on
plot([0 50.95],[0 abs(max_load)],'b')
plot(u_plot,abs(f_magnitude),'-xr')
plot(abaqus(:,1),abaqus(:,2),'-om')
plot(primary(:,1),primary(:,2),'k')
plot(secondary(:,1),secondary(:,2),'g')

legend('Direct stiffness method', 'Newton iteration', 'Abaqus', 'Arclength primary', 'Arclength secondary')
title(strcat(title_prefix, ' load/displacement'))
xlabel('displacement [mm]')
axis([0  600 0 3.5e4])
ylabel('load [N]')
grid on
saveas(gcf,'../fig/all_comparison_v2.png')