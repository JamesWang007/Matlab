%loads results data extracted from ImageJ particle analysis (XXX_data.mat), in particular
%centroid, and angle and alligns all images from the facebook list
%makes pair-correlation of all the aligned images and draws the histograms
%results are soterd in a mat file_corrdata.mat stored in the workDir
clear all;
close all

%conditional flags
MAKE_CORRELATION = 0; %1 or 0 to maker image-image correlation
ALIGN_IMAGES = 1; %1 or 0 to align images
CALCULATE_IMAGE_STATS = 1; %use regionprops to extract particle properties from binary image
[dataFile workDir]= uigetfile(pwd, '.mat');
in1 = strfind(dataFile, '_data');
dataFileName = dataFile(1:in1);

%Main output is the structure
oriData = struct('stats', {}, 'fileName', {}, 'corrAB', {});
oriData(1).stats = {};
oriData(1).fileName = {};
oriData(1).corrAB = {};
oriData(1).tempLabel = {};

s(1).avg = {}; %struct to store average images

%workDir = uigetdir();
%tiffDir = workDir; %uncomment for old folder structure
tiffDir = fullfile(workDir, 'tiff');
overlayDir = fullfile(workDir, 'overlay');
maskDir = fullfile(workDir, 'numbered_mask');
resultsDir = fullfile(workDir, 'results');
corrDir = fullfile(workDir, 'corr');
facebookAlignDir = fullfile(workDir, 'facebook_list_align');
%facebookDir = fullfile(workDir, 'facebook_list');
avgDir = fullfile(workDir, 'aligned_avg');
if exist(corrDir, 'dir') ~= 7
    mkdir(corrDir);
end
if exist(facebookAlignDir, 'dir') ~= 7
    mkdir(facebookAlignDir);
end
% if exist(facebookDir, 'dir') ~= 7
%     mkdir(facebookDir);
% end
if exist(avgDir, 'dir') ~= 7
    mkdir(avgDir);
end


[fullFileInfo nFile] = get_filenames(tiffDir, 'tif');
[maskFileInfo nMaskFile] = get_filenames(maskDir, 'tif');
if nFile ~= nMaskFile
    error('different number of overlay and mask files')
end
%nFile = 5;

var = load(fullfile(workDir, [dataFileName, 'data'])); %loads a cell with the property names of all imageJ results properties
tempVect = var.tempVect;
tempLabel = var.tempLabel;
selProp = var.selProp;
resColLabel = var.resColLabel;
res = var.res;
pixel2nm = var.pixel2nm;
dataColLabel = var.dataColLabel;
data = var.data;
allProp = var.allProp;

nProp = size(res(1).data,2);
selProp = [];
%getting indexes of needed properties
for iProp= 1:nProp
    if strcmp(resColLabel{iProp}, 'X') %centroid poisiton
        cxIndex = [selProp, iProp];
    elseif strcmp(resColLabel{iProp}, 'Y')
        cyIndex =  [selProp, iProp];
    elseif strcmp(resColLabel{iProp}, 'Angle')
        angleIndex =  [selProp, iProp];
    elseif strcmp(resColLabel{iProp}, 'BX') %bounding box x
        bxIndex =  [selProp, iProp] ;
    elseif strcmp(resColLabel{iProp}, 'BY') %bounding box y
        byIndex =  [selProp, iProp]; %+1 bcs imagej starts in 0 and matlab in 1
    elseif strcmp(resColLabel{iProp}, 'Width') %bounding box width
        bwIndex =  [selProp, iProp];
    elseif strcmp(resColLabel{iProp}, 'Height') %bounding box height
        bhIndex =  [selProp, iProp];
    elseif strcmp(resColLabel{iProp}, 'Feret') %feret
        feretIndex =  [selProp, iProp];
    elseif strcmp(resColLabel{iProp}, 'FeretAngle') %feret angle
        feretAngIndex =  [selProp, iProp];
    elseif strcmp(resColLabel{iProp}, 'Circ.') %feret angle
        circIndex =  [selProp, iProp];
    elseif strcmp(resColLabel{iProp}, 'Minor') %ellipse minor axis
        minorIndex =  [selProp, iProp];
    end
end


