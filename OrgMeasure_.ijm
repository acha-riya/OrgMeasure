inputDir=getDirectory("Choose directory containing input files");

fileList=getFileList(inputDir);
outputDir = inputDir + "Processedbinary/";  // saves results in subfolder
File.makeDirectory(outputDir);

for(i = 0; i <= fileList.length-1; i++)

{

print(fileList[i]);
path = inputDir+fileList[i];

open(path);
measure(fileList[i]);

  baseName = replace(fileList[i], ".tif", "");
  baseName = replace(baseName, ".TIF", "");
  
 // --- SAVE THE FINAL BINARY IMAGE ---
 savePath = outputDir + baseName + "_binary.tif";
    saveAs("Tiff", savePath);
    
    // --- CLOSE FILE AFTER SAVING ---
    close();      // closes the current image
    run("Close All");  // extra safety if ROI/threshold windows remain
    print("Saved final binary to: " + savePath);

}

function measure(currentFile) 
{
// Step 1: Clear background
waitForUser("Step 1: Please clear the background manually if needed, then click OK to continue.");

run("Find Edges");
run("Invert");
setOption("BlackBackground", false);
run("Convert to Mask");
// Step 2: Remove Outliers and add adjustments as needed
run("Remove Outliers...", "radius=0.5 threshold=0 which=Dark");
/// Step 3: Apply default threshold
setAutoThreshold("Default");
run("Threshold...");
waitForUser("Adjust threshold manually, then click OK to continue.");
run("Smooth");
run("Smooth");
run("Smooth");
run("Smooth");
run("Smooth");
run("Smooth");
run("Smooth");
run("Smooth");
run("Smooth");
waitForUser("Smooth additionally as needed and clear the background outliers manually, then click OK to continue.");
setAutoThreshold("Default");
run("Threshold...");

answer = getBoolean("Is there a hole?");
// If YES → run your hole-filling steps
if (answer) {
	run("Threshold...");
	waitForUser("Adjust the threshold, then press OK to continue.");
    setOption("BlackBackground", false);
    run("Convert to Mask");
    run("Fill Holes");
} 
// If NO → continue to next step
else {
    print("Skipping hole-filling step.");
}

waitForUser("Adjust threshold manually, then click OK to continue.");
run("Convert to Mask");
run("Create Selection");
run("Measure");


}