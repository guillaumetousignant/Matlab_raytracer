
% So images are always the same. Comment to merge rendered images later.
%RandStream.setDefaultStream(RandStream('mt19937ar','seed',19950420));

%load scene.mat ascene
%load camera.mat camera

%% Render

render_mode = 'motion';

figure();

switch lower(render_mode)
    case 'normal'
        % Normal render

        tic
        camera.raytrace(ascene);
        toc
        imshow(camera.image.img);
        imwrite16(camera.image.img, '.\images\output.png');
    
    case 'accumulation'
        % Accumulation render

        accum = imgbuffer(camera.image.sizex, camera.image.sizey);
        i = 0;
        while 1 
            i = i + 1;
            tic
            camera.raytrace(ascene);
            fprintf('\nIteration %i done.\n', i);
            toc

            accum.update(camera.image.img);
            imshow(accum.img);
            drawnow;
            
            imwrite16(accum.img, '.\images\output.png');
        end

    case 'motion'
        % Motion render

        %camera.transformation.rotatez(-pi/30);

        for i = 1:61

            thetastep = pi/30;
            theta = (i - 1) * thetastep;

            %pos = [2 * sin(theta), -2 * cos(theta), 0];
            %camera.transformation.rotatez(thetastep);
            %camera.transformation.translate(pos - camera.origin);
            %camera.update;

            earth.transformation.rotatez(thetastep);
            earth.update;
            
%             cube.transformation.rotatez(thetastep);
%             cube.update;
            

            %cube.transformation.rotatex(pi/30);
            %cube.update;
            %ascene.buildacc;
            
            %glass_fuzz.diffusivity = sin((i - 1) * pi/60)^8;

            %goomat.scattering.emission_vol = -log(turquoise)/dist(i);

            tic
            camera.raytrace(ascene);
            imshow(camera.image.img);
            imwrite16(camera.image.img, ['.\images\move\earth_mb\earth_mb', num2str(i, '%2.2u'), '.png']);
            drawnow

            fprintf('\nImage %i done.\n', i);
            toc
        end
        fprintf('\nAll done.\n');
end