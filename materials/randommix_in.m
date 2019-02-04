classdef randommix_in < material
properties
    ratio
    material_refracted
    material_reflected
end

methods
    function obj = randommix_in(material_refracted, material_reflected, ratio)
        obj = obj@material();
        obj.material_refracted = material_refracted;
        obj.material_reflected = material_reflected;
        obj.ratio = ratio;
    end

    function bounce(obj, uv, hit_obj, aray)
        normal = hit_obj.normal(uv, aray);
        cosi = dot(aray.direction, normal);

        if (cosi > 0) || (rand < obj.ratio) % material 1 or going out 
           obj.material_refracted.bounce(uv, hit_obj, aray);
        else % material 2
            obj.material_reflected.bounce(uv, hit_obj, aray);
        end
    end
end
end