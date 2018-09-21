classdef grid < accstruct

properties
    cells %%% CHECK make an array of handles, not a cell array
    n_obj
    cellres
    cellsize
    bbox
    coordinates
end

methods
    function obj = grid(items)
        coord =[inf, inf, inf; -inf, -inf, -inf];
        for i = 1:length(items)
            coord(1, :) = min(items{i}.mincoord, coord(1, :));
            coord(2, :) = max(items{i}.maxcoord, coord(2, :));
        end
        gridsize = coord(2, :) - coord(1, :);

        obj = obj@accstruct();
        obj.bbox = box(coord);
        obj.n_obj = size(items, 1);

        resolution = floor(gridsize .* nthroot(obj.n_obj/(gridsize(1) * gridsize(2) * gridsize(3)), 3));
        resolution(resolution<1) = 1;
        resolution(resolution>128) = 128; % make parametric?

        obj.cellres = resolution;
        obj.cellsize = gridsize ./ resolution;
        obj.coordinates = coord;

        obj.cells = cell(resolution);

        for i = 1:obj.n_obj
            min1 = [inf, inf, inf];
            max1 = [-inf, -inf, -inf];
            item = items{i};

            min1 = min(item.mincoord, min1);
            max1 = max(item.maxcoord, max1); 
            min1 = floor((min1 - coord(1, :)) ./ obj.cellsize);
            max1 = floor((max1 - coord(1, :)) ./ obj.cellsize);

            min1(min1<0) = 0; % was 0 and 0
            max1(max1<0) = 0;
            min1 = min(min1, resolution-1);  % was resolution - 1
            max1 = min(max1, resolution-1);

            for z = min1(3):max1(3)
                for y = min1(2):max1(2)
                    for x = min1(1):max1(1)
                        if isempty(obj.cells{x+1, y+1, z+1})
                            obj.cells{x+1, y+1, z+1} = gridcell();
                        end
                        obj.cells{x+1, y+1, z+1}.add(item);
                    end
                end
            end
        end
    end

    function update(obj)  %%% CHECK should do something when an object moves
        % could be an arrayfun
        for i = 1:obj.cellres(1);
            for j = 1:obj.cellres(2);
                for k = 1:obj.cellres(3);
                    obj.cells{i, j, k}.update;
                end
            end
        end        
    end

    function add(obj, varargin)
        n_obj_add = length(varargin);
        obj.n_obj = obj.n_obj + n_obj_add;
        coord = obj.coordinates;

        for i = 1:obj.n_obj_add
            min1 = [inf, inf, inf];
            max1 = [-inf, -inf, -inf];
            item = varargin{i};

            min1 = min(item.mincoord, min1);
            max1 = max(item.maxcoord, max1); 
            min1 = floor((min1 - coord(1, :)) ./ obj.cellsize);
            max1 = floor((max1 - coord(1, :)) ./ obj.cellsize);

            min1(min1<0) = 0; % was 0 and 0
            max1(max1<0) = 0;
            min1 = min(min1, obj.cellres-1);  % was resolution - 1
            max1 = min(max1, obj.cellres-1);

            for z = min1(3):max1(3)
                for y = min1(2):max1(2)
                    for x = min1(1):max1(1)
                        if isempty(obj.cells{x+1, y+1, z+1})
                            obj.cells{x+1, y+1, z+1} = gridcell();
                        end
                        obj.cells{x+1, y+1, z+1}.add(item);
                    end
                end
            end
        end

    end

    function remove(obj, item)

    end

    function move(obj, item)

    end

    function [hit_obj, t, uv] = intersect(obj, ray)
        invdir = 1./ray.direction;

        hit_obj = [];
        t = inf;
        uv = [NaN, NaN];

        [intersected, tbbox] = obj.bbox.intersection(ray);
        if ~intersected
            return
        end

        cellexit = zeros(3, 1);
        cellstep = zeros(3, 1);
        deltat = zeros(3, 1);
        tnext = zeros(3, 1);

        raycellorigin = (ray.origin + ray.direction .* tbbox) - obj.bbox.coord(1, :);
        cellcoord = floor(raycellorigin ./ obj.cellsize);
        cellcoord(cellcoord<0) = 0;
        cellcoord = min(cellcoord, obj.cellres-1);

        for i = 1:3
            if ray.direction(i) < 0
                deltat(i) = -obj.cellsize(i) * invdir(i);
                tnext(i) = tbbox + (cellcoord(i) * obj.cellsize(i) - raycellorigin(i)) * invdir(i);
                cellexit(i) = -1;
                cellstep(i) = -1;
            else
                deltat(i) = obj.cellsize(i) * invdir(i);
                tnext(i) = tbbox + ((cellcoord(i) + 1) * obj.cellsize(i) - raycellorigin(i)) * invdir(i);
                cellexit(i) = obj.cellres(i);
                cellstep(i) = 1;  
            end
        end

        while 1
            if ~isempty(obj.cells{cellcoord(1)+1, cellcoord(2)+1, cellcoord(3)+1})
                [hit_obj, t, uv] = obj.cells{cellcoord(1)+1, cellcoord(2)+1, cellcoord(3)+1}.intersect(ray);
            end

            k = (tnext(1) < tnext(2)) * 4 + (tnext(1) < tnext(3)) * 2 + (tnext(2) < tnext(3));
            map = [3, 2, 3, 2, 3, 3, 1, 1];
            nextaxis = map(k+1);

            if t < tnext(nextaxis)
                break
            end
            cellcoord(nextaxis) = cellcoord(nextaxis) + cellstep(nextaxis);
            if cellcoord(nextaxis) == cellexit(nextaxis)
                break
            end
            tnext(nextaxis) = tnext(nextaxis) + deltat(nextaxis);
        end        
    end
end
end