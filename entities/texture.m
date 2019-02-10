classdef texture < handle

properties
    sizex
    sizey
    img
end

methods
    function obj = texture(file)
        obj = obj@handle();

        [~,~,ext] = fileparts(file);
        switch lower(ext)
            case {'.tga'; '.vda'; '.icb'; '.vst'; '.targa'}
                [imge, map] = tga_read_image(file);
            otherwise
                [imge, map] = imread(file);
        end
        
        if ~isempty(map)
            imge = ind2rgb(imge(:, :, 1:3), map);
        end
        obj.img = im2double(imge(:, :, 1:3));

        obj.sizex = size(imge, 2);
        obj.sizey = size(imge, 1);
    end

    function colour = get(obj, xy)       
        x = 1 + (obj.sizex - 1) * xy(1);
        y = 1 + (obj.sizey - 1) * xy(2);

        xf = x - floor(x);
        yf = y - floor(y);
        colour = obj.img(obj.sizey + 1 - floor(y), floor(x), :) * (1 - xf) * (1 - yf) + obj.img(obj.sizey + 1 - floor(y), ceil(x), :) * xf * (1 - yf) + obj.img(obj.sizey + 1 - ceil(y), floor(x), :) * (1 - xf) * yf + obj.img(obj.sizey + 1 - ceil(y), ceil(x), :) * xf * yf;
        % in matlab images are reversed on y axis

        colour = colour(:)'; % why do I have to do this...
    end

    function colour = get_nn(obj, xy)
        x = round(1 + (obj.sizex - 1) * xy(1));
        y = round(1 + (obj.sizey - 1) * xy(2));
        
        colour = obj.img(obj.sizey + 1 - y, x, :);
        colour = colour(:)'; 
    end
end
end