function obj = readObj(fname) 
%
% obj = readObj(fname)
%
% This function parses wavefront object data
% It reads the mesh vertices, texture coordinates, normal coordinates
% and face definitions(grouped by number of vertices) in a .obj file 
% 
%
% INPUT: fname - wavefront object file full path
%
% OUTPUT: obj.v - mesh vertices
%       : obj.vt - texture coordinates
%       : obj.vn - normal coordinates
%       : obj.f - face definition assuming faces are made of of 3 vertices
%
% Bernard Abayowa, Tec^Edge
% 11/8/07

% set up field types
%v = []; vt = []; vn = []; f.v = []; f.vt = []; f.vn = []; f.m = {};


fid = fopen(fname);
if fid == -1
    error('raytracer:readObj:invalidInput', ['Unable to open file "', fname, '".']);
end

current_mat = '';

nv = 0;
nvt = 0;
nvn = 0;
nf = 0;
while ~feof(fid) 
    tline = fgetl(fid);
    [ln, rest] = strtok(tline);

    switch ln
        case 'v'
            nv = nv + 1;
        case 'vt'
            nvt = nvt + 1;
        case 'vn'
            nvn = nvn + 1;
        case 'f'
            nf = nf + size(textscan(rest, '%s'), 1);
    end
end

v = zeros(nv, 3);
vt = zeros(nvt, 2);
vn = zeros(nvn, 3);
f = struct('v', zeros(nf, 3), 'vt', zeros(nf, 3), 'vn', zeros(nf, 3), 'm', {cell(nf, 1)});

iv = 0;
ivt = 0;
ivn = 0;
ifa = 0;

frewind(fid);

% parse .obj file 
while ~feof(fid)    
    tline = fgetl(fid);
    %ln = sscanf(tline,'%s',1); % line type 
    [ln, rest] = strtok(tline); % line type 
    %disp(ln)
    switch ln
        case 'v'   % mesh vertexs
            iv = iv + 1;
            v(iv, :) = sscanf(rest,'%f')';
        case 'vt'  % texture coordinate
            ivt = ivt + 1;
            vt(ivt, :) = sscanf(rest,'%f')';
        case 'vn'  % normal coordinate
            ivn = ivn + 1;
            vn(ivn, :) = sscanf(rest,'%f')';
        case 'usemtl'
            current_mat = strtrim(rest);
            dots = strfind(rest, ':');
            if ~isempty(dots)
                current_mat = rest(dots(end)+1:end);
            end
        case 'f'   % face definition
            %fv = []; fvt = []; fvn = [];
            str = textscan(rest,'%s'); str = str{1};
       
            nf = length(findstr(str{1},'/')); % number of fields with this face vertices
            nf2 = length(findstr(str{1},'//')); % double slashes, no tex but normals


            [tok str] = strtok(str,'//');     % vertex only
            fv = zeros(1, size(tok, 1));
            fvt = nan(1, size(tok, 1));
            fvn = nan(1, size(tok, 1));
            for k = 1:size(tok, 1), fv(1, k) = str2double(tok{k}); end % was str2num
           
            if nf > 0 
                if nf2 > 0 %%% CHECK not sure about this
                    tok = strtok(str,'//');   % add normal coordinates
                    for k = 1:size(tok, 1), fvn(1, k) = str2double(tok{k}); end % was str2num
                else
                    [tok str] = strtok(str,'//');   % add texture coordinates
                    for k = 1:size(tok, 1), fvt(1, k) = str2double(tok{k}); end % was str2num

                    if (nf > 1) 
                        tok = strtok(str,'//');   % add normal coordinates
                        for k = 1:size(tok, 1), fvn(1, 3) = str2double(tok{k}); end % was str2num
                    end
                end
            end
            if size(tok, 1) == 3
                ifa = ifa + 1;
                f.v(ifa, :) = fv; f.vt(ifa, :) = fvt; f.vn(ifa, :) = fvn; f.m{ifa, 1} = current_mat;
            else % triangulate, %%% CHECK sign convention
                
                for i = 1:size(tok, 1)-2
                    ifa = ifa + 1;
                    if isempty(fv)
                        f.v(ifa, :) = fv;
                    else  
                        f.v(ifa, :) = [fv(1), fv(i + 1), fv(i + 2)];
                    end
                    if isempty(fvt)
                        f.vt(ifa, :) = fvt;
                    else
                        f.vt(ifa, :) = [fvt(1), fvt(i + 1), fvt(i + 2)];
                    end
                    if isempty(fvn)
                        f.vn(ifa, :) = fvn;
                    else
                        f.vn(ifa, :) = [fvn(1), fvn(i + 1), fvn(i + 2)];
                    end
                    f.m{ifa, 1} = current_mat;
                end
            end
    end
end
fclose(fid);

% set up matlab object 
obj.v = v; obj.vt = vt; obj.vn = vn; obj.f = f;
