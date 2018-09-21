classdef shape < handle

properties
    %origin
    material
    transformation
end

methods
    function obj = shape(material, transformation)
        obj = obj@handle();
        %obj.origin = origin;
        obj.material = material;
        obj.transformation = transformation;
    end
end
end