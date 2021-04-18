import cv2
import numpy as np
import os
import pprint

caffe_model = "MobileNet-SSD.caffemodel"
caffe_prototext = "MobileNet-SSD.prototxt.txt"

CLASSES = (
	"background", "aeroplane", "bicycle", "bird",
	"boat", "bottle", "bus", "car", "cat", "chair", 
	"cow", "diningtable","dog", "horse", "motorbike", 
	"person", "pottedplant", "sheep","sofa", "train", "tvmonitor")


def process_folder(folder_path):
	net = cv2.dnn.readNetFromCaffe(caffe_prototext, caffe_model)

	objects = {}

	for filename in os.listdir(folder_path):
		img_path = os.path.join(folder_path,filename)
		image = cv2.imread(img_path)
		blob = cv2.dnn.blobFromImage(cv2.resize(image, (300, 300)), 0.007843, (300, 300), 127.5)
		
		net.setInput(blob)
		detections = net.forward()

		img_objects = {}
		for i in np.arange(0, detections.shape[2]):
			confidence = detections[0, 0, i, 2]
			object_class = CLASSES[int(detections[0, 0, i, 1])]
			if confidence > 0:
				if object_class in img_objects.keys():
					img_objects[object_class] = max(confidence, img_objects[object_class])
				else:
					img_objects[object_class] = confidence

		objects[filename] = img_objects
	
	return objects


if __name__ == '__main__':
	objects = process_folder("test_imgs")
	pprint.pprint(objects)