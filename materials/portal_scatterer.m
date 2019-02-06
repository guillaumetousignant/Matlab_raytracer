classdef portal_scatterer < scattering_fn

properties
    transformation
    medium_list
    scattering_coefficient
end

methods
    function obj = portal_scatterer(trans, scat_dist, medium_list)
        obj = obj@scattering_fn();

        obj.transformation = trans;
        obj.medium_list = medium_list;
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

            aray.medium_list = obj.medium_list;
        end
    end
end
end