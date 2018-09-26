classdef sphere < shape

properties
    radius
    origin
    direction_sph
end

methods
    function obj = sphere(material, transformation)
        obj = obj@shape(material, transformation);
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        obj.radius = norm(obj.transformation.matrix(1:3, 1:3));
        transform_norm = obj.transformation.transformDir;
        direction = transform_norm.multDir([0, 0, 1]);
        direction2 = transform_norm.multDir([1, 0, 0]);
        dirsph = to_sph(direction);
        dirsph2 = to_sph(direction2);
        obj.direction_sph = [1, dirsph(2), dirsph2(3)];
    end

    function update(obj)
        obj.origin = obj.transformation.multVec([0, 0, 0]);
        obj.radius = norm(obj.transformation.matrix(1:3, 1:3));
        transform_norm = obj.transformation.transformDir;
        direction = transform_norm.multDir([0, 0, 1]);
        direction2 = transform_norm.multDir([1, 0, 0]);
        dirsph = to_sph(direction);
        dirsph2 = to_sph(direction2);
        obj.direction_sph = [1, dirsph(2), dirsph2(3)];
    end

    function [intersected, t, uv] = intersection(obj, aray)

        to_center = obj.origin - aray.origin;
        b = dot(to_center, aray.direction);
        c = dot(to_center, to_center) - obj.radius^2;
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

        sph = to_sph(normalvec) - obj.direction_sph;

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

        tuv = [sph(3)/(2 * pi) + 0.5, 1 - sph(2)/pi];
    end

    function [normalvec] = normal(obj, uv, aray)
        sph = [1, (1 - uv(2)) * pi, (uv(1) - 0.5) * 2 * pi];
        normalvec = to_xyz(sph);
    end

    function [coord] = mincoord(obj)
        coord = obj.origin - obj.radius;
    end

    function [coord] = maxcoord(obj)
        coord = obj.origin + obj.radius;
    end
end
end