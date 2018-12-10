%Takes a list of facebook aligned folders and registers them.
%should be executed in the general folder used for analysis (a folder
%containing folers such as 'facebook_list_align', 'tiff', 'overlay'..
%A model image against which to compare all images is needed. It's called
%fixed. It also avergaes all the registered images

[optimizer,metric] = imregconfig('monomodal');
[dataFile workDir] = uigetfile(pwd, '*.tif');
fixed = imread(fullfile(workDir, dataFile)); %reading the model image against which all images will be registered
facebookDir = fullfile(workDir, 'facebook_list_align');
registerDir = fullfile(workDir, 'facebook_registered');
if exist(registerDir, 'dir') ~= 7
    mkdir(registerDir)
end
cd(facebookDir);
fullFolderInfo = dir();
nFolders = length(fullFolderInfo); %number of folder

tagstruct.Photometric     = Tiff.Photometric.MinIsBlack;
tagstruct.BitsPerSample   = 32;
tagstruct.SamplesPerPixel = 1;
%tagstruct.RowsPerStrip    = 1024;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.SampleFormat = 3;

%first we need to know the dimensions of the largest image
iGoodFolder=0;
for iFolder = 1: nFolders
    if ~isempty(strfind(fullFolderInfo(iFolder).name, 'facebook'))
        iGoodFolder = iGoodFolder +1;
        cd(fullfile(facebookDir, fullFolderInfo(iFolder).name));
        fullFileInfo = dir(); %struct array with file name and info
        nFiles = length(fullFileInfo); %number of files
        for iFile = 1:nFiles
            if iFile == 1;
                maxHeight(iGoodFolder) = 0;
                maxWidth(iGoodFolder) = 0;
            end
            fullPath = fullfile(pwd, fullFileInfo(iFile).name);
            [a fileNameNoExt ext] = fileparts(fullPath);
            if strcmp(ext, '.tif')
                im = imread(fullPath);
                if size(im, 1) > maxHeight(iGoodFolder)
                    maxHeight(iGoodFolder) = size(im, 1);
                end
                if size(im, 2) > maxWidth(iGoodFolder)
                    maxWidth(iGoodFolder) = size(im, 2);
                end
            end
        end
    end
end
%we resize the fixed image for each folder
nGoodFolders = iGoodFolder;
fixedAll(1).im = [];
for iGoodFolder = 1:nGoodFolders
    %resizing the fixed image
    if maxHeight(iGoodFolder) > size(fixed, 1)
        dh = floor((maxHeight(iGoodFolder) - size(fixed, 1))/2);
    else
        dh = 1;
    end
    if maxWidth(iGoodFolder) > size(fixed, 2)
        dw = floor((maxWidth(iGoodFolder) - size(fixed, 2))/2);
    else
        dw = 1;
    end
    tmp = zeros(maxHeight(iGoodFolder), maxWidth(iGoodFolder));
    tmp(dh:(size(fixed, 1)+dh-1), dw:(size(fixed, 2)+dw-1) ) = fixed;
    fixedAll(iGoodFolder).im  = tmp;
    %figure;imshow(fixedAll(iGoodFolder).im )
end

%We make the actual registration with our set of fixed images (all equal
%but diff sizes)
iGoodFolder = 0;
for iFolder = 1: nFolders
    if ~isempty(strfind(fullFolderInfo(iFolder).name, 'facebook'))
        iGoodFolder = iGoodFolder +1;
        fixed = fixedAll(iGoodFolder).im;
        inFolder = fullfile(facebookDir, fullFolderInfo(iFolder).name)
        cd(inFolder);
        fullFileInfo = dir(); %struct array with file name and info
        nFiles = length(fullFileInfo); %number of files
        outDir = (fullfile(registerDir, fullFolderInfo(iFolder).name));
        if exist(outDir, 'dir') ~= 7
            mkdir(outDir)
        end
        for iFile = 1:nFiles
            fullPath = fullfile(pwd, fullFileInfo(iFile).name);
            [a fileNameNoExt ext] = fileparts(fullPath);
            if strcmp(ext, '.tif')
                moving = imread(fullPath);
                imOut = imregister(moving, fixed, 'rigid', optimizer, metric);
                imOut = single(imOut);
                t = Tiff(fullfile(outDir, [fileNameNoExt, '.tif']),'w');
                tagstruct.ImageLength     = size(imOut, 1);
                tagstruct.ImageWidth      = size(imOut, 2);
                t.setTag(tagstruct);
                t.write(imOut);
                t.close();
            end
        end
    end
end

%and we average the registered images

maxWidthAll = max(max(maxWidth));
maxHeightAll = max(max(maxHeight));
for iFolder = 1: nFolders
    if ~isempty(strfind(fullFolderInfo(iFolder).name, 'facebook'))
        inFolder = fullfile(registerDir, fullFolderInfo(iFolder).name)
        cd(inFolder);
        fullFileInfo = dir(); %struct array with file name and info
        nFiles = length(fullFileInfo); %number of files
        outDir = fullfile(registerDir, 'avg');
        if exist(outDir, 'dir') ~= 7
            mkdir(outDir)
        end
        iGoodFile = 0;
        for iFile = 1:nFiles
            fullPath = fullfile(pwd, fullFileInfo(iFile).name);
            [a fileNameNoExt ext] = fileparts(fullPath);
            if strcmp(ext, '.tif')
                iGoodFile = iGoodFile +1;
                if iGoodFile == 1
                    im = imread(fullPath);
                    avg = zeros(size(im));
                end
                im = imread(fullPath);
                avg = im + avg;
            end
        end
        avg = avg/nFiles;
        avg = single(image_resize(avg, maxHeightAll, maxWidthAll));
        t = Tiff(fullfile(outDir, [fileNameNoExt, '.tif']),'w');
        tagstruct.ImageLength     = size(avg, 1);
        tagstruct.ImageWidth      = size(avg, 2);
        t.setTag(tagstruct);
        t.write(avg);
        t.close();
    end
end
