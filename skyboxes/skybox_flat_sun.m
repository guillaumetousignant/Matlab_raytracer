classdef skybox_flat_sun < skybox_flat

properties
    lights
end

methods
    function obj = skybox_flat_sun(background, varargin)
        obj = obj@skybox_flat(background);
        obj.lights = varargin;
    end

    function colour = get(obj, xyz) %%% CHECK maybe do intersection in sph?
        colour = [0, 0, 0];
        for i = 1:length(obj.lights)
            if dot(xyz, obj.lights{i}.direction) < -obj.lights{i}.radius
                colour = colour + obj.lights{i}.intensity;
            end
        end
        if all(colour == [0, 0, 0])
            colour = obj.background;
        end
    end
end
end