%for given BEM values gives the S to B transformation frame for the upright

%Makes the assumption that B is (0,0,0),
%E is along the X axis (positive x),
%and M is on the (x,y) plane (posotive y)
function Tbs=PRLocater(B,E,M)
    B=transpose(B);
    E=transpose(E);
    M=transpose(M);
    %Defines absolute values and others
    BE = E - B;
    BM = M - B;
    BMp = BE .* (dot(BM, BE)./norm(BE)^2);
    Mp = B + BMp;
    MpM = M - Mp;
    
    %Defines unit vecotrs of B frame in relation to S frame
    x_axis=BE*1/norm(BE);
    y_axis=MpM*1/norm(MpM);
    z_axis=cross(x_axis,y_axis);

    %Assembles Transformation Matrix
    R=[x_axis,y_axis,z_axis];
    Tbs=[R,B;0,0,0,1]^-1;
end