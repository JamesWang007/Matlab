macro "origami_32bit_test_thresholds"{
//Input are 32bit tiff images that have been bakcground corrected in SPIP
//z values correspond to nm
//This macro will make a threshold at 0.5 nm, dilate and remove
//the obtained mask image from the source image

threshMin = 0.5; //in nm
threshMax = 2.0; //in nm
minPartSize = 550; //in pix^2
thresRange = 0;
thresRange = newArray(0.30, 0.35, 0.40, 0.45, 0.50);
	
run("Close All");
workFolder = getDirectory("Choose a Directory");
sourceFolder = workFolder+"tiff/";
listInFolder = getFileList(sourceFolder);
maskFolder = workFolder+"mask/";
File.makeDirectory(maskFolder);
overlayFolder = workFolder+"overlay/";
File.makeDirectory(overlayFolder);
resultsFolder = workFolder+"results/";
File.makeDirectory(resultsFolder);
numberedMaskFolder = workFolder+"numbered_mask/";
File.makeDirectory(numberedMaskFolder);



//		showMessage(sourceFileName);
setBatchMode(true);
//setBatchMode(false);  
//for (i = 0; i<2; i++) 
for (i = 0; i<listInFolder.length; i++) 
	{
		for(j = 0; j<thresRange.length; j++)
		{
	//showMessage(sourceFolder+listInFolder[i]);
	open(sourceFolder+listInFolder[i]);
	sourceFileName = File.nameWithoutExtension;
	in2 = indexOf(sourceFileName, "C");
	//showMessage(sourceFileName);
	tempStr = substring(sourceFileName, in2-2, in2);

	//showMessage(tempStr);
	temp = parseInt(tempStr); 
	//showMessage(tempStr+","+temp);
	if(temp <= 55)
	{
		threshMin = thresRange[j];
		erode = 1;
	}
	else
	{
		threshMin = thresRange[j];
		erode = 0;
	}
	rawImageName = getTitle();
	rawImageId = getImageID();
	//setBatchMode(true); 
	//Creating the mask image from the source image
	run("Duplicate...", "title=mask");
	setThreshold(threshMin, threshMax);
	setOption("BlackBackground", true);
	run("Convert to Mask");
	//2 erodes and 3 dilates to remove small particles
	if(erode)
	{
		run("Erode");run("Erode");
		run("Dilate"); run("Dilate");run("Dilate");
	}
	else
	{
		run("Erode");
		run("Dilate"); run("Dilate");
	}
	//Clean raw image
	run("Duplicate...", "title=32bitMask");
	run("32-bit");
	run("Divide...", "value=255");
	imageCalculator("Multiply create", "32bitMask", rawImageName);
	rename("maskedRaw");
	saveAs("Tiff", maskFolder+sourceFileName+"_masked_raw");
	maskedRawName = getTitle();
	imageCalculator("Subtract create", rawImageName, maskedRawName);
	saveAs("Tiff", maskFolder+sourceFileName+"_residual");
	//setBatchMode(false);
	//Find particles in mask
	selectImage("mask");
	//run("Analyze Particles...", "size="+minPartSize+"-Infinity circularity=0.00-1.00 show=[Overlay Outlines] display exclude clear");
	run("Analyze Particles...", "size="+minPartSize+"-Infinity circularity=0.00-1.00 show=[Count Masks] display exclude clear add");
	saveAs("Results", resultsFolder+sourceFileName+"_results.csv");
	selectImage("mask");
	run("From ROI Manager");
	Overlay.copy;
	selectImage(rawImageName);
	run("Duplicate...", "title=overlayRaw");
	Overlay.paste;
	saveAs("Tiff", overlayFolder+sourceFileName+"_overlay_thres_"+threshMin);
	selectImage("Count Masks of mask");
	saveAs("Tiff", numberedMaskFolder+sourceFileName+"_numMask");
	run("Close All");
	run("Clear Results");
		}//end for j
	}// end for i
setBatchMode(false); 
}//end of macro