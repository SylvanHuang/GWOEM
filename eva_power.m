function[power_eva]=eva_power(interval_dir_num, interval_dir, N, coordinate, ...,
           a, kappa, R, k, c, cut_in_speed, rated_speed, cut_out_speed, evaluate_method)

% interval_dir : the wind direction of the wind interval
% N : the fixed number of wind turbines
% cooridinate : the coordinates of every wind turbines(1*2N)
% interval_dir: the value of the wind direction
% a : the axial induction factor
% kappa : the spreading constant for land case
% R : the rotor diameter
% k : parameter in weibull distribution
% c : parameter in weibull distribution
% cut_in_speed : the value of cut-in speed 
% rated_speed : the value of rated speed 
% cut_out_speed : the value of cut-out speed 
% evaluate_method : 'origin/caching' : use origin method or caching technique to evaluate the power output of a layout

%calculate the velocity deficit of every turbines in this wind direction
if(strcmp(evaluate_method, 'caching'))
    [vel_def] = eva_func_deficit_caching(interval_dir_num ,N, coordinate, interval_dir, a, kappa, R);
else
    [vel_def] = eva_func_deficit(interval_dir_num, N, coordinate, interval_dir, a, kappa, R);
end

%calculate the new parameter c corresponding to the velocity deficit
interval_c(1 : N) = 0;
for i = 1 : N
   interval_c(i) = c * (1 - vel_def(i)); 
end

%divide the wind speed from cui-in speed(3.5m/s) to rated speed(14m/s) into 35 intervals
%and calculate the power output in the intervals
n_ws = (rated_speed - cut_in_speed) / 0.3;
power_eva(1 : N) = 0;
for i = 1 : N
    %wind speed between cut-in speed and rated_speed
    for j = 1 : n_ws
        v_j_1 = cut_in_speed + (j - 1) * 0.3;
        v_j = cut_in_speed + j * 0.3;
        power_eva(i) = power_eva(i) + 1500 * exp((v_j_1 + v_j) / 2 - 7.5) ./ (5 + exp((v_j_1 + v_j) / 2 - 7.5)) * ...,
            (exp(-(v_j_1 / interval_c(i))^k) - exp(-(v_j / interval_c(i))^k));
    end
    %wind speed between rated speed and cur-out speed
    power_eva(i) = power_eva(i) + 1500 * (exp(-(rated_speed / interval_c(i))^k) - exp(-(cut_out_speed / interval_c(i))^k));
end
end
