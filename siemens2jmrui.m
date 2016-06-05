function [n, jvox_num] = siemens2jmrui(svox_num)
%SIEMENS2JMRUI Convert siemens voxel map to jmrui voxel map
%   Exactly what it says on the tin can.

% Find layer #
n = (svox_num - mod(svox_num,256))/256 + 1;

% Find jmrui voxel #
for i=0:255
   if (svox_num - 256*(n-1) == -32*floor(i/16) + 241 + i)
        jvox_num = i;
        break;
   end
end

end