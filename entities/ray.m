classdef ray < handle
properties 
    origin
    direction
    mask
    colour
    dist
    material % what is the ray in? must be refractive
end
methods
    function obj = ray(origin, direction, colour, mask, material)
        obj = obj@handle();
        obj.origin = origin;
        obj.direction = direction;
        obj.colour = colour;
        obj.mask = mask;
        obj.dist = 0;
        obj.material = material;
    end

    function raycast(obj, scene, camera)
        bounces = 0;
        while (bounces < camera.max_bounces) && (norm(obj.mask) > 0.05)
            [hit_obj, t, uv] = scene.intersect(obj);
            obj.dist = t;
            if isempty(hit_obj)
                obj.colour = obj.colour + obj.mask .* camera.skybox.get(obj.direction);
                return
            end
            bounces = bounces + 1;
    
            scattered = obj.material.scattering.scatter(obj);
            if ~scattered
                hit_obj.material.bounce(uv, hit_obj, obj);
            end
        end              
    end
end
end