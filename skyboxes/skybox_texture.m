classdef skybox_texture < handle

properties
    back_texture
end

methods
    function obj = skybox_texture(atexture)
        obj = obj@handle();
        obj.back_texture = atexture;
    end

    function colour = get(obj, direction) %%% CHECK sun should be a circle
        sph = to_sph(direction);
        xy = [sph(3)/(2 * pi) + 0.5, 1 - sph(2)/pi];

        colour = obj.back_texture.get(xy);
    end
end
end