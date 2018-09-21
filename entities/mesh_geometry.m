classdef mesh_geometry < handle

properties
    v
    vt
    vn
    mat
    ntris
end

methods
    function obj = mesh_geometry(file)
        obj = obj@handle();
        geom = readObj(file);
        obj.ntris = size(geom.f.v, 1);

        obj.v = zeros(3 * obj.ntris, 3);
        obj.vt = zeros(3 * obj.ntris, 2);
        obj.vn = zeros(3 * obj.ntris, 3);
        obj.mat = cell(obj.ntris, 1);

        for index = 1:obj.ntris
            obj.v(3*index - 2 : 3*index, :) = [geom.v(geom.f.v(index, 1), :); geom.v(geom.f.v(index, 2), :); geom.v(geom.f.v(index, 3), :)];

            texture = geom.f.vt(index, :);
            if any(isnan(texture))
                obj.vt(3*index - 2 : 3*index, :) = 0;
            else
                obj.vt(3*index - 2 : 3*index, :) =  geom.vt(texture', :);
            end
            normals = geom.f.vn(index, :);
            if any(isnan(normals))
                normalvec = cross(obj.v(3 * index - 1, :) - obj.v(3 * index - 2, :), obj.v(3 * index, :) - obj.v(3 * index - 2, :));
                normalvec = normalvec/norm(normalvec);
                obj.vn(3*index - 2 : 3*index, :) = [normalvec; normalvec; normalvec];
            else
                obj.vn(3*index - 2 : 3*index, :) = geom.vn(normals', :);
            end

            obj.mat{index, 1} = geom.f.m{index, 1};
        end
    end
end
end