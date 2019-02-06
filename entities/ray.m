classdef ray < handle
properties 
    origin
    direction
    mask
    colour
    dist
    medium_list
    time
end
methods
    function obj = ray(origin, direction, colour, mask, medium_list)
        obj = obj@handle();
        obj.origin = origin;
        obj.direction = direction;
        obj.colour = colour;
        obj.mask = mask;
        obj.dist = 0;
        obj.medium_list = medium_list;
        obj.time = [1, 1];
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
    
            scattered = obj.medium_list{1}.scattering.scatter(obj);
            if ~scattered
                hit_obj.material.bounce(uv, hit_obj, obj);
            end
        end              
    end

    function add_to_mediums(obj, amedium)
        for i = 1:length(obj.medium_list)
            if obj.medium_list{i}.priority <= amedium.priority
                obj.medium_list(i+1:end+1) = obj.medium_list(i:end);
                obj.medium_list{i} = amedium;
                return
            end
        end
        obj.medium_list{end+1} = amedium;
    end

    function remove_from_mediums(obj, amedium)
        for i = 1:length(obj.medium_list)
            if obj.medium_list{i} == amedium
                obj.medium_list(i) = [];
                break
            end
        end
    end
end
end