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
    new_filename_L = sprintf('%s%03i_L%s', name, index, extension);
    new_filename_R = sprintf('%s%03i_R%s', name, index, extension);
    new_filename_S = sprintf('%s%03i_S%s', name, index, extension);

    while (exist(new_filename, 'file') == 2) || (exist(new_filename_L, 'file') == 2) || (exist(new_filename_R, 'file') == 2) || (exist(new_filename_S, 'file') == 2)
        index = index + 1;
        new_filename = sprintf('%s%03i%s', name, index, extension);
    end
end