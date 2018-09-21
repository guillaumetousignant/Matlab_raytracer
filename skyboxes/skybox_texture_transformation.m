classdef skybox_texture_transformation < skybox_texture

properties
    transformation
end

methods
    function obj = skybox_texture_transformation(atexture, transformation)
        obj = obj@skybox_texture(atexture);
        obj.transformation = transformation;
    end

    function colour = get(obj, direction) %%% CHECK sun should be a circle
        transform_norm = obj.transformation.transformDir; %%% CHECK do this on transformation itself?
        direction = transform_norm.multDir(direction);

        sph = to_sph(direction);
        xy = [sph(3)/(2 * pi) + 0.5, 1 - sph(2)/pi];

        colour = obj.back_texture.get(xy);
    end
end
end