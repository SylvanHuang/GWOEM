function[all_power]=fitness(interval_num, interval, fre, N, coordinate, ...,
            a, kappa, R, k, c, cut_in_speed, rated_speed, cut_out_speed, evaluate_method)

% interval_num : the number of wind direction bins
% interval :  the value of every wind direction bin
% fre : the frequency of every wind direction bin
% N: the fixed number of wind turbines
% cooridinate : the coordinates of every wind turbines(1*2N)
% a : the axial induction factor
% kappa : the spreading constant for land case
% R : the rotor diameter
% k : parameter in weibull distribution
% c : parameter in weibull distribution
% cut_in_speed : the value of cut-in speed 
% rated_speed : the value of rated speed 
% cut_out_speed : the value of cut-out speed 
% evaluate_method : 'origin/caching' : use origin method or caching technique to evaluate the power output of a layout 

all_power = 0;                 
for i = 1 : interval_num
   interval_dir = (i - 0.5) * interval;
   [power_eva] = eva_power(i, interval_dir, N, coordinate, ...,
            a, kappa, R,k(i), c(i), cut_in_speed, rated_speed, cut_out_speed, evaluate_method);
    all_power = all_power + fre(i) * sum(power_eva);
end
end