function [bellcrank] = rear_bellcrank_calc(H, J, K)
%REAR_BELLCRANK_CALC calculates basic properties of bellcranks
%   This version works for both rear and front bellcrank
%   But this might need to be changed in the future
    KH = (H - K);
    KJ = (J - K);
    
    % part basis definition
    offset = K;
    i = KH / norm(KH);
    k = cross(KH, KJ);
    k = k / norm(k);
    j = - cross(i, k);
    basis = [offset; i; j; k];
    
    % extrusion geometry
    Ke = [0, 0];
    He = [norm(KH), 0];
    Je = world2local(J, basis);
    Je = Je(1:2); 
    dim = [Ke; He; Je];
    
    bellcrank.basis = basis;
    bellcrank.dim = dim;
end
  
