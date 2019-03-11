classdef normal_material < material

properties

end

methods
    function obj = normal_material()
        obj = obj@material();
    end

    function bounce(obj, uv, hit_obj, aray)
        normal = hit_obj.normal(uv, aray);

        aray.colour = normal* 0.5 + 1;
        aray.mask = [0, 0, 0];
    end
end
end