tagstruct.Photometric     = Tiff.Photometric.MinIsBlack;
tagstruct.BitsPerSample   = 32;
tagstruct.SamplesPerPixel = 1;
%tagstruct.RowsPerStrip    = 1024;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.SampleFormat = 3;
%tagstruct.Software        = 'MATLAB';
maxWidth = 0;
maxHeight = 0;
for iFile=1:nFile
    %if tempVect(iFile) == 20;
    im = load_image(tiffDir, fullFileInfo(iFile).name, 'tif');
    display(fullFileInfo(iFile).name)
    %finding particles in mask from imageJ
    numMask = load_image(maskDir, maskFileInfo(iFile).name, 'tif');
    %     maskImage = imrotate(maskImage, 90,'bilinear','loose'); %rotate to have same particle numbers as in imagej
    %     numMask = bwlabel(maskImage);
    %     numMask = imrotate(numMask, -90,'bilinear','loose');
    %     figure
    %     imshow(numMask)
    
    %%end find particles
    imInfo = imfinfo( fullfile(tiffDir, fullFileInfo(iFile).name) );
    [a fileNameNoExt ext] = fileparts(fullFileInfo(iFile).name);
    widthOverlay = imInfo.Width; heightOverlay = imInfo.Height;
    dat = res(iFile).data;
    nPart = size(dat,1);
    %max(max(numMask))
%     if nPart ~= max(max(numMask));
%         %error('num part in overlay and results are different')
%         method = 'MATLAB';
%         nPart = max(max(numMask));
%     else
%         method = 'IMAGEJ';
%     end
    method = 'IMAGEJ';
    display(method);
    if strcmp(method, 'MATLAB')
        stats = regionprops(numMask, 'all');
        oriData(iFile).stats = stats;
    end
    
    oriData(iFile).fileName = fileNameNoExt;
    outDir = fullfile(facebookAlignDir, [fileNameNoExt, '_facebook_align/'] );
    if exist(outDir, 'dir') ~= 7
        mkdir(outDir);
    end
