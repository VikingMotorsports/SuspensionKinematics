function [xp] = world2local(varargin)
%WORLD2LOCAL Transform global vector into given basis
%   This function can take either 5 or 2 arguments.
%   The first argument is the global row vector to be transformed.
%   The last three arguments of the 5-argument version can be
%   combined into a "basis" matrix, which contains as rows
%       - offset: global vector that points to the origin of this basis
%       - i,j,k: global unit vectors specifying the basis orientation
%
%   world2local(x, offset, i, j, k) 
%   is equivalent to
%   world2local(x, [offset; i; j; k])
    
    % Parse input arguments
    if nargin == 2 % {vector to convert, basis as a matrix}
        x = varargin{1}; 
        offset = varargin{2}(1, :); i = varargin{2}(2, :); j = varargin{2}(3, :); k = varargin{2}(4, :);
    elseif nargin == 5 % {vector to convert, basis_offset, basis_i, basis_j, basis_k}
        x = varargin{1};
        offset = varargin{2}; i = varargin{3}; j = varargin{4}; k = varargin{5};
    else
        throw(MException("MATLAB:TooManyInputs", "Function expects either 2 or 5 arguments"));
    end
    
    % check to make sure inputs are unit vectors, if not, try to normalize
    % them, show warning maybe?
    
    % check i x j == k
    
    % check j x k == i
    
    offset = offset';
    i = i';
    j = j';
    k = k';
    
    % put together the rotation matrix
    R=[i, j, k];
    % put together the whole transformation (rotation + translation) matrix
    % this matrix uses homogeneous coordinates
    Tbs=[R,offset;0,0,0,1]^-1;
    
    % Apply the transformation.
    % Since homogeneous coordinates are used, a 1 needs to be appended to
    % any vector that gets transformed
    xp = Tbs * [x, 1]';
    % the 1 added can be simply removed to return a regular transformed
    % vector
    xp = xp(1:end-1)';
end