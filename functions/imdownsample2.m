function [ image_ds ] = imdownsample2( image, factor) %#eml
%IMAGE DOWNSAMPLE Downsamples an image by a factor using a specified method
%   imdownsample( image, factor, method )
%   factor : Positive number by which to divide image size
%   method (opt) : Method to use, 'min', 'max' or 'avg' for now.
%
% for eml use

res_x = size(image, 2);
res_y = size(image, 1);
res_z = size(image, 3);
res_x_ds = round(res_x/factor);
res_y_ds = round(res_y/factor);


image_ds = zeros(res_y, res_x, res_z);
step = res_x /res_x_ds;

%parfor i = 1:res_y
for i = 1:res_y
    previous = 0;
    temp = zeros(1, res_x, res_z);
    slice = image(i, :, :);
    for j = 1:res_x_ds
        temp(1, j, :) = mean(slice(1, previous + 1:round(j * step), :));
        previous = round(j * step);
    end
    image_ds(i, :, :) = temp;
end

step = res_y/res_y_ds;

%parfor j = 1:res_x_ds
for j = 1:res_x_ds
    previous = 0;
    temp = zeros(res_y, 1, res_z);
    slice = image_ds(:, j, :);
    for i = 1:res_y_ds
        temp(i, 1, :) = mean(slice(previous + 1:round(i*step), 1, :));
        previous = round(i * step);
    end
    image_ds(:, j, :) = temp;
end

image_ds = image_ds(1:res_x_ds, 1:res_y_ds, res_z);

end