%     outDirNonResized = fullfile(facebookAlignDir, [fileNameNoExt, '_facebook_align_no_resized/'] );
%     if exist(outDirNonResized, 'dir') ~= 7
%         mkdir(outDirNonResized);
%     end
    
    
    if ALIGN_IMAGES
        for iPart = 1:nPart
            if strcmp(method, 'IMAGEJ')
                cx      = dat(iPart, cxIndex);
                cy      = dat(iPart, cyIndex);
                if dat(iPart, circIndex) < 0.7
                    angle   = dat(iPart, angleIndex);
                else
                    angle   = dat(iPart, feretAngIndex);
                end
                bx      = dat(iPart, bxIndex);
                by      = dat(iPart, byIndex);
                bw      = dat(iPart, bwIndex);
                bh      = dat(iPart, bhIndex);
            elseif strcmp(method, 'MATLAB')
                cent = stats(iPart).Centroid;
                cx = cent(1); cy = cent(2);
                bound = stats(iPart).BoundingBox;
                bx = bound(1); by = bound(2); bw = bound(3); bh = bound (4);
                bx = uint16(bx-0.5); by = uint16(by-0.5); %matlab has a 0.5 difference in respect to imagej
                angle   = stats(iPart).Orientation;
            end
            if ~mod(bw,2) %if even
                bw = bw + 1;
            end
            if ~mod(bh,2) %even
                bh = bh + 1;
            end
            vb_xywh(iPart, 1:4) = [bx, by, bw, bh];
            %  cx
            %  bx
            %  bw
            %  bh
            bBox = im(by:by+bh-1, bx:bx+bw-1); % bounding box
            numMaskBbox = (numMask(by:by+bh-1, bx:bx+bw-1) == iPart );
            rawParticle = bBox.*numMaskBbox; %particle without the surrounding background
            size(rawParticle);
            %figure
            %imshow(rawParticle)
            if (iPart < 10)
                ext = sprintf('_00%d', iPart);
            elseif (iPart < 100)
                ext = sprintf('_0%d', iPart);
            else
                ext = sprintf('_%d', iPart);
            end
            %     t = Tiff(fullfile(facebookDir, [fileNameNoExt, ext '.tif']),'w');
            %     tagstruct.ImageLength     = size(bBox, 1);
            %     tagstruct.ImageWidth      = size(bBox, 2);
            %     t.setTag(tagstruct);
            %     t.write(bBox);
            %     t.close();
            xCenter = ceil(bw/2);
            yCenter = ceil(bh/2);
            
            xTranslate = xCenter - (cx - bx); yTranslate = yCenter - (cy -by);
            %define the transformation matrix
            xForm = [ 1     0         0;
                0    1          0;
                xTranslate yTranslate     1 ];
            xForm = double(xForm);
            tformTranslateRotate = maketform('affine',xForm);
            [imTrans xdata ydata]= imtransform(rawParticle, tformTranslateRotate);
            imTransf = imrotate(imTrans, -angle,'bilinear','loose');
            % figure;
            % imshow(imTrans)
            %make all images same size
            if iPart == 1
                if strcmp(method, 'IMAGEJ')
                    finalbbWidth = ceil(max( dat(:, feretIndex) ));
                    finalbbHeight = ceil(max( dat(:, minorIndex) ));
                elseif strcmp(method, 'MATLAB')
                    finalbbWidth = 0;
                    finalbbHeight = 0;
                    for jPart =1:nPart
                        currbbWidth = stats(jPart).MajorAxisLength;
                        currbbHeight = stats(jPart).MinorAxisLength;
                        if currbbWidth > finalbbWidth
                            finalbbWidth = currbbWidth;
                        end
                        if currbbHeight > finalbbHeight
                            finalbbHeight = currbbHeight;
                        end
                    end
                    finalbbWidth = int16(finalbbWidth);
                    finalbbHeight = int16(finalbbHeight);
                end
                if finalbbWidth > maxWidth
                    maxWidth = finalbbWidth;
                end
                if finalbbHeight > maxHeight
                    maxHeight = finalbbHeight;
                end
            end
            %make dimensions of the final images odd
            if ~mod(finalbbWidth,2) %if even
                finalbbWidth = finalbbWidth + 1;
            end
            if ~mod(finalbbHeight,2) %if even
                finalbbHeight = finalbbHeight + 1;
            end
            finalXCenter = ceil(finalbbWidth/2);
            finalYCenter = ceil(finalbbHeight/2);
            imFinal = zeros(finalbbHeight, finalbbWidth);
            if iPart == 1
                sum = zeros(size(imFinal));
            end
            
            %Do imTransf and imFinal have identical sizes?
            
            imFinal = image_resize(imTransf, finalbbHeight, finalbbWidth);
            %     figure;
            %     imshow(imFinal)
            sum = sum + imFinal;
            imFinal = single(imFinal);
            
            
            %save final aligned an resized images
            t = Tiff(fullfile(outDir, [fileNameNoExt, ext '.tif']),'w');
            tagstruct.ImageLength     = size(imFinal, 1);
            tagstruct.ImageWidth      = size(imFinal, 2);
            t.setTag(tagstruct);
            t.write(imFinal);
            t.close();
            
        end
        s(iFile).avg = single(sum/nPart); %average image
    end %if ALLIGN_IMAGES
    
    %Make correlation matrix
    if MAKE_CORRELATION
        [allignedFileInfo nPart] = get_filenames(outDir, 'tif');
        corrAB = zeros(nPart, nPart);
        for iPart = 1:nPart
            A = load_image(outDir, allignedFileInfo(iPart).name, 'tif');
            for jPart = 1:nPart
                B = load_image(outDir, allignedFileInfo(jPart).name, 'tif');
                corrAB(iPart, jPart) = corr2(A,B);
            end
        end
        oriData(iFile).corrAB = corrAB;
        oriData(iFile).tempLabel = tempLabel;
        %correlation image
        t = Tiff(fullfile(corrDir, [fileNameNoExt,'_corr.tif']),'w');
        tagstruct.ImageLength     = size(corrAB, 1);
        tagstruct.ImageWidth      = size(corrAB, 2);
        t.setTag(tagstruct);
        t.write(single(corrAB));
        t.close();
        %correlation histograms
        figure;
        hist(corrAB(:), 30)
        ylabel('number');
        xlabel('foldamer-foldamer correlation');
        title(tempLabel(iFile));
        saveas(gcf, fullfile(corrDir, [fileNameNoExt,'_corr_hist.fig']) );
        close(gcf);
    end
    %end
end

%save average images of equal size
for iFile = 1: nFile
    avg = s(iFile).avg;
    avgOut = image_resize(avg, maxHeight, maxWidth);
    avgOut = single(avgOut);
    [fold fName ext] = fileparts(fullFileInfo(iFile).name);
    t = Tiff(fullfile(avgDir, [ fName, '_avg.tif']),'w');
    tagstruct.ImageLength     = size(avgOut, 1);
    tagstruct.ImageWidth      = size(avgOut, 2);
    t.setTag(tagstruct);
    t.write(avgOut);
    t.close();
end

save(fullfile(workDir, [dataFileName,'corrdata']), 'oriData');
cd(workDir);
