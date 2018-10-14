classdef scene < handle

properties
    geometry
    n_obj
    acc
end

methods
    function obj = scene(varargin)
        obj = obj@handle();
        nobj = length(varargin);
        geom = cell(nobj, 1);
        for i = 1:nobj
            geom{i} = varargin{i};
        end
        obj.geometry = geom;
        obj.n_obj = nobj;
    end

    function add(obj, varargin)
        nadd = length(varargin);
        nobj = obj.n_obj;
        geometry2 = cell(nobj + nadd, 1);
        geometry2(1:nobj) = obj.geometry;

        for i = 1:nadd
            geometry2{i + nobj} = varargin{i};
        end
        obj.geometry = geometry2;
        obj.n_obj = nobj + nadd;
    end

    function addmesh(obj, amesh)
        nobj = obj.n_obj;

        geometry2 = cell(nobj + amesh.ntris, 1);
        geometry2(1:nobj) = obj.geometry;
        geometry2(nobj+1:end, 1) = amesh.triangles;

        obj.geometry = geometry2;
        obj.n_obj = nobj + amesh.ntris;
    end

    function removemesh(obj, amesh) %%% CHECK how to do this
        %obj.n_obj = obj.n_obj - amesh.ntris;
        %obj.geometry(amesh.index:amesh.index + amesh.ntris - 1) = [];
    end

    function update(obj)
        for i = 1:obj.n_obj
            obj.geometry{i}.update();
        end
    end

    function buildacc(obj)
        obj.acc = acc_grid(obj.geometry);
    end

    function [hit_obj, t, uv] = intersect_brute(obj, ray) % Useless for non-trivial scenes
        inter = zeros(obj.n_obj, 1);
        t = zeros(obj.n_obj, 1);
        uv = zeros(obj.n_obj, 2);
        for i = 1:obj.n_obj
            [inter(i), t(i), uv(i, :)] = obj.geometry{i}.intersection(ray);
        end

        if ~any(inter)
            t = inf;
            hit_obj = [];
            uv = [NaN, NaN];
        else
            [t, i] = min(t);
            hit_obj = obj.geometry{i}; 
            uv = uv(i, :);
        end
    end

    function [hit_obj, t, uv] = intersect(obj, ray) % Don't think it should be in here
        [hit_obj, t, uv] = obj.acc.intersect(ray);
    end
end
end