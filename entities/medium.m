classdef medium < material

properties
    scattering
end

methods
    function obj = medium(scattering)
        obj = obj@material();
        obj.scattering = scattering;
    end
end
end