classdef plane < shape

properties
    normalvec
    dis
    transformation
end

methods
    function obj = plane(material, transformation)
        obj = obj@shape(material, transformation);
        obj.transformation = transformation;
        transform_norm = obj.transformation.transformDir;
        obj.normalvec = transform_norm.multDir([0, 0, 1]);
        obj.dis = dot(obj.transformation.multVec([0, 0, 0]), obj.normalvec);
    end

    function update(obj)
        transform_norm = obj.transformation.transformDir;
        obj.normalvec = transform_norm.multDir([0, 0, 1]);
        obj.dis = dot(obj.transformation.multVec([0, 0, 0]), obj.normalvec);
    end

    function [intersected, t, uv] = intersection(obj, ray)
        kepsilon = 0.00000001;

        denom = dot(obj.normalvec, ray.direction);
        if denom > kepsilon
            %p0l0 = p0 - l0; % What are thoooooose
            p0l0 = obj.dis - ray.origin;
            t = dot(p0l0, obj.normalvec)/denom;
            if t > 0 % >= 0?
                intersected = 1;
                uv = [0, 0]; %%% CHECK cannot give uv on plane, is infinite. Maybe tiling?
                return;
            end
        end

        intersected = 0;
        t = inf;
        uv = [NaN, NaN];
    end

    function [normalvec, tuv] = normaluv(obj, uv, aray) %%% CHECK cannot give uv on plane, is infinite. Maybe tiling?
        normalvec = obj.normalvec;
        tuv = [0, 0];
    end

    function [normalvec] = normal(obj, uv, aray)
        normalvec = obj.normalvec;
    end
end
end