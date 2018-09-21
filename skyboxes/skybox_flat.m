classdef skybox_flat < handle

properties
    background
end

methods
    function obj = skybox_flat( background)
        obj = obj@handle();
        obj.background = background;
    end

    function colour = get(obj, xyz)
        colour = obj.background;
    end
end
end