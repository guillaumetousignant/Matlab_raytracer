function obj = readObj_OLD(fname) 
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
v = []; vt = []; vn = []; f.v = []; f.vt = []; f.vn = []; f.m = {};
current_mat = '';

fid = fopen(fname);
if fid == -1
    error('raytracer:readObj:invalidInput', ['Unable to open file "', fname, '".']);
end

% parse .obj file 
while ~feof(fid)    
    tline = fgetl(fid);
    %ln = sscanf(tline,'%s',1); % line type 
    [ln, rest] = strtok(tline); % line type 
    %disp(ln)
    switch ln
        case 'v'   % mesh vertexs
            v = [v; sscanf(rest,'%f')'];
        case 'vt'  % texture coordinate
            vt = [vt; sscanf(rest,'%f')'];
        case 'vn'  % normal coordinate
            vn = [vn; sscanf(rest,'%f')'];
        case 'usemtl'
            current_mat = strtrim(rest);
            dots = strfind(rest, ':');
            if ~isempty(dots)
                current_mat = rest(dots(end)+1:end);
            end
        case 'f'   % face definition
            fv = []; fvt = []; fvn = [];
            str = textscan(rest,'%s'); str = str{1};
       
            nf = length(findstr(str{1},'/')); % number of fields with this face vertices
            nf2 = length(findstr(str{1},'//')); % double slashes, no tex but normals


            [tok str] = strtok(str,'//');     % vertex only
            for k = 1:length(tok), fv = [fv str2num(tok{k})]; end
           
            if nf > 0 
                if nf2 > 0 %%% CHECK not sure about this
                    [tok str] = strtok(str,'//');   % add normal coordinates
                    for k = 1:length(tok) fvn = [fvn str2num(tok{k})]; end
                else
                    [tok str] = strtok(str,'//');   % add texture coordinates
                    for k = 1:length(tok) fvt = [fvt str2num(tok{k})]; end

                    if (nf > 1) 
                        [tok str] = strtok(str,'//');   % add normal coordinates
                        for k = 1:length(tok) fvn = [fvn str2num(tok{k})]; end
                    end
                end
            end
            if length(tok) == 3
                f.v = [f.v; fv]; f.vt = [f.vt; fvt]; f.vn = [f.vn; fvn]; f.m = [f.m; {current_mat}];
            else % triangulate, %%% CHECK sign convention
                
                for i = 1:length(tok)-2
                    if isempty(fv)
                        f.v = [f.v; fv];
                    else  
                        f.v = [f.v; fv(1), fv(i + 1), fv(i + 2)];
                    end
                    if isempty(fvt)
                        f.vt = [f.vt; fvt];
                    else
                        f.vt = [f.vt; fvt(1), fvt(i + 1), fvt(i + 2)];
                    end
                    if isempty(fvn)
                        f.vn = [f.vn; fvn];
                    else
                        f.vn = [f.vn; fvn(1), fvn(i + 1), fvn(i + 2)];
                    end
                    f.m = [f.m; {current_mat}];
                end
            end
    end
end
fclose(fid);

% set up matlab object 
obj.v = v; obj.vt = vt; obj.vn = vn; obj.f = f;
