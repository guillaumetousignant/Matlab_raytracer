classdef sphere_motionblur < sphere

properties
    radiuslast
    originlast
    direction_sphlast
end

methods
    function obj = sphere_motionblur(material, transformation)
        obj = obj@sphere(material, transformation);
        obj.originlast = obj.origin;
        obj.radiuslast = obj.radius;
        obj.direction_sphlast = obj.direction_sph;
    end

    function update(obj)
        obj.originlast = obj.origin;
        obj.radiuslast = obj.radius;
        obj.direction_sphlast = obj.direction_sph;
        obj.update@sphere;
    end

    function [intersected, t, uv] = intersection(obj, aray)
        origin_int = obj.origin * aray.time + obj.originlast * (1 - aray.time);
        radius_int = obj.radius * aray.time + obj.radiuslast * (1 - aray.time);

        to_center = origin_int - aray.origin;
        b = dot(to_center, aray.direction);
        c = dot(to_center, to_center) - radius_int^2;
        discriminant = b^2 - c;

        if discriminant < 0
            intersected = 0;
            t = inf;
            uv = [NaN, NaN];
            return
        else
            t = b - sqrt(discriminant);
        end

        if t < 0
            t = b + sqrt(discriminant);
            if t < 0
                intersected = 0;
                t = inf;
                uv = [NaN, NaN];
                return
            end
        end
        intersected = 1;
        sph = to_sph(aray.direction * t - to_center);
        uv = [sph(3)/(2 * pi) + 0.5, 1 - sph(2)/pi];
    end

    function [normalvec, tuv] = normaluv(obj, uv, aray) %%% CHECK this is sketchy
        sph = [1, (1 - uv(2)) * pi, (uv(1) - 0.5) * 2 * pi];
        normalvec = to_xyz(sph);

        %%% CHECK this is so slow
        %direction_int = to_xyz(obj.direction_sph) * aray.time + to_xyz(obj.direction_sphlast) * (1 - aray.time);
        %disp(direction_int);
        
        offset = [1, obj.direction_sph(2) * aray.time + obj.direction_sphlast(2) * (1 - aray.time), ...
                    slerp(obj.direction_sph(3), obj.direction_sphlast(3), aray.time)];

        %offset = to_sph(direction_int);
        sph = sph - offset; %%% CHECK -
        sph(1) = 1; %%% CHECK

        %%% CHECK change
        if sph(2) < 0
            sph(2) = -sph(2);
            sph(3) = sph(3) + pi;
        elseif sph(2) > pi
            sph(2) = 2*pi - sph(2);
            sph(3) = sph(3) + pi;
        end

        %%% CHECK change
        if sph(3) < -pi
            sph(3) = sph(3) + 2*pi;
        elseif sph(3) > pi
            sph(3) = sph(3) - 2*pi;
        end

        %sph = sph + (sph < [-1; pi; -pi]) .* [1; pi; 2*pi] ...
        %    - (sph > [1; pi; pi]) .* [1; pi; 2*pi]; %%% CHECK if sph(2) is over pi, should rotate sph(3)

        tuv = [sph(3)/(2 * pi) + 0.5, 1 - sph(2)/pi]; 
    end

    function [coord] = mincoord(obj)
        coord = min(obj.originlast - obj.radiuslast, obj.origin - obj.radius);
    end

    function [coord] = maxcoord(obj)
        coord = max(obj.originlast + obj.radiuslast, obj.origin + obj.radius);
    end
end
end