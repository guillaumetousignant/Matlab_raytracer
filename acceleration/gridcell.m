classdef gridcell < handle

properties
    items
end

methods
    function obj = gridcell()
        obj = obj@handle();
        obj.items = cell(0, 1);
    end

    function update(obj) %%% CHECK should do something if item moves
        for i = 1:size(obj.items, 1)
            obj.items{i}.update;
        end        
    end

    function add(obj, item)
        obj.items = [obj.items; {item}];
    end

    function remove(obj, item)
    
    end

    function [hit_obj, t, uv] = intersect(obj, ray)
        n_obj = size(obj.items, 1);
        inter = zeros(n_obj, 1);
        t = zeros(n_obj, 1);
        uv = zeros(n_obj, 2);
        for i = 1:n_obj
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

    %function [empt] = isempty(obj)
    %    empt = size(obj.items, 1) > 0;
    %end
end
end