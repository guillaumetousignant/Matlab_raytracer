classdef normal_material < material

properties

end

methods
    function obj = normal_material()
        obj = obj@material();
    end

    function bounce(obj, uv, hit_obj, aray)
        epsilon = 0.0001; % was 0.001

        normal = hit_obj.normal(uv, aray);

        aray.colour = normal;
        aray.mask = [0, 0, 0];
    end
end
end