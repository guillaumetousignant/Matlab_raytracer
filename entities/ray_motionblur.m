classdef ray_motionblur < ray
properties 
    time
end

methods
    function obj = ray_motionblur(origin, direction, colour, mask, material, time)
        obj = obj@ray(origin, direction, colour, mask, material);
        obj.time = time;
    end
end
end