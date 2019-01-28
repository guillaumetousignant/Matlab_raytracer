classdef refractive_fuzz < medium

properties
    emission
    colour
    ind
    order % 1 to inf, 1 is flat, 2 is parabole,  higher looks like normal and inf is straight reflection.
    diffusivity % between 0 and 1, portion of the hemisphere reflected to.
end

methods
    function obj = refractive_fuzz(emi, col, ind, is_in, order, diffu, scattering)
        obj = obj@medium(is_in, scattering);
        obj.emission = emi;
        obj.colour = col;
        obj.ind = ind;
        obj.order = order;
        obj.diffusivity = diffu;
    end

    function bounce(obj, uv, hit_obj, aray) 
        epsilon = 0.0001;

        normal = hit_obj.normal(uv, aray);
        cosi = dot(aray.direction, normal);

        if cosi < 0
            etai = aray.material.ind;
            etat = obj.ind;
            %cosi = -cosi;
            n = normal;
        else
            etat =  obj.is_in.ind; % check what it gets out to, should be able to figure it out with hitpoint
            etai = obj.ind;
            n = -normal;
        end

        %rand2 = abs(2 * betarnd(obj.order, obj.order) - 1) * obj.diffusivity; % requires stat toolbox
        rand2 = rand^obj.order * obj.diffusivity;
        rand1 = 2 * pi * rand;
        rand2s = sqrt(rand2);

        if n(1) > 0.1
            axis = [0, 1, 0];
        else
            axis = [1, 0, 0];
        end
        u = cross(axis, n)/norm(cross(axis, n));
        v = cross(n, u);

        normal_fuzz = u * cos(rand1)*rand2s + v * sin(rand1)*rand2s + n*sqrt(1-rand2);
        normal_fuzz = normal_fuzz/norm(normal_fuzz);

        cosi = dot(aray.direction, normal_fuzz); %%% CHECK recalculate?

        eta = etai/etat;
        k = 1 - eta *eta * (1- cosi * cosi);

        if k < 0
            newdir = [0, 0, 0]; %%% CHECK what to do here
        else
            newdir = eta * aray.direction + (eta * cosi - sqrt(k)) * normal_fuzz;
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