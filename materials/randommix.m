classdef randommix < material
properties
    ratio
    material_1
    material_2
end

methods
    function obj = randommix(material_1, material_2, ratio)
        obj = obj@material();
        obj.material_1 = material_1;
        obj.material_2 = material_2;
        obj.ratio = ratio;
    end

    function bounce(obj, uv, hit_obj, aray)
        if rand < obj.ratio % material 1
           obj.material_1.bounce(uv, hit_obj, aray);
        else % material 2
            obj.material_2.bounce(uv, hit_obj, aray);
        end
    end
end
end