classdef reflective_fuzz_tex < material
properties
    emission
    texture
    order % 1 to inf, 1 is flat, 2 is parabole,  higher looks like normal and inf is straight reflection.
    diffusivity % between 0 and 1, portion of the hemisphere reflected to.
end

methods
    function obj = reflective_fuzz_tex(emi, tex, order, diffu)
        obj = obj@material();
        obj.emission = emi;
        obj.texture = tex;
        obj.order = order;
        obj.diffusivity = diffu;
    end

    function bounce(obj, uv, hit_obj, aray)
        epsilon = 0.00000001;

        [normal, tuv] = hit_obj.normaluv(uv, aray);

        if dot(normal, aray.direction) < 0
            normal_facing = normal;
        else
            normal_facing = -normal;
        end

        %rand2 = abs(2 * betarnd(obj.order, obj.order) - 1) * obj.diffusivity; % requires stat toolbox
        rand2 = rand^obj.order * obj.diffusivity;
        rand1 = 2 * pi * rand;
        rand2s = sqrt(rand2);

        if normal_facing(1) > 0.1
            axis = [0, 1, 0];
        else
            axis = [1, 0, 0];
        end
        u = cross(axis, normal_facing)/norm(cross(axis, normal_facing));
        v = cross(normal_facing, u);

        normal_fuzz = u * cos(rand1)*rand2s + v*sin(rand1)*rand2s + normal_facing*sqrt(1-rand2);
        normal_fuzz = normal_fuzz/norm(normal_fuzz);

        newdir = aray.direction - 2 * normal_fuzz * dot(aray.direction, normal_fuzz);

        aray.origin = aray.origin + aray.direction * aray.dist + normal_facing * epsilon; % maybe shound be normal_fuzz, but could create errors if perpendicular
        aray.direction = newdir;

        aray.colour = aray.colour + aray.mask .* obj.emission;
        aray.mask = aray.mask .* obj.texture.get(tuv);
    end
end
end