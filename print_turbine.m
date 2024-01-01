function print_turbine(N, X, Y, coordinate)

% N: the number of wind turbines
% coordinate: the coordinates of wind turbines

figure(1);
clf;
axis([0, X, 0, Y]);
set(gca, 'xtick', 0 : 100 : X);   %set X axis
set(gca, 'ytick', 0 : 100 : Y);   %set Y axis

for i= 1 : 2 : 2 * N  
    tx = coordinate(i);
    ty = coordinate(i + 1);
    plot(tx, ty, 'ks', 'MarkerFaceColor', 'k', 'MarkerSize', 8);
    hold on;
end
hold off;
end