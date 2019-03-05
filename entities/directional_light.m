classdef directional_light < handle

properties
    direction
    transformation
    intensity
    radius % dot(raydir, direction) < -radius to test for intersection
end

methods
    function obj = directional_light(intensity, transformation)
        obj = obj@handle();
        obj.transformation = transformation;
        transform_norm = obj.transformation.transformDir;
        obj.direction = transform_norm.multDir([0, 1, 0]); % checkshould use transformation only? (not transformation_norm)
        obj.intensity = intensity;
        obj.radius = norm(obj.transformation.matrix(1:3, 1:3)); %%% CHECK not right
    end

    function update(obj)
        transform_norm = obj.transformation.transformDir;
        obj.direction = transform_norm.multDir([0, 1, 0]);
        obj.radius = norm(obj.transformation.matrix(1:3, 1:3));
    end
end
end