classdef diffuse_tex < material

properties
    emission
    texture
    roughness % 0 to 1, 0 is rough/diffuse perf, 1 is lambert
end

methods
    function obj = diffuse_tex(emi, tex, rough)
        obj = obj@material();
        obj.emission = emi;
        obj.texture = tex;
        obj.roughness = rough;
    end

    function bounce(obj, uv, hit_obj, aray)
        epsilon = 0.00000001; % was 0.001

        [normal, tuv] = hit_obj.normaluv(uv, aray);

        rand1 = 2 * pi * rand;
        rand2 = rand;
        rand2s = sqrt(rand2);

        if dot(normal, aray.direction) < 0
            normal_facing = normal;
        else
            normal_facing = -normal;
        end

        if normal_facing(1) > 0.1
            axis = [0, 1, 0];
        else
            axis = [1, 0, 0];
        end
        u = cross(axis, normal_facing)/norm(cross(axis, normal_facing));
        v = cross(normal_facing, u);

        newdir = u * cos(rand1) * rand2s + v * sin(rand1) * rand2s + normal_facing * sqrt(1-rand2);
        newdir = newdir/norm(newdir);

        aray.origin = aray.origin + aray.direction * aray.dist + normal_facing * epsilon;
        aray.direction = newdir;

        aray.colour = aray.colour + aray.mask .* obj.emission;
        aray.mask = aray.mask .* obj.texture.get(tuv) * dot(newdir, normal_facing)^obj.roughness;
    end
end
end