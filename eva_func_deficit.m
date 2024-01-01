function[vel_def] = eva_func_deficit(interval_dir_num, N, coordinate, theta, a, kappa, R)

% N : the fixed number of wind turbines
% cooridinate : the coordinates of every wind turbines(1*2N)
% theta : the value of the wind direction
% a : the axial induction factor
% kappa : the spreading constant for land case
% R : the rotor diameter

global thetaVeldefijMatrix;

vel_def(1 : N) = 0;

for i = 1 : N
    vel_def_i = 0;
    for j = 1 : N   
        [affected, dij] = downstream_wind_turbine_is_affected(coordinate, j, i, theta, kappa, R);
        if(affected)  
            def = a / (1 + kappa * dij / R)^2;
            def = restrict(def, 1);
            thetaVeldefijMatrix(i, j, interval_dir_num) = def;
            vel_def_i = vel_def_i + def^2;  
        else
            thetaVeldefijMatrix(i, j, interval_dir_num) = 0;
        end  
    end
    vel_def_i = restrict(vel_def_i, 1);
    vel_def(i) = sqrt(vel_def_i);
end
end