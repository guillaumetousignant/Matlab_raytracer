classdef transparent < medium

properties
    ind
end

methods
    function obj = transparent(priority, scattering)
        obj = obj@medium(priority, scattering);
        obj.ind = 1.0;
    end

    function bounce(obj, uv, hit_obj, aray) 
        epsilon = 0.00000001;
        %%% CHECK deal with false intersection, make more efficient

        normal = hit_obj.normal(uv, aray);        
        cosi = dot(aray.direction, normal);


        if cosi < 0 % coming in
            aray.origin = aray.origin + aray.direction * aray.dist - normal * epsilon; % use n or normal?
            aray.add_to_mediums(obj);
        else % going out
            aray.origin = aray.origin + aray.direction * aray.dist + normal * epsilon; % use n or normal?
            aray.remove_from_mediums(obj);
        end
    end
end
end