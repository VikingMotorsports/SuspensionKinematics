function [xp] = local2world(x, offset, i, j, k)
%TRANSFORM Summary of this function goes here
%   Detailed explanation goes here

    % check to make sure inputs are unit vectors, if not, try to normalize
    % them, show warning maybe?
    
    % check i x j == k
    
    % check j x k == i
    
    offset = offset';
    i = i';
    j = j';
    k = k';
    
    R=[i, j, k];
    Tbs=[R,offset;0,0,0,1];
    
    xp = Tbs * [x, 1]';
    xp = xp(1:end-1)';
end

