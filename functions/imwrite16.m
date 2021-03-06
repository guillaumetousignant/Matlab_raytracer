function imwrite16(img, path, gammaind)
    if isa(img, 'double') || isa(img, 'float') || isa(img, 'single')
        imwrite(uint16(img.^(1/gammaind) .* 65535), path);
    elseif isa(img, 'uint16')
        imwrite(img, path); % how to gamma correct?
    else
        warning('raytracer:imwrite16:wrongInput', 'Wrong input type, use uint16 or floating point types. Saved with regular bit depth.');
        imwrite(img, path)
    end
end