classdef randommix_in < material
properties
    ratio
    material_1
    material_2
end

methods
    function obj = randommix_in(material_1, material_2, ratio)
        obj = obj@material();
        obj.material_1 = material_1;
        obj.material_2 = material_2;
        obj.ratio = ratio;
    end

    function bounce(obj, uv, hit_obj, aray)
        normal = hit_obj.normal(uv, aray);
        cosi = dot(aray.direction, normal);

        if (cosi > 0) || (rand < obj.ratio) % material 1 or going out 
           obj.material_1.bounce(uv, hit_obj, aray);
        else % material 2
            obj.material_2.bounce(uv, hit_obj, aray);
        end
    end
end
end