classdef mesh < shape

properties
    geom
    ntris
    triangles
end

methods
    function obj = mesh(geometry, material, transform)
        obj = obj@shape(material, transform);
        obj.geom = geometry;
        obj.ntris = obj.geom.ntris;
        obj.triangles = cell(obj.ntris, 1);

        if isstruct(material)
            for i = 1:obj.ntris
                obj.triangles{i} = triangle_mesh(material.(obj.geom.mat{i, 1}), obj.geom, i, obj.transformation);
            end
        else
            for i = 1:obj.ntris
                obj.triangles{i} = triangle_mesh(material, obj.geom, i, obj.transformation);
            end
        end
    end

    function update(obj)
        for i = 1:obj.ntris
            obj.triangles{i, 1}.update();
        end
    end

    function [hit_obj, t, uv] = intersect(obj, ray)

        inter = zeros(obj.ntris, 1);
        t = zeros(obj.ntris, 1);
        uv = zeros(obj.ntris, 2);
        for i = 1:obj.ntris
            [inter(i), t(i), uv(i, :)] = obj.items{i}.intersection(ray);
        end

        if ~any(inter)
            t = inf;
            hit_obj = [];
            uv = [NaN, NaN];
        else
            [t, i] = min(t);
            hit_obj = obj.items{i}; 
            uv = uv(i, :);
        end        
    end

    function [normalvec, tuv] = normaluv(obj, uv, aray)
        normalvec = [0, 0, 0];
        tuv = [0, 0];
        warning('raytracer:mesh:shellFunction', 'Normals should not be tested with meshes directly!');
    end

    function [normalvec] = normal(obj, uv, aray)
        normalvec = [0, 0, 0];
        warning('raytracer:mesh:shellFunction', 'Normals should not be tested with meshes directly!');
    end

    function [coord] = mincoord(obj)
        coord = [inf, inf, inf];
        for i = 1:obj.ntris
            coord = min(coord, obj.triangles{i}.mincoord);
        end
    end

    function [coord] = maxcoord(obj)
        coord = [-inf, -inf, -inf];
        for i = 1:obj.ntris
            coord = max(coord, obj.triangles{i}.maxcoord);
        end
    end
end
end