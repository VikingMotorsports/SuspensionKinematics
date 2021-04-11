%apply X rotation, then Y rotation
function [Cent,XRot,YRot,Leng]=WheelAxisLocator(B,E,M,P,R)
    Tbs=PRLocater(B,E,M);
    R=transpose([R,1]);
    P=transpose([P,1]);
    Rb=Tbs*R;
    Pb=Tbs*P; 
    Cent=((Rb+Pb)/2);
    Cent=Cent(1:3)';
    YRot=rad2deg(atan((Rb(1)-Pb(1))/(Rb(3)-Pb(3))));
    XRot=rad2deg(atan((Rb(2)-Pb(2))/(sqrt((Rb(1)-Pb(1))^2+(Rb(3)-Pb(3))^2))));
    Leng=norm(Rb(1:3)-Pb(1:3));
end