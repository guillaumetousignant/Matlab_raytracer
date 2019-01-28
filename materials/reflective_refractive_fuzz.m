classdef reflective_refractive_fuzz < medium

properties
    emission
    colour
    ind
    order % 1 to inf, 1 is flat, 2 is parabole,  higher looks like normal and inf is straight reflection.
    diffusivity % between 0 and 1, portion of the hemisphere reflected to.
end

methods
    function obj = reflective_refractive_fuzz(emi, col, ind, priority, order, diffu, scattering)
        obj = obj@medium(priority, scattering);
        obj.emission = emi;
        obj.colour = col;
        obj.ind = ind;
        obj.order = order;
        obj.diffusivity = diffu;
    end

    function bounce(obj, uv, hit_obj, aray) 
        epsilon = 0.00000001;

        normal = hit_obj.normal(uv, aray);
        cosi = dot(aray.direction, normal);

        if obj.priority >= aray.medium_list{1}.priority %%% CHECK also discard if priority is equal, but watch for going out case
            %%% CHECK with this, there will be reflections on interface between two objects of the same material. fix.
            if cosi < 0
                etai = aray.medium_list{1}.ind;
                etat = obj.ind;
                %cosi = -cosi;
                n = normal;
                coming_out = 0;
            else
                etat =  aray.medium_list{2}.ind; %%% CHECK maybe create rays with two mediums? to rule out out of bounds here
                etai = obj.ind;
                n = -normal;
                coming_out = 1;
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

            cosi = dot(aray.direction, normal_fuzz); %%% CHECK, recalculate?
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
                    newdir = eta * aray.direction + (eta * cosi - sqrt(k)) * normal_fuzz;
                    newdir = newdir/norm(newdir); % was not normalised before
                end

                if dot(newdir, normal) < 0 % coming in
                    aray.origin = aray.origin + aray.direction * aray.dist - normal * epsilon; % use n or normal?
                    if dot(aray.direction, normal) < 0
                        aray.add_to_mediums(obj);
                    end
                else % going out
                    aray.origin = aray.origin + aray.direction * aray.dist + normal * epsilon; % use n or normal?
                    aray.remove_from_mediums(obj);
                end

            else % reflected
                newdir = aray.direction - 2 * normal_fuzz * cosi; %%% CHECK normalise?
                aray.origin = aray.origin + aray.direction * aray.dist + n * epsilon; % n or normal_fuzz?
            end

            aray.colour = aray.colour + aray.mask .* obj.emission;
            aray.mask = aray.mask .* obj.colour;

        else
            newdir = aray.direction;
            if dot(newdir, normal) < 0 % coming in
                aray.origin = aray.origin + aray.direction * aray.dist - normal * epsilon; % use n or normal?
                if dot(aray.direction, normal) < 0
                    aray.add_to_mediums(obj);
                end
            else % going out
                aray.origin = aray.origin + aray.direction * aray.dist + normal * epsilon; % use n or normal?
                aray.remove_from_mediums(obj);
            end
        end

        aray.direction = newdir;
    end
end
end