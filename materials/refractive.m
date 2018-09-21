classdef refractive < medium

properties
    emission
    colour
    ind
    is_in
end

methods
    function obj = refractive(emi, col, ind, is_in, scattering)
        obj = obj@medium(scattering);
        obj.emission = emi;
        obj.colour = col;
        obj.ind = ind;
        if isempty(is_in)
            obj.is_in = obj;
        else
            obj.is_in = is_in; % bad solution, doesn't work for object partly in other refractive mediums (ex: sphere of glass partly in water)
        end
    end

    function bounce(obj, uv, hit_obj, aray) 
        epsilon = 0.0001;

        normal = hit_obj.normal(uv, aray);        
        cosi = dot(aray.direction, normal);

        if cosi < 0
            etai = aray.material.ind;
            etat = obj.ind;
            cosi = -cosi;
            n = normal;
        else
            etat =  obj.is_in.ind; % check what it gets out to, should be able to figure it out with hitpoint
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

        if dot(newdir, normal) < 0
            aray.origin = aray.origin + aray.direction * aray.dist - normal * epsilon; % use n or normal?
            aray.material = obj;
        else
            aray.origin = aray.origin + aray.direction * aray.dist + normal * epsilon; % use n or normal?
            aray.material = obj.is_in; % check how to do this? how to know what it gets out to? material has an 'is inside' material?
        end

        aray.direction = newdir;
        aray.colour = aray.colour + aray.mask .* obj.emission;
        aray.mask = aray.mask .* obj.colour;
    end
end
end