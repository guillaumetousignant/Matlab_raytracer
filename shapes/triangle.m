classdef triangle < triangle_top

properties
    % Init
    points_orig  % each point should be a row vector
    normals_orig % each normal should be a row vector
    texcoordinates % should be a row vector, x, y; x, y; x, y
end

methods
    function obj = triangle(material, points, normals, texcoord, transformation)
        obj = obj@triangle_top(material, transformation);
        obj.points_orig = points;

        % Caching
        obj.v1v2 = points(2, :) - points(1, :);
        obj.v1v3 = points(3, :) - points(1, :);

        if isempty(normals)
            nor = cross(obj.v1v2, obj.v1v3);
            normalvec = nor/norm(nor);
            obj.normals_orig = [normalvec; normalvec; normalvec];
        else
            obj.normals_orig = normals;   
        end 
        if isempty(texcoord)
            obj.texcoordinates = [0, 0; 0, 0; 0, 0];  % what to do here?
        else
            obj.texcoordinates = texcoord; 
        end
        
        %obj.points = obj.transformation.multVec(obj.points_orig); % should work, modify multvec?
        obj.points = [  obj.transformation.multVec(obj.points_orig(1, :)); ...
                        obj.transformation.multVec(obj.points_orig(2, :)); obj.transformation.multVec(obj.points_orig(3, :))];

        transform_norm = obj.transformation.transformDir;

        %obj.normals = transform_norm.multDir(obj.normals_orig); % should work
        obj.normals = [ transform_norm.multDir(obj.normals_orig(1, :)); ...
                        transform_norm.multDir(obj.normals_orig(2, :)); transform_norm.multDir(obj.normals_orig(3, :))];        
    end

    function update(obj)
        %obj.points = obj.transformation.multVec(obj.points_orig); % should work
        obj.points = [  obj.transformation.multVec(obj.points_orig(1, :)); ...
                        obj.transformation.multVec(obj.points_orig(2, :)); obj.transformation.multVec(obj.points_orig(3, :))];

        transform_norm = obj.transformation.transformDir;

        %obj.normals = transform_norm.multDir(obj.normals_orig); % should work
        obj.normals = [ transform_norm.multDir(obj.normals_orig(1, :)); ...
                        transform_norm.multDir(obj.normals_orig(2, :)); transform_norm.multDir(obj.normals_orig(3, :))];

        % Caching
        obj.v1v2 = obj.points(2, :) - obj.points(1, :);
        obj.v1v3 = obj.points(3, :) - obj.points(1, :);
    end

    function [normalvec, tuv] = normaluv(obj, uv, aray)
        distance = [1 - sum(uv), uv];
        normalvec = distance * obj.normals;
        tuv = distance * obj.texcoordinates;
    end
end
end