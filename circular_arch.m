%buckling of deep cicular arch
R = 1000; %mm radius
H = 400; %mm height
h = 10; %mm thickness
n_elements = 20; %number of beam elements
L = 1600; %mm distance between hinges
E = 2.1e5; %N/mm^2 elastic modulus
nu = 0; % poisson's ratio

theta_L = asin((R-H)/R); %rad theta when (x,y) = (L,0)
theta_0 = pi - theta_L; %rad theta when (x,y) = (0,0)

delta_theta = (theta_0 - theta_L)/n_elements; %difference in arc positions of each beam element

theta_list = zeros(21,1);

for i = 1:21
    theta_list(i) = theta_0 - delta_theta*(i-1); %list containing angles representing points along the arch
end

beam_coords = zeros(length(theta_list), 2); %list containing all (x,y) coordinates of the beams

for j = 1:length(theta_list)
    beam_coords(j,1) = R*cos(theta_list(j)) + 0.5*L;  %calculates x coordinate based on angle 
    beam_coords(j,2) = R*sin(theta_list(j)) - (R-H);
end
    
