macro "origami_32bit_find_particles"{
//Input are 32bit tiff images that have been bakcground corrected in SPIP
//z values correspond to nm
//This macro will make a threshold at 0.5 nm, dilate and remove
//the obtained mask image from the source image

//threshMin = 0.2; //in nm
threshMax = 2.0; //in nm
minPartSize = 550; //in pix^2, an origami is 950 pix^2
maxPartSize = 1900; //

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



setBatchMode(true);
//setBatchMode(false);  
//for (i = 0; i<2; i++) 
for (i = 0; i<listInFolder.length; i++) 
	{
	//showMessage(sourceFolder+listInFolder[i]);
	open(sourceFolder+listInFolder[i]);
	sourceFileName = File.nameWithoutExtension;
	in2 = indexOf(sourceFileName, "C");
	tempStr = substring(sourceFileName, in2-2, in2);
	temp = parseInt(tempStr);
	//showMessage(tempStr+","+temp);
	if(temp <= 50)
	{
		threshMin = 0.5;
		erode = 1;
		maxPartSize = 1900;
	}
	else if( temp == 55 )
	{
		threshMin = 0.3;
		erode = 0;
		maxPartSize = 1900;
	}
	else if( 57 <= temp && temp<=59)
	{
		threshMin = 0.3;
		erode = 0;
		maxPartSize = "Infinity";
	}
	else if( temp == 61)
	{
		threshMin = 0.2;
		erode = 0;
		maxPartSize = "Infinity";
	}
	else if( temp == 63)
	{
		threshMin = 0.15;
		erode = 0;
		maxPartSize = "Infinity";
	}
	else if( 65 <= temp && temp<=70)
	{
		threshMin = 0.15;
		erode = 0;
		maxPartSize = "Infinity";
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
	run("Analyze Particles...", "size="+minPartSize+"-"+maxPartSize+" circularity=0.00-1.00 show=[Count Masks] display exclude clear add");
	run("Clear Results");
	selectImage("mask");
	run("From ROI Manager");
	Overlay.copy;
	selectImage(rawImageName);
	run("Duplicate...", "title=overlayRaw");
	Overlay.paste;
	saveAs("Tiff", overlayFolder+sourceFileName+"_overlay_thres_"+threshMin);
	//
	run("Hide Overlay");
	roiManager("Show All with labels");
	roiManager("Show All");
	run("Show Overlay");
	run("Select All");
	roiManager("Measure");
	saveAs("Results", resultsFolder+sourceFileName+"_results.csv");
//
	selectImage("Count Masks of mask");
	saveAs("Tiff", numberedMaskFolder+sourceFileName+"_numMask");
	run("Close All");
	run("Clear Results");
	}
setBatchMode(false); 
}//end of macro