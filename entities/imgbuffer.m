classdef imgbuffer < handle

properties
    sizex
    sizey
    img
    updates
end

methods
    function obj = imgbuffer(sizex, sizey)
        obj = obj@handle();

        obj.sizex = sizex;
        obj.sizey = sizey;
        obj.img = zeros(sizey, sizex, 3);
        obj.updates = zeros(sizey, 1);
    end

    function setline(obj, line, index)
        obj.img(index, :, :) = line;
        obj.updates(index) = 1;
    end

    function set(obj, image)
        if isa(image, 'imgbuffer')
            obj.img = image.img;
            obj.updates = image.updates;
        else
            obj.img = image;
            obj.updates(:) = 1;
        end
    end

    function updateline(obj, line, index)
        obj.updates(index) = obj.updates(index) + 1;
        obj.img(index, :, :) = obj.img(index, :, :) * (1 - 1/obj.updates(index)) + line./obj.updates(index);
    end

    function update(obj, image)
        if isa(image, 'imgbuffer')
            ratio = max(image.updates(:)) ./(max(obj.updates(:)) + max(image.updates(:)));
            obj.img = obj.img * (1 - ratio) + image.img .* ratio;
            obj.updates = obj.updates + image.updates;
        else
            obj.updates = obj.updates + 1;
            obj.img = obj.img * (1 - 1/max(obj.updates(:))) + image./max(obj.updates(:));
        end
    end

    function reset(obj)
        obj.updates = zeros(obj.sizey, 1);
    end
end
end