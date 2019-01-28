classdef medium < material

properties
    priority
    scattering
end

methods
    function obj = medium(priority, scattering)
        obj = obj@material();
        obj.priority = priority;
        obj.scattering = scattering;
    end
end
end