classdef skybox_texture_sun < skybox_texture

properties
    sun_pos
    sun_col
    sun_rad
end

methods
    function obj = skybox_texture_sun(atexture, sun_pos, sun_col, sun_rad)
        obj = obj@skybox_texture(atexture);
        obj.sun_pos = sun_pos;
        obj.sun_col = sun_col;
        obj.sun_rad = sun_rad;
    end

    function colour = get(obj, direction) %%% CHECK sun should be a circle
        sph = to_sph(direction); %%% CHECK should add skybox transformation here
        xy = [sph(3)/(2 * pi) + 0.5, 1 - sph(2)/pi];

        if  sum((xy - obj.sun_pos).^2) < obj.sun_rad^2
            colour = obj.sun_col;
        else
            colour = obj.back_texture.get(xy);
        end
    end
end
end