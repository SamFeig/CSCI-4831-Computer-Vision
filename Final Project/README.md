# CSCI 5722 Final Project - Photo Sorter

## Project Team
* Sam Feig
* Vladimir Zhdanov

## Instructions to Run

## How to Use
When the program is initially ran, the following window appears.

<img src=https://i.imgur.com/HMdDqSD.png width="750">

Selecting an input and output directory will reveal more options.

<img src=https://i.imgur.com/5an6HLI.png width="750">

Adjusting the confidence threshold, and clicking `Detect Objects` will find all objects in the input files above the selected confidence threshold.

<img src=https://i.imgur.com/dsKunbB.png width="750">

Selecting one (or several) of the detected object groups, and clicking `View Image` will open an Image Viewer window, where the user can look at all images with those detected objects. When an image is selected, the confidence value for each object in the image is shown.

<img src=https://i.imgur.com/D06wyNI.png width="750">

Selecting one (or several) of the detected object groups, and clicking `Filter by Selected` will filter out all images except those containing the selected objects.

<img src=https://i.imgur.com/fgCKDeA.png width="750">

Selecting one (or several) of the detected object groups, and clicking `Filter out Selected` will filter out images containing the selected objects.

<img src=https://i.imgur.com/9IA3zIL.png width="750">

Choosing the `Sort Image` option will take the current input images (they can be filtered or not), and will open a new window to filter out near-duplicate images.

<img src=https://i.imgur.com/nA8iCrt.png width="750">

On this page, the user is able to detect features, match features, and set a threshold number of features to be considered a near-duplicate match. Checking the `Recompute Features` or `Recompute Matches` boxes will specify whether to recompute these values or to use previously saved features and matches (saved in a .pickle file locally). After features and matches are computed once, the user can adjust the match threshold and recompute the matches quickly, and not have to wait as long for feature computation.
<img src=https://i.imgur.com/TVeVj7n.png width="750">

The near-duplicate images will be grouped into separate directories in the specified output folder.

## Citations
There are few portions of our project which implement and use third party code. In sections where this is the case, we have added comments linking to the referenced material. Our write-up will specify in more detail the sources, and exactly how they were used. A few of the important sources used in our code are listed below as well:

* As part of our object detection logic, we used pretrained [MobileNet-SSD model and prototext files](https://github.com/chuanqi305/MobileNet-SSD) to initialize our Caffe neural network, and the model used was developed by Google reasearchers for efficient object detection (Paper: [Howard et al., 2017](https://arxiv.org/abs/1704.04861)).
* The [PySimpleGUI demo programs](https://github.com/PySimpleGUI/PySimpleGUI/blob/master/DemoPrograms) were referenced in building some of the GUI functionality, namely the Image Viewer.
