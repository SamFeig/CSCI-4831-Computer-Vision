import cv2
import numpy as np
import os

# MobileNet-SSD pretrained files from [Howard et al., 2017] (https://arxiv.org/abs/1704.04861)
# Files found here: https://github.com/chuanqi305/MobileNet-SSD
# More information on model choice will be in the project report
caffe_model = "MobileNet-SSD.caffemodel"
caffe_prototext = "MobileNet-SSD.prototxt.txt"

# List of classes existing in the MobileNet model
classes = (
	"background", "aeroplane", "bicycle", "bird",
	"boat", "bottle", "bus", "car", "cat", "chair", 
	"cow", "diningtable","dog", "horse", "motorbike", 
	"person", "pottedplant", "sheep","sofa", "train", "tvmonitor")

# Given object list, return count of each found object based on a confidence threshold
def get_class_counts(objects, confidence_threshold = 0):
	counts = {}

	for filename, x in objects.items():
		for classname, confidence in x.items():
			if confidence > confidence_threshold:
				if classname in counts.keys():
					counts[classname] += 1
				else:
					counts[classname] = 1

	return counts

# Detect objects for all items in a folder
def process_folder(folder_path, confidence_threshold = 0):
	# Read dnn from caffe pre-trained file
	net = cv2.dnn.readNetFromCaffe(caffe_prototext, caffe_model)

	# Dict of detected objects by filename
	objects = {}

	# Loop over each file
	for filename in os.listdir(folder_path):
		# Exclude hidden files
		if not filename.startswith('.'):
			img_path = os.path.join(folder_path, filename)
			image = cv2.imread(img_path)

			# Resize the image into a blob to be used by this neural net
			# Exact reshape parameters found here: https://github.com/chuanqi305/MobileNet-SSD/blob/master/demo.py
			blob = cv2.dnn.blobFromImage(cv2.resize(image, (300, 300)), 0.007843, (300, 300), 127.5)

			# Set image blob as input
			net.setInput(blob)
			# Detect objects from input
			detections = net.forward()

			img_objects = {}
			for i in np.arange(0, detections.shape[2]):
				confidence = detections[0, 0, i, 2]
				object_class = classes[int(detections[0, 0, i, 1])]

				# Find all objects above the confidence threshold, and add them to a dictionary
				if confidence > confidence_threshold:
					# If multiple of the same object detected, store the highest confidence value
					if object_class in img_objects.keys():
						img_objects[object_class] = max(confidence, img_objects[object_class])
					# Store key-value pair of object and its confidence
					else:
						img_objects[object_class] = confidence

			objects[filename] = img_objects

	return objects