clc, clear, close all

%% Properties
E = 2.1e5; %% N/mm^2
thickness = 10; % mm
width = 100; % mm
[A, I] = area_properties(thickness, width);
ep = [E A I];
max_load = -100; % N
tolerance = 1.e-9; 

increments = 310;
max_iterations = 20;
max_residual = 0.01;

%% Placeholders for plots
r_plot = zeros(increments,max_iterations);
u_plot = zeros(increments,1);

%% Create geometry
[Edof, Coord_0,  Dof] = circular_arch(20);
total_dof = size(Coord_0,1)*3;
bc = [1 0; 2 0; 61 0; 62 0];


%% Solve

%% Initial solver values
%Initiate variable names
v_hat = zeros(total_dof,1);
v_0 = [];
lambda = 0;

%Solver tuning variables
f_magnitude = -66; %This is the total force applied, which through lambda will be increased until the total f_magnitude is applied to the structure.
delta_s = 40;

q = load_vector(Edof, f_magnitude); %This is the load vector, where the values corresponds to force magnitude, and placement in vector corresponds to node and direction.



%Initiate v_0
[K, fi] = global_K_internal_force(Edof, Coord_0, v_hat, ep);
w_q0 = solveqOM(K,q,bc);
f = sqrt(1+(w_q0')*(w_q0)); 
delta_lambda = delta_s/f; 
v_0 = delta_lambda*w_q0;


iteration = 1;
i = 1;
umidverticalplot = [];
umidhorizontalplot =[];
umidNode = 20/2+1;
vertical_dof = umidNode*3-1;
horizontal_dof = vertical_dof-1;

lambdaplot = [];
count = 0;
count2 = 0;
for i = 1:increments; %Predictor

    count = count+1;
    
    [K, fi] = global_K_internal_force(Edof, Coord_0, v_hat, ep);
    %K denotes the stiffness in the particular global displacement v_hat.
    
    
    w_q = solveqOM(K,q,bc);      %w_q is here the displacement "velocity" with repsect to lambda. 
                                 %Horizontal vector consisting of velocities of all
                                 %translations and rotations.
    
    f = sqrt(1+(w_q')*(w_q));    %Just a simplification variable for the
                                 %relation between delta_s and delta_lambda
      
    if((w_q'*v_0)>0 && i==1)
        delta_lambda = delta_s/f; 
    elseif((w_q'*v_0)>0)
        delta_lambda = delta_s/f; 
    else
        delta_lambda = -(delta_s/f);
    end
    
    v_0 = delta_lambda*w_q;
    
    %Updating force variable lambda, and global displacement.
    lambda = lambda + delta_lambda;
    v_hat = v_hat + v_0;
    
    
    umidverticalplot(count) = v_hat(vertical_dof);
    umidhorizontalplot(count) = v_hat(horizontal_dof);
    
    lambdaplot(count) = lambda;
    
    while iteration <= max_iterations %corrector
        count = count+1;
        
        [K, fi] = global_K_internal_force(Edof, Coord_0, v_hat, ep);
        fi = remove_bc_from_fi(fi, bc);
        r = lambda*q - fi;

        w_q = solveqOM(K,q,bc);
        w_r = solveqOM(K,r,bc);

        del_lambda = -((w_q'*w_r)/(1+w_q'*w_q));
        
        %Making corrector step
        lambda = lambda + del_lambda;
        v_hat = v_hat + (w_r+del_lambda*w_q);
       
        umidverticalplot(count) = v_hat(vertical_dof);
        umidhorizontalplot(count) = v_hat(horizontal_dof);
        lambdaplot(count) = lambda;
       
        % Check threshold for residual
        r_sum = sqrt(r'*r); %Root sum squared
        r_plot(i, iteration) = r_sum;
        if r_sum < max_residual
            break
        end
        iteration = iteration + 1;
    end
    u_plot(i) = max(abs(v_hat));
    iteration = 1;
    lambda_delta_lambda_del_lambdax1000 = [lambda delta_lambda del_lambda*1000]
end


title_prefix = 'Arc length,';

% Plot deformed
Coord = new_coord(Coord_0,v_hat);
[Ex, Ey] = coordxtr(Edof, Coord, Dof, 2);
plotpar = [2 2 1];
sfac = 1;
Ed = extract(Edof, v_hat);
eldisp2(Ex, Ey, Ed, plotpar, sfac);


title(strcat(title_prefix, ' geometry last increment'))
saveas(gcf,'C:\Git\ProdsimProsjekt\prodsimproject\figuresOM\task4_geometry.png')

% Plot residual
figure
plot([1:1:max_iterations],r_plot(3,:))
title(strcat(title_prefix, ' residual last increment'))
xlabel('iteration')
ylabel('residual [N]')
grid on
saveas(gcf,'C:\Git\ProdsimProsjekt\prodsimproject\figuresOM\task4_residual.png')


figure
plot([1:1:count],-umidverticalplot)
title('Vertical displacement of the apex')
xlabel('count')
ylabel('umidVertTrans')

figure
plot([1:1:count],-umidhorizontalplot)
title('Horizontal displacement of the apex')
xlabel('count')
ylabel('umidVertTrans')


% Plot load displacement
figure 
plot(-umidverticalplot,lambdaplot)
title('Vertical displacement of apex - Lambda');
xlabel('u')
ylabel('Lambda')

figure 
plot(-umidhorizontalplot,lambdaplot)
title('Horizontal displacement of apex - Lambda');
xlabel('u')
ylabel('Lambda')
% saveas(gcf,'../fig/task4_load_disp.png')