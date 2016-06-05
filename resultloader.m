function [data] = resultloader(pathname, filename)
%resultloader - loads frequency and amplitude data 
%   pathname - path to file
%   filename - name of file
%   data - structure with output

% Initialize variables.
startRow = [12,269,526,783,1040];
endRow = [267,524,781,1038,1295];

% Open the text file.
fileID = fopen([pathname filename],'r');

% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code.
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'ReturnOnError', false);
dataArray = textscan(fileID, '%f%f%f%f%f%f%f%f%[^\n\r]',...
    endRow(1)-startRow(1)+1, 'Delimiter', '\t',...
    'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    textscan(fileID, '%[^\n\r]',...
        startRow(block)-1, 'ReturnOnError', false);
    dataArrayBlock = textscan(fileID,...
        '%f%f%f%f%f%f%f%f%[^\n\r]', endRow(block)-startRow(block)+1,...
        'Delimiter', '\t', 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

% Close the text file.
fclose(fileID);

% Allocate imported array to column variable names
data.PCR.freq = dataArray{:, 1}(1:256);
data.GAMMAATP.freq = dataArray{:, 2}(1:256);
data.ALPHAATP.freq = dataArray{:, 3}(1:256);
data.PE.freq = dataArray{:, 4}(1:256);
data.PC.freq = dataArray{:, 5}(1:256);
data.GPE.freq = dataArray{:, 6}(1:256);
data.GPC.freq = dataArray{:, 7}(1:256);
data.PI1.freq = dataArray{:, 8}(1:256);

data.PCR.freqsd = dataArray{:, 1}(257:512);
data.GAMMAATP.freqsd = dataArray{:, 2}(257:512);
data.ALPHAATP.freqsd = dataArray{:, 3}(257:512);
data.PE.freqsd = dataArray{:, 4}(257:512);
data.PC.freqsd = dataArray{:, 5}(257:512);
data.GPE.freqsd = dataArray{:, 6}(257:512);
data.GPC.freqsd = dataArray{:, 7}(257:512);
data.PI1.freqsd = dataArray{:, 8}(257:512);

data.PCR.amp = dataArray{:, 1}(513:768);
data.GAMMAATP.amp = dataArray{:, 2}(513:768);
data.ALPHAATP.amp = dataArray{:, 3}(513:768);
data.PE.amp = dataArray{:, 4}(513:768);
data.PC.amp = dataArray{:, 5}(513:768);
data.GPE.amp = dataArray{:, 6}(513:768);
data.GPC.amp = dataArray{:, 7}(513:768);
data.PI1.amp = dataArray{:, 8}(513:768);

data.PCR.ampsd = dataArray{:, 1}(769:1024);
data.GAMMAATP.ampsd = dataArray{:, 2}(769:1024);
data.ALPHAATP.ampsd = dataArray{:, 3}(769:1024);
data.PE.ampsd = dataArray{:, 4}(769:1024);
data.PC.ampsd = dataArray{:, 5}(769:1024);
data.GPE.ampsd = dataArray{:, 6}(769:1024);
data.GPC.ampsd = dataArray{:, 7}(769:1024);
data.PI1.ampsd = dataArray{:, 8}(769:1024);

data.PCR.damp = dataArray{:, 1}(1025:1280);
data.GAMMAATP.damp = dataArray{:, 2}(1025:1280);
data.ALPHAATP.damp = dataArray{:, 3}(1025:1280);
data.PE.damp = dataArray{:, 4}(1025:1280);
data.PC.damp = dataArray{:, 5}(1025:1280);
data.GPE.damp = dataArray{:, 6}(1025:1280);
data.GPC.damp = dataArray{:, 7}(1025:1280);
data.PI1.damp = dataArray{:, 8}(1025:1280);

end