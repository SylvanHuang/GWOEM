function[affected, dij] = downstream_wind_turbine_is_affected(coordinate, upstream_wind_turbine, ...,
    downstream_wind_turbine, theta, kappa, R)

    affected = 0;
    Tijx = (coordinate(2 * downstream_wind_turbine - 1) - coordinate(2 * upstream_wind_turbine - 1));
    Tijy = (coordinate(2 * downstream_wind_turbine) - coordinate(2 * upstream_wind_turbine));
    dij = cosd(theta) * Tijx + sind(theta) * Tijy;
    lij = sqrt((Tijx^2 + Tijy^2) - (dij)^2);
    l = dij * kappa + R;
    if((upstream_wind_turbine ~= downstream_wind_turbine) && (l > lij-R) && (dij > 0))
        affected = 1;
    end
end