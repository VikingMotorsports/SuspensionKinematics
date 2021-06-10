function [Cent,XRot,YRot,Leng]=WheelAxisLocator(upright_basis,P,R)
%WHEELAXISLOCATOR Calculates rotations between upright and wheel axis
%   The returned rotations must be applied in the following order:
%   X rotation, then Y rotation

    Rb = world2local(R, upright_basis); %determins local location of point R
    Pb = world2local(P, upright_basis); %determins local location of point P
    Cent=((Rb+Pb)/2); %Returns center point (local) between R and P

    %Determins X rotation (pre Y rotation) by rotating the axis first along the Y axis to make it flush with the y-z plane 
    %(use of pythagroian theorem allows for this to be done without linear algerbra)
    XRot=rad2deg(atan((Rb(2)-Pb(2))/(sqrt((Rb(1)-Pb(1))^2+(Rb(3)-Pb(3))^2))));
    
    %Determins Y rotation (post X rotation) by projecting the axis onto the x-z plane and using basic trig
    YRot=rad2deg(atan((Rb(1)-Pb(1))/(Rb(3)-Pb(3))));
    
    Leng=norm(Rb(1:3)-Pb(1:3)); %Returns length of axis
end