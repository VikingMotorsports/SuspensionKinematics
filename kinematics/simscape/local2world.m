function [xp] = local2world(varargin)
%TRANSFORM Summary of this function goes here
%   Detailed explanation goes here
    if nargin == 2
        x = varargin{1}; 
        offset = varargin{2}(1, :); i = varargin{2}(2, :); j = varargin{2}(3, :); k = varargin{2}(4, :);
    elseif nargin == 5
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
    
    R=[i, j, k];
    Tbs=[R,offset;0,0,0,1];
    
    xp = Tbs * [x, 1]';
    xp = xp(1:end-1)';
end

