function [bellcrank] = rear_bellcrank_calc(H, J, K)
%REAR_BELLCRANK_CALC Summary of this function goes here
%   Detailed explanation goes here
    KH = (H - K);
    KJ = (J - K);
    
    % part basis definition
    offset = K;
    i = KH / norm(KH);
    k = cross(KH, KJ);
    k = k / norm(k);
    j = - cross(i, k);
    basis = [offset; i; j; k];
    
    %apply x-rotation then y-rotation
%     W=k;
%     Yrot=rad2deg(atan(W(1)/ W(3)));
%     Xrot=rad2deg(atan(W(2)/ norm([W(1),W(3)])));
    
    % extrusion geometry
    Ke = [0, 0];
    He = [norm(KH), 0];
    Je = world2local(J, basis);
    Je = Je(1:2);
    dim = [Ke; He; Je];
    
    bellcrank.basis = basis;
    bellcrank.dim = dim;
%     bellcrank.Xrot = Xrot;
%     bellcrank.Yrot = Yrot;
end

