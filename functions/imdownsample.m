function [ image_ds ] = imdownsample( image, factor, varargin ) %#eml
%IMAGE DOWNSAMPLE Downsamples an image by a factor using a specified method
%   imdownsample( image, factor, method )
%   factor : Positive number by which to divide image size
%   method (opt) : Method to use, 'min', 'max' or 'avg' for now.
%

%eml.extrinsic('lower')

if ~isempty(varargin)
    method = varargin{1};
else
    method = 'avg';
end

res_x = size(image, 2);
res_y = size(image, 1);
res_z = size(image, 3);
res_x_ds = round(res_x/factor);
res_y_ds = round(res_y/factor);

switch lower(method)
    case 'max'
        image_ds1 = zeros(res_y, res_x_ds, res_z);
        step = res_x /res_x_ds;
        
        parfor i = 1:res_y
        %for i = 1:res_y
            previous = 0;
            temp = zeros(1, res_x_ds, res_z);
            slice = image(i, :, :);
            for j = 1:res_x_ds
                temp(1, j, :) = max(slice(1, previous + 1:round(j * step), :));
                previous = round(j * step);
            end
            image_ds1(i, :, :) = temp;
        end
        
        image_ds = zeros(res_y_ds, res_y_ds, res_z);
        step = res_y/res_y_ds;
        
        parfor j = 1:res_x_ds
        %for j = 1:res_x_ds
            previous = 0;
            temp = zeros(res_y_ds, 1, res_z);
            slice = image_ds1(:, j, :);
            for i = 1:res_y_ds
                temp(i, 1, :) = max(slice(previous + 1:round(i*step), 1, :));
                previous = round(i * step);
            end
            image_ds(:, j, :) = temp;
        end
        
    case 'avg' 
        image_ds1 = zeros(res_y, res_x_ds, res_z);
        step = res_x /res_x_ds;
        
        parfor i = 1:res_y
        %for i = 1:res_y
            previous = 0;
            temp = zeros(1, res_x_ds, res_z);
            slice = image(i, :, :);
            for j = 1:res_x_ds
                temp(1, j, :) = mean(slice(1, previous + 1:round(j * step), :));
                previous = round(j * step);
            end
            image_ds1(i, :, :) = temp;
        end
        
        image_ds = zeros(res_y_ds, res_y_ds, res_z);
        step = res_y/res_y_ds;
        
        parfor j = 1:res_x_ds
        %for j = 1:res_x_ds
            previous = 0;
            temp = zeros(res_y_ds, 1, res_z);
            slice = image_ds1(:, j, :);
            for i = 1:res_y_ds
                temp(i, 1, :) = mean(slice(previous + 1:round(i*step), 1, :));
                previous = round(i * step);
            end
            image_ds(:, j, :) = temp;
        end
        
    case 'min'
        image_ds1 = zeros(res_y, res_x_ds, res_z);
        step = res_x /res_x_ds;
        
        parfor i = 1:res_y
        %for i = 1:res_y
            previous = 0;
            temp = zeros(1, res_x_ds, res_z);
            slice = image(i, :, :);
            for j = 1:res_x_ds
                temp(1, j, :) = min(slice(1, previous + 1:round(j * step), :));
                previous = round(j * step);
            end
            image_ds1(i, :, :) = temp;
        end
        
        image_ds = zeros(res_y_ds, res_y_ds, res_z);
        step = res_y/res_y_ds;
        
        parfor j = 1:res_x_ds
        %for j = 1:res_x_ds
            previous = 0;
            temp = zeros(res_y_ds, 1, res_z);
            slice = image_ds1(:, j, :);
            for i = 1:res_y_ds
                temp(i, 1, :) = min(slice(previous + 1:round(i*step), 1, :));
                previous = round(i * step);
            end
            image_ds(:, j, :) = temp;
        end
        
    otherwise
        image_ds = image;
        warning('imdownsample:incorrectMethod', 'Incorrect downsampling method');
end
end

