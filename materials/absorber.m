classdef absorber < scattering_fn

properties
    emission_vol
    colour_vol
end

methods
    function obj = absorber(emi_vol, col_vol, abs_dist_emi, abs_dist_col)
        obj = obj@scattering_fn();

        obj.colour_vol = -log(col_vol)/abs_dist_col;
        %obj.emission_vol = -log(emi_vol)/abs_dist_emi;
        obj.emission_vol = emi_vol.^2 ./ abs_dist_emi; % "eeh who knows"

    end

    function scattered = scatter(obj, aray)
        scattered = 0;
        %aray.colour = aray.colour + aray.mask .* exp(-obj.emission_vol * aray.dist);
        aray.colour = aray.colour + aray.mask .* sqrt(obj.emission_vol * aray.dist); % sqrt may be slow
        aray.mask = aray.mask .* exp(-obj.colour_vol * aray.dist);
    end
end
end