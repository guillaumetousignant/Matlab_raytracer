classdef reflective_refractive < medium

properties
    emission
    colour
    ind
    is_in
end

methods
    function obj = reflective_refractive(emi, col, ind, is_in, scattering)
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
            coming_out = 0;
        else
            etat =  obj.is_in.ind; % check what it gets out to, should be able to figure it out with hitpoint
            etai = obj.ind;
            n = -normal;
            coming_out = 1;
        end

        sint = etai/etat * sqrt(1 - cosi * cosi);

        if sint >= 1
            kr = 1;
        else
            cost = sqrt(1 - sint * sint);
            cosi = abs(cosi);
            Rs = ((etat * cosi) - (etai * cost))/((etat * cosi) + (etai * cost));
            Rp = ((etai * cosi) - (etat * cost))/((etai * cosi) + (etat * cost));
            kr = (Rs * Rs + Rp * Rp)/2;
        end

        if (rand > kr) || coming_out % refracted. Not sure if should always be refracted when going out.
            eta = etai/etat;
            k = 1 - eta *eta * (1 - cosi * cosi);

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
                aray.material = obj.is_in;
            end

        else
            newdir = aray.direction - 2 * n * cosi;
            aray.origin = aray.origin + aray.direction * aray.dist + n * epsilon;            
        end

        aray.direction = newdir;
        aray.colour = aray.colour + aray.mask .* obj.emission;
        aray.mask = aray.mask .* obj.colour;
    end
end
end