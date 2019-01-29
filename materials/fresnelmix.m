classdef fresnelmix < material
properties
    ind
    material_reflected
    material_refracted
end

methods
    function obj = fresnelmix(material_refracted, material_reflected, ind)
        obj = obj@material();
        obj.material_reflected = material_reflected;
        obj.material_refracted = material_refracted;
        obj.ind = ind;
    end

    function bounce(obj, uv, hit_obj, aray)
        normal = hit_obj.normal(uv, aray);

        cosi = abs(dot(aray.direction, normal));

        etai = aray.medium_list{1}.ind;
        etat = obj.ind;

        sint = etai/etat * sqrt(1 - cosi * cosi);

        if sint >= 1
            kr = 1;
        else
            cost = sqrt(1 - sint * sint);
            Rs = ((etat * cosi) - (etai * cost))/((etat * cosi) + (etai * cost));
            Rp = ((etai * cosi) - (etat * cost))/((etai * cosi) + (etat * cost));
            kr = (Rs * Rs + Rp * Rp)/2;
        end

        if rand > kr % refracted
            obj.material_refracted.bounce(uv, hit_obj, aray);

        else % reflected
            obj.material_reflected.bounce(uv, hit_obj, aray);
        end
    end
end
end