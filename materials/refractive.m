classdef refractive < medium

properties
    emission
    colour
    ind
end

methods
    function obj = refractive(emi, col, ind, priority, scattering)
        obj = obj@medium(priority, scattering);
        obj.emission = emi;
        obj.colour = col;
        obj.ind = ind;
    end

    function bounce(obj, uv, hit_obj, aray) 
        epsilon = 0.00000001;
        %%% CHECK deal with false intersection, make more efficient

        normal = hit_obj.normal(uv, aray);        
        cosi = dot(aray.direction, normal);

        if obj.priority >= aray.medium_list{1}.priority %%% CHECK also discard if priority is equal, but watch for going out case
            if cosi < 0 % coming in
                etai = aray.medium_list{1}.ind;
                etat = obj.ind;
                cosi = -cosi;
                n = normal;
            else % going out
                etat =  aray.medium_list{2}.ind; %%% CHECK maybe create rays with two mediums? to rule out out of bounds here
                etai = obj.ind;
                n = -normal;
            end

            eta = etai/etat;
            k = 1 - eta *eta * (1- cosi * cosi);

            if k < 0
                newdir = [0, 0, 0]; %%% CHECK what to do here
            else
                newdir = eta * aray.direction + (eta * cosi - sqrt(k)) * n;
            end

            aray.colour = aray.colour + aray.mask .* obj.emission;
            aray.mask = aray.mask .* obj.colour;
        else
            newdir = aray.direction;
        end

        if dot(newdir, normal) < 0 % coming in
            aray.origin = aray.origin + aray.direction * aray.dist - normal * epsilon; % use n or normal?
            %if cosi > 0
                aray.add_to_mediums(obj); %%% CHECK not if total internal refraction
            %end
        else % going out
            aray.origin = aray.origin + aray.direction * aray.dist + normal * epsilon; % use n or normal?
            aray.remove_from_mediums(obj);
        end

        aray.direction = newdir;
    end
end
end