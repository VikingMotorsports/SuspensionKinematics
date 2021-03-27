function [dim] = tube(len, id, t)
%TUBE Summary of this function goes here
%   Detailed explanation goes here
    dim = ...
        [id/2    ,  len/2;
         id/2    , -len/2;
         id/2 + t, -len/2;
         id/2 + t,  len/2];
end

