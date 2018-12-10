%importng csv data corresponding to imageJ results files
clear all;
close all;
mainFolder = uigetdir(pwd); %'/Volumes/Data/Andre_sur_Meursault/Articles/2015/folding_origami/DATA/141118_Origami_Thermodynamics_70C-40C_ENS/spip_corrected/tiff';
propName = load('results_property_name.mat'); %loads a cell with the property names of all imageJ results properties
%two var: selectedProperties and allProperties
selProp = propName.selectedProperties;
allProp = propName.allProperties;
workDir = fullfile(mainFolder, 'results');
fullFileInfo= getfilenames(workDir, '*.csv');
nFiles = length(fullFileInfo);

%tempLabel = {'40 C', '40 C', '55 C', '59 C','61 C', '63 C','65 C', '69 C', '70 C'};
pixel2nm = 3000/1024; %For experiments at ENS
% if(nFiles ~= size(tempVect,1))
%     error('number of files differs of temperature vector!');
% end
nPart = 0;
for i = 1:nFiles
    res(i) = importdata(fullfile(workDir,  fullFileInfo(i).name), ',');
    nPart = size(res(i).data,1) + nPart;
end
tempVect = zeros(1, nFiles);
tempLabel = cell(1, nFiles);
for i = 1:nFiles
    res(i).T =tempVect(i);
    fName = fullFileInfo(i).name;
    res(i).fName = fName;
    in2 = strfind(fName, 'C_');
    tempStr = fName(in2-2:in2-1)
    tempVect(i) = str2num(tempStr);
    tempLabel{i} = [tempStr, ' C'];
end
fName = fullFileInfo(1).name;
k = strfind(fName, '_');
fileNameBase = fName(1:k(2)-1);

%putting all data in a single matrix
 textdata = res(1).textdata;
 data = zeros(nPart, size(res(1).data,2)+2);
 last = 0;
 for i = 1:nFiles
     first = last +1;
     last = size(res(i).data,1) + first -1;
     data(first:last, 1) =  tempVect(i); %temperature
     data(first:last, 2) =  [1:size(res(i).data,1)]'; %Particle number
     data(first:last, 3:end) =  res(i).data;
 end
 
resColLabel = res(1).textdata(1,3:end);
dataColLabel = ['Temp (C)', 'Part. Number', res(1).textdata(1,3:end)]; %labels of results csv file columns

save(fullfile(mainFolder, [fileNameBase, '_data.mat']), 'tempVect', 'tempLabel', 'selProp', 'resColLabel', 'res', 'pixel2nm', 'dataColLabel', 'data', 'allProp');