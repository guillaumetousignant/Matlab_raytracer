classdef portal < material

properties
    transformation
    medium_list
end

methods
    function obj = portal(trans, medium_list)
        obj = obj@material();
        obj.transformation = trans;
        obj.medium_list = medium_list;
    end

    function bounce(obj, uv, hit_obj, aray) 
        epsilon = 0.00000001;

        normal = hit_obj.normal(uv, aray);        
        cosi = dot(aray.direction, normal);

        if cosi < 0 % front
            transform_norm = obj.transformation.transformDir;

            aray.origin = obj.transformation.multVec(aray.origin + aray.direction * aray.dist);
            newdir = transform_norm.multDir(aray.direction);
            aray.direction = newdir/norm(newdir);

            aray.medium_list = obj.medium_list;

            %%% REMOVE
            %aray.mask = aray.mask * 0.5;

        else % back
            aray.origin = aray.origin + aray.direction * aray.dist + normal * epsilon;
        end
    end
end
end