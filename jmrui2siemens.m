function [svox_num] = jmrui2siemens(n, jvox_num)
%JMRUI2SIEMENES Convert jmrui voxel map to siemens voxel map
%   Exactly what it says on the tin can.

% Find voxel #
svox_num = 256*(n-1) - 32*floor(jvox_num/16) + 241 + jvox_num;

end