%****************************************************************************************************
% Author: Xingwang Huang

% Declaration: The original wind farm layout optimization framwork is coded by the authors of : 
% Differential Evolution with A New Encoding Mechanism for Optimizing Wind Farm Layout, 
% IEEE Transactions on Industrial InformaticsHao Liu and Yong Wang

% Last Edited: 1/1/2024
% Email: huangxw@jmu.edu.cn

% Reference: Xingwang Huang, Zhijin Wang, Chaopeng Li, Min Zhang.
% A low-complexity evolutionary algorithm for wind farm layout optimization, Energy Reports, 
% DOI: https://doi.org/10.1016/j.egyr.2023.04.356
%****************************************************************************************************

clc;
clear;
tic;

%% The defined parameters
interval = 15;                        %the angle interval
interval_num = fix(360 / interval);   %the number of bins
cut_in_speed = 3.5;                   %the value of cut-in speed 
rated_speed = 14;                     %the value of rated speed 
cut_out_speed = 25;                   %the value of cut-out speed 
R = 40;                               %the rotor radium
H = 80;                               %the hub height 
CT = 0.8;                             %the thrust coefficient
a = 1 - sqrt(1 - CT);                 %the axial induction factor * 2
kappa = 0.01;                         %the spreading constant for land case(z=80,zo=0.54)
minDistance = 5 * R;                  %minimum distance between any two wind turbines
N = 15;                               %the number of wind turbines
X = 2000;                             %the length of wind farm
Y = 2000;                             %the width of wind farm
%Different number of wind turbines and the corresponding side lengthes in my paper
%[15,20,25,30,35,40,60,80,100]
%[2000,2000,2000,2200,2400,2600,3100,3600,4000]

%Values of parameters k and c in weibull distribution and the frequency associated with each wind direction interval
k(1 : interval_num) = 2;%$k_i(\theta)$
c = [7 5 5 5 5 4 5 6 7 7 8 9.5 10 8.5 8.5 6.5 4.6 2.6 8 5 6.4 5.2 4.5 3.9];%$c_i(\theta)$
fre = [0.0003	0.0072	0.0237	0.0242	0.0222	0.0301	0.0397	0.0268	0.0626 ...	
       0.0801	0.1025	0.1445	0.1909	0.1162	0.0793	0.0082	0.0041	0.0008 ...	
       0.0010	0.0005	0.0013	0.0031	0.0085	0.0222];%$\eta_n$

%If you want to test DEEM in wind scenario 2, please uncomment the following code
%k(1 : interval_num) = 2;
%c(1 : interval_num) = 13;
%fre = [0 0.01 0.01 0.01 0.01 0.2 0.6 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0];

%Parameters of caching technique 
global thetaVeldefijMatrix;
thetaVeldefijMatrix = zeros(N, N, interval_num);
global thetaVeldefijBackup;
thetaVeldefijBackup = thetaVeldefijMatrix;
global turbineMoved;
turbineMoved(1 : N) = 0;

%Set the solution space of every turbines
constraint(1) = R;        %the lower constraint in X direction
constraint(2) = X - R;    %the upper constraint in X direction 
constraint(3) = R;        %the lower constraint in Y direction
constraint(4) = Y - R;    %the upper constraint in Y direction

%Parameters of DE
lu=[constraint(1), constraint(3);
    constraint(2), constraint(4)];
F = 0.9;
CR = 0.9;

%Parameters of GWO
% initialize alpha, beta, and delta_pos
Alpha_pos=zeros(1,2 * N);
Alpha_score=inf; %change this to -inf for maximization problems

Beta_pos=zeros(1,2 * N);
Beta_score=inf; %change this to -inf for maximization problems

Delta_pos=zeros(1,2 * N);
Delta_score=inf; %change this to -inf for maximization problems


%Wind Farm Layout model
candidatePos = [];        %record candidate positions of wind turbines
parent(1 : 2 * N) = 0;        
offspring(1 : 2 * N) = 0;
maxEvaluations = 150000;
evaluations = 0;

%set the random seed
[temp] = random_seed(); 
rand('seed', temp); 

%% Initialize the population
j = 1;   %the jth wind turbine
conflict = 0;
while(j <= N)
    parent(2 * j-1) = constraint(1) + (X - R) * rand();  % X coordinate
    parent(2 * j) = constraint(3) + (Y - R) * rand();    % Y coordinate
    flag1 = 0;   %mark the conflict in the constraint one
    flag2 = 0;   %mark the conflict in the constraint two
    %constraint one: not too close to other turbines
    for g=1:j
        dis_gj = sqrt((parent(2 * g-1) - parent(2 * j - 1))^2 + (parent(2 * g) - parent(2 * j))^2);
        if((g ~= j) && (dis_gj < minDistance))
            flag1 = 1;            
            conflict = conflict + 1;
            break;
        end
    end
    %constraint two: not too close to the boundry of wind farm
    if ((parent(2 * j-1) > constraint(2)) || (parent(2 * j) > constraint(4)))
        flag2 = 1;
    end
    if((flag1 ~= 1) && (flag2 ~= 1))
        j=j+1;
    end
    %if conflict comes up too many time, new coordinates are produced
    if(conflict >= 200)  
        j = 1;
        conflict = 0;
    end
end

powerOutputParent = fitness(interval_num, interval, fre, N,parent, ...,
                   a, kappa, R, k, c, cut_in_speed, rated_speed, cut_out_speed, 'origin');

%% Evolution of the population
while(evaluations < maxEvaluations)
   
     %% Update Alpha, Beta, and Delta in GWO
        if powerOutputParent<Alpha_score 
            Alpha_score=powerOutputParent; % Update alpha
            Alpha_pos=parent;
        end
        
        if powerOutputParent>Alpha_score && powerOutputParent<Beta_score 
            Beta_score=powerOutputParent; % Update beta
            Beta_pos=parent;
        end
        
        if powerOutputParent>Alpha_score && powerOutputParent>Beta_score && powerOutputParent<Delta_score 
            Delta_score=powerOutputParent; % Update delta
            Delta_pos=parent;
        end
        a=2-evaluations*((2)/maxEvaluations); % a decreases linearly fron 2 to 0 % Equation (11)
        %%end of Update progress
    
    offspring = parent;
    
    %Generate candidate positions of wind turbines
    if(isempty(candidatePos))
%           candidatePos = DE(offspring, N, lu, 2, F, CR);%DE
        
        % GWO
         candidatePos = GWO(offspring, N, lu, 2, a, Alpha_pos, Beta_pos, Delta_pos);
    end
    newPos =  candidatePos(1 : 2);
    candidatePos(1 : 2) = [];
    
    offspring = generate_new_layout(newPos, offspring, N, X, Y, minDistance);
   
    thetaVeldefijBackup = thetaVeldefijMatrix;
    powerOutputOffspring = fitness(interval_num, interval, fre, N, offspring, ...,
                          a, kappa, R, k, c, cut_in_speed ,rated_speed, cut_out_speed, 'caching');
           
    %Update the population                 
    if(powerOutputParent < powerOutputOffspring)
        parent = offspring;
        powerOutputParent = powerOutputOffspring;
    else
        thetaVeldefijMatrix = thetaVeldefijBackup;
    end
    
    turbineMoved(1 : N) = 0;
       
    evaluations = evaluations + 1; 
    
    if(~rem(evaluations, 100))
        fprintf('The evaluations is %d\n', evaluations);
        fprintf('The best power output is %d\n', powerOutputParent);
    end
end
print_turbine(N, X, Y, parent);
fprintf('The coordinates of wind turbines are');
parent
toc;
