inputDir=getDirectory("Choose directory containing input files");

// Create a Processedbinary subfolder if it doesn't exist
outputDir = inputDir + "Processedbinary" + File.separator;
File.makeDirectory(outputDir);

fileList = getFileList(inputDir);

for (i = 0; i < fileList.length; i++) {
    if (endsWith(fileList[i], ".tif") || endsWith(fileList[i], ".tiff")) {
        print("Processing: " + fileList[i]);
        path = inputDir + fileList[i];
        open(path);
        measure(fileList[i]);
    } else {
        print("Skipping non-TIF file: " + fileList[i]);
    }
{

print(fileList[i]);
path = inputDir+fileList[i];

open(path);
measure(fileList[i]);

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
waitForUser("Adjust threshold manually, then click OK to continue.");
run("Convert to Mask");
run("Create Selection");
run("Measure");

  // NEW SECTION: Save binary image
    baseName = replace(currentFile, ".tif", "");
    baseName = replace(baseName, ".tiff", "");
    savePath = outputDir + baseName + "_binary.tif";

    // Ensure directory exists before saving
    File.makeDirectory(outputDir);

    // Try saving and catch errors
    if (isOpen(baseName + "_binary")) {
        selectWindow(baseName + "_binary");
    }
    saveAs("Tiff", savePath);
    print("✅ Saved processed image to: " + savePath);

    // close to keep workspace clean
    close();
}