classdef nonabsorber < scattering_fn

properties
end

methods
    function obj = nonabsorber()
        obj = obj@scattering_fn();
    end

    function scattered = scatter(obj, aray)
        scattered = 0;
    end
end
end