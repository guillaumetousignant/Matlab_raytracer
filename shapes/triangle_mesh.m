classdef triangle_mesh < triangle_top
% Need to add constructor and update method in child classes. (and possibly normaluv)

properties
    % Original
    geom
    index
end

methods
    function obj = triangle_mesh(material, geom, index, transformation)
        obj = obj@triangle_top(material, transformation);
        obj.geom = geom;
        obj.index = index;

        %obj.points = obj.transformation.multVec(obj.points_orig); % should work, modify multvec?
        obj.points = [  obj.transformation.multVec(obj.geom.v(3 * obj.index - 2, :)); ...
                        obj.transformation.multVec(obj.geom.v(3 * obj.index - 1, :)); obj.transformation.multVec(obj.geom.v(3 * obj.index, :))];

        transform_norm = obj.transformation.transformDir;

        %obj.normals = transform_norm.multDir(obj.normals_orig); % should work
        obj.normals = [ transform_norm.multDir(obj.geom.vn(3 * obj.index - 2, :)); ...
                        transform_norm.multDir(obj.geom.vn(3 * obj.index - 1, :)); transform_norm.multDir(obj.geom.vn(3 * obj.index, :))]; 

        % Caching
        obj.v1v2 = obj.points(2, :) - obj.points(1, :);
        obj.v1v3 = obj.points(3, :) - obj.points(1, :);
    end

    function update(obj)
        %obj.points = obj.transformation.multVec(obj.points_orig); % should work, modify multvec?
        obj.points = [  obj.transformation.multVec(obj.geom.v(3 * obj.index - 2, :)); ...
                        obj.transformation.multVec(obj.geom.v(3 * obj.index - 1, :)); obj.transformation.multVec(obj.geom.v(3 * obj.index, :))];

        transform_norm = obj.transformation.transformDir;

        %obj.normals = transform_norm.multDir(obj.normals_orig); % should work
        obj.normals = [ transform_norm.multDir(obj.geom.vn(3 * obj.index - 2, :)); ...
                        transform_norm.multDir(obj.geom.vn(3 * obj.index - 1, :)); transform_norm.multDir(obj.geom.vn(3 * obj.index, :))]; 

        % Caching
        obj.v1v2 = obj.points(2, :) - obj.points(1, :);
        obj.v1v3 = obj.points(3, :) - obj.points(1, :);
    end

    function [normalvec, tuv] = normaluv(obj, uv, aray)
        distance = [1 - sum(uv), uv];
        normalvec = distance * obj.normals;
        tuv = distance * obj.geom.vt(3 * obj.index - 2: 3 * obj.index, :);
    end
end
end