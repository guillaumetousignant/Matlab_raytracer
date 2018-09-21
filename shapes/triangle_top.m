classdef triangle_top < shape
% Need to add constructor and update method in child classes. (and possibly normaluv)

properties
    % Updating
    points
    normals

    % Caching
    v1v2
    v1v3
end

methods
    function obj = triangle_top(material, transformation)
        obj = obj@shape(material, transformation);
    end

    function [intersected, t, uv] = intersection(obj, aray)
        kepsilon = 0.00000001;
        pvec = cross(aray.direction, obj.v1v3);
        det = dot(obj.v1v2, pvec);

        if abs(det) < kepsilon
            t = inf;
            intersected = 0;
            uv = [NaN, NaN];
            return
        end

        invdet = 1/det;
        tvec = aray.origin - obj.points(1, :);
        u = dot(tvec, pvec) * invdet;

        if (u < 0) || (u > 1)
            t = inf;
            intersected = 0;
            uv = [u, NaN];
            return
        end

        qvec = cross(tvec, obj.v1v2);
        v = dot(aray.direction, qvec) * invdet;
        uv = [u, v];
        if (v < 0) || ((u+v) > 1)
            t = inf;
            intersected = 0;
            return
        end

        t = dot(obj.v1v3, qvec) * invdet;

        if t < 0
            t = inf;
            intersected = 0;
            return
        end
        intersected = 1;
    end

    %function [normalvec, tuv] = normaluv(obj, uv, aray)
    %    distance = [1 - sum(uv), uv];
    %    normalvec = distance * obj.normals;
    %    tuv = distance * obj.texcoordinates;
    %end

    function [normalvec] = normal(obj, uv, aray)
        distance = [1 - sum(uv), uv];
        normalvec = distance * obj.normals;
    end

    function [normalvec] = normal_face(obj, aray)
        normalvec = cross(obj.v1v2, obj.v1v3);
        normalvec = normalvec/norm(normalvec);
    end

    function [coord] = mincoord(obj)
        coord = min(obj.points);
    end

    function [coord] = maxcoord(obj)
        coord = max(obj.points);
    end
end
end