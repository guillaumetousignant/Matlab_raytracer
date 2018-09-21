classdef scatterer_exp < scattering_fn

properties
    emission_vol
    colour_vol
    scattering_coefficient
    order % 0 to 1: back-scatter. 1: flat. 1 to inf: middle spike, 2 is parabole. inf: straight reflection.
    scat_angle % between 0 and 1, portion of the hemisphere reflected to.
end

methods
    function obj = scatterer_exp(emi_vol, col_vol, abs_dist_emi, abs_dist_col, scat_dist, order, scat_angle)
        obj = obj@scattering_fn();

        %obj.emission_vol = -log(emi_vol)/abs_dist_emi;
        obj.emission_vol = emi_vol.^2 ./ abs_dist_emi; % "eeh who knows"
        obj.colour_vol = -log(col_vol)/abs_dist_col;
        obj.scattering_coefficient = 1/scat_dist;
        obj.order = order;
        obj.scat_angle = scat_angle;
    end

    function scattered = scatter(obj, aray)
        distance = -log(rand)/obj.scattering_coefficient;

        if distance >= aray.dist
            scattered = 0;
        else
            scattered = 1;
            aray.dist = distance;
            aray.origin = aray.origin + aray.direction * distance;

            %rand2 = abs(2 * betarnd(obj.order, obj.order) - 1) * obj.scat_angle * pi; % requires stat toolbox
            rand2 = rand^obj.order * obj.scat_angle * pi;
            rand1 = 2 * pi * rand;

            if  aray.direction(1) > 0.1
                axis = [0, 1, 0];
            else
                axis = [1, 0, 0];
            end
            u = cross(axis, aray.direction);
            u = u/norm(u);
            v = cross(aray.direction, u);

            direction_fuzz = u * cos(rand1) * sin(rand2) + v * sin(rand1) * sin(rand2) + aray.direction * cos(rand2);
            direction_fuzz = direction_fuzz/norm(direction_fuzz); % is this needed? prob because of the cross() calls.

            aray.direction = direction_fuzz;
        end

        %aray.colour = aray.colour + aray.mask .* exp(-obj.emission_vol * aray.dist);
        aray.colour = aray.colour + aray.mask .* sqrt(obj.emission_vol * aray.dist); % sqrt may be slow
        aray.mask = aray.mask .* exp(-obj.colour_vol * aray.dist);
    end
end
end