function new_filename = next_filename(prefix)
    point = strfind(prefix, '.');
    if isempty(point)
        name = prefix;
        extension = '.png';
    else
        name = prefix(1:point(end)-1);
        extension = prefix(point(end):end);
    end

    index = 1;
    new_filename = sprintf('%s%03i%s', name, index, extension);

    while exist(new_filename, 'file') == 2
        index = index + 1;
        new_filename = sprintf('%s%03i%s', name, index, extension);
    end
end