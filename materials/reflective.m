classdef reflective < material

properties
    emission
    colour
end

methods
    function obj = reflective(emi, col)
        obj = obj@material();
        obj.emission = emi;
        obj.colour = col;
    end

    function bounce(obj, uv, hit_obj, aray)
        epsilon = 0.00000001;

        normal = hit_obj.normal(uv, aray);

        if dot(normal, aray.direction) < 0
            normal_facing = normal;
        else
            normal_facing = -normal;
        end

        newdir = aray.direction - 2 * normal_facing * dot(aray.direction, normal_facing);
        aray.origin = aray.origin + aray.direction * aray.dist + normal_facing * epsilon;
        aray.direction = newdir;

        aray.colour = aray.colour + aray.mask .* obj.emission;
        aray.mask = aray.mask .* obj.colour;
    end
end
end