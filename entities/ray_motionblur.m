classdef ray_motionblur < ray
properties 
end

methods
    function obj = ray_motionblur(origin, direction, colour, mask, medium_list, time)
        obj = obj@ray(origin, direction, colour, mask, medium_list);
        obj.time = time;
    end
end
end