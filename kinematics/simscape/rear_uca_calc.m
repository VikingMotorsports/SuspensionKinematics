function [rear_uca] = rear_uca_calc(D, E, F, N)
%REAR_UCA_CALC Summary of this function goes here
%   Detailed explanation goes here
    rear_uca = wishbone_geometry_calc(D, E, F);
    
    rear_uca.toelink_transform = world2local(N, rear_uca.basis);
end

