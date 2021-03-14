%% Interpret point names in the context of LCA
function [Brot] = rotate_A_arm(A, B, C, alpha)
    AC = C - A;
    Brot = (AxelRot(rad2deg(alpha), AC, A) * [B, 1]')';
    Brot = Brot(1:3);
end