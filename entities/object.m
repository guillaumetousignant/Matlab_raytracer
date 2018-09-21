classdef object < handle

properties
    material
    transformation
    geometry
end

methods
    function obj = object(material, transformation, geometry)
        obj = obj@handle();
        obj.material = material;
        obj.transformation = transformation;
        obj.geometry = geometry;
    end
end
end