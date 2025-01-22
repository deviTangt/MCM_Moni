function [v, u, t1, t2] = water_allocation_one(alpha, gama, inflow, Square, beta, density, gravity, height_lowest)
t = 0;
mark = 0;
height = [142, 158]; %meter(Glen Canyon Dam, Hoover Dam)
Volume = height .* Square;

while(height(1) > height_lowest(1) && height(2) > height_lowest(2))
    t = t + 1;
    if(Volume(1) > 0 && Volume(2) > 0)
        v = [];
        u = [8625*(0.3048^3)*3600*24, 1271*(0.3048^3)*3600*24];
    elseif(Volume(1) <= 0 && Volume(2) > 0)
        v = [];
        u = [8625*(0.3048^3)*3600*24, 1271*(0.3048^3)*3600*24];
        v(1, :) = 0;
    elseif(Volume(1) > 0 && Volume(2) <= 0)
        v = [];
        u = [8625*(0.3048^3)*3600*24, 1271*(0.3048^3)*3600*24];
        v(2, :) = 0;
    else
        break;
    end

    if((height(1) <= height_lowest(1) || height(2) <= height_lowest(2)) && mark == 0)
        t1 = t;
    end

    Volume(1) = Volume(1) + inflow - sum(v(1,:)) - sum(u(1,:));
    Volume(2) = Volume(2) + sum(u(1,:)) - sum(v(2,:)) - sum(u(2,:));

    height = Volume ./ Square;
end

t2 = t;
end