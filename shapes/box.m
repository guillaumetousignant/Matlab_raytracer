classdef box < handle

properties
    coord
end

methods
    function obj = box(coord) % coord is a 2x3 matric, min row vector and max row vector
        obj = obj@handle();
        obj.coord = coord;
    end

    function [intersected, t, uv] = intersection(obj, ray)
        invdir = 1./ray.direction;
        invdirsign = (invdir<0) + 1;

        tmin = (obj.coord(invdirsign(1), 1) - ray.origin(1)) * invdir(1);
        tmax = (obj.coord(3 - invdirsign(1), 1) - ray.origin(1)) * invdir(1);
        tymin = (obj.coord(invdirsign(2), 2) - ray.origin(2)) * invdir(2);
        tymax = (obj.coord(3 - invdirsign(2), 2) - ray.origin(2)) * invdir(2);

        if tmin > tymax || tymin > tmax
            intersected = 0;
            t = inf;
            uv = [NaN, NaN];
            return
        end

        tmin = max(tmin, tymin);
        tmax = min(tmax, tymax);

        tzmin = (obj.coord(invdirsign(3), 3) - ray.origin(3)) * invdir(3);
        tzmax = (obj.coord(3 - invdirsign(3), 3) - ray.origin(3)) * invdir(3);

        if tmin > tzmax || tzmin > tmax
            intersected = 0;
            t = inf;
            uv = [NaN, NaN];
            return
        end

        tmin = max(tmin, tzmin);
        %tmax = min(tmax, tzmax); % why calculate this?

        t = tmin;
        intersected = 1;
        uv = [0, 0]; %%% CHECK what to give uv?
    end
end
end