function [] = writetable2csv(A, pathname, savename)
%writetable2csv - writes table A to CSV file
%   Exactly what it says on the tin can

% CSV file Data Table
fid=fopen([pathname savename],'w+');

[rows, ~]=size(A);

for i=1:rows
    fprintf(fid,'%s,',A{i,1:end-1});
    fprintf(fid,'%s\n',A{i,end});
end

fclose(fid);

end