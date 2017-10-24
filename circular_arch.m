%buckling of deep cicular arch
R = 1000; %mm radius
H = 400; %mm height
h = 10; %mm thickness
n_elements = 20; %number of beam elements
L = 1600; %mm distance between hinges
theta_L = 0; %rad theta when (x,y) = (L,0)
theta_0 = 0; %rad theta when (x,y) = (0,0)

theta_L = asin((R-H)/R);
theta_0 = pi - theta_L;
delta_theta = (theta_0 - theta_L)/n_elements;

