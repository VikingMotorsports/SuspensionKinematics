function [rear_uca] = rear_uca_calc(D, E, F, N)
%REAR_UCA_CALC calculates basic properties of rear UCA
%   Call this function instead of wishbone_geometry_calc when
%   calculating rear UCA properties

    rear_uca = wishbone_geometry_calc(D, E, F);

%   Rear wishbone requires an additional point that
%   specifies where the toelink gets attached. This point
%   is not guatranteed to lie on any existing lines, so it must
%   be calculated separately
    rear_uca.toelink_transform = world2local(N, rear_uca.basis);
end

