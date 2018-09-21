classdef portal_scatterer < scattering_fn

properties
    transformation
    is_in
    scattering_coefficient
end

methods
    function obj = portal_scatterer(trans, scat_dist, is_in)
        obj = obj@scattering_fn();

        obj.transformation = trans;
        obj.is_in = is_in;
        obj.scattering_coefficient = 1/scat_dist;
    end

    function scattered = scatter(obj, aray)
        distance = -log(rand)/obj.scattering_coefficient;

        if distance >= aray.dist
            scattered = 0;
        else
            scattered = 1;
            aray.dist = distance;

            transform_norm = obj.transformation.transformDir;

            aray.origin = obj.transformation.multVec(aray.origin + aray.direction * aray.dist);
            newdir = transform_norm.multDir(aray.direction);
            aray.direction = newdir/norm(newdir);

            aray.material = obj.is_in;
        end
    end
end
end