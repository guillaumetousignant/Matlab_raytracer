classdef randommix < material
properties
    ratio
    material_refracted
    material_reflected
end

methods
    function obj = randommix(material_refracted, material_reflected, ratio)
        obj = obj@material();
        obj.material_refracted = material_refracted;
        obj.material_reflected = material_reflected;
        obj.ratio = ratio;
    end

    function bounce(obj, uv, hit_obj, aray)
        if rand < obj.ratio % material 1
           obj.material_refracted.bounce(uv, hit_obj, aray);
        else % material 2
            obj.material_reflected.bounce(uv, hit_obj, aray);
        end
    end
end
end