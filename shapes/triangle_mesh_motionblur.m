classdef triangle_mesh_motionblur < triangle_mesh
% Need to add constructor and update method in child classes. (and possibly normaluv)

properties
    % Updating
    pointslast
    normalslast %%% CHECK probably not needed

    % Caching
    v1v2last
    v1v3last
end

methods
    function obj = triangle_mesh_motionblur(material, geom, index, transformation)
        obj = obj@triangle_mesh(material, geom, index, transformation);

        obj.pointslast = obj.points;
        obj.normalslast = obj.normals;
        obj.v1v2last = obj.v1v2;
        obj.v1v3last = obj.v1v3;
    end

    function [intersected, t, uv] = intersection(obj, aray)
        kepsilon = 0.00000001;
        v1v2_int = obj.v1v2 * aray.time + obj.v1v2last * (1 - aray.time);
        v1v3_int = obj.v1v3 * aray.time + obj.v1v3last * (1 - aray.time);
        points_int = obj.points * aray.time + obj.pointslast * (1 - aray.time);


        pvec = cross(aray.direction, v1v3_int);
        det = dot(v1v2_int, pvec);

        if abs(det) < kepsilon
            t = inf;
            intersected = 0;
            uv = [NaN, NaN];
            return
        end

        invdet = 1/det;
        tvec = aray.origin - points_int(1, :);
        u = dot(tvec, pvec) * invdet;

        if (u < 0) || (u > 1)
            t = inf;
            intersected = 0;
            uv = [u, NaN];
            return
        end

        qvec = cross(tvec, v1v2_int);
        v = dot(aray.direction, qvec) * invdet;
        uv = [u, v];
        if (v < 0) || ((u+v) > 1)
            t = inf;
            intersected = 0;
            return
        end

        t = dot(v1v3_int, qvec) * invdet;

        if t < 0
            t = inf;
            intersected = 0;
            return
        end
        intersected = 1;
    end

    function update(obj)
        obj.pointslast = obj.points;
        obj.normalslast = obj.normals;
        obj.v1v2last = obj.v1v2;
        obj.v1v3last = obj.v1v3;

        obj.update@triangle_mesh;
    end

    function [normalvec, tuv] = normaluv(obj, uv, aray)
        normals_int = obj.normals * aray.time + obj.normalslast * (1 - aray.time);
        distance = [1 - sum(uv), uv];
        normalvec = distance * normals_int;
        tuv = distance * obj.geom.vt(3 * obj.index - 2: 3 * obj.index, :);
    end

    function [normalvec] = normal(obj, uv, aray) %%% CHECK how do we get time...
        normals_int = obj.normals * aray.time + obj.normalslast * (1 - aray.time);
        distance = [1 - sum(uv), uv];
        normalvec = distance * normals_int;
    end

    function [normalvec] = normal_face(obj, aray)
        v1v2_int = obj.v1v2 * aray.time + obj.v1v2last * (1 - aray.time); % should interpolate v1v2 and v1v3 or normalvec?
        v1v3_int = obj.v1v3 * aray.time + obj.v1v3last * (1 - aray.time);
        normalvec = cross(v1v2_int, v1v3_int);
        normalvec = normalvec/norm(normalvec);
    end

    function [coord] = mincoord(obj)
        coord = min([obj.pointslast; obj.points]);
    end

    function [coord] = maxcoord(obj)
        coord = max([obj.pointslast; obj.points]);
    end
end
end