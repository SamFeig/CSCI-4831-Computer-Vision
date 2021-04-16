import flask
import numpy as np
import cv2 as cv
import os
import pickle
import copyreg
import sys
from os import path
from matplotlib import pyplot as plt
import feature_detector

def main():
    # Function to pickle cv.KeyPoint from:
    # https://stackoverflow.com/questions/10045363/pickling-cv2-keypoint-causes-picklingerror/48832618
    def _pickle_keypoints(point):
        return cv.KeyPoint, (*point.pt, point.size, point.angle,
                             point.response, point.octave, point.class_id)
    copyreg.pickle(cv.KeyPoint().__class__, _pickle_keypoints)


    #Testing
    load_matches = True
    features = {}

    if not path.exists("features.pickle"):
        dir = 'PhotoSorter_images/'
        directory = os.fsencode(dir)
        i = 0
        for file in os.listdir(directory):
            filename = os.fsdecode(file)
            img1 = cv.imread(dir + filename)
            img2 = cv.imread(dir + filename)
            kp1, des1 = feature_detector.doORB(img1)
            des1 = np.float32(des1)
            features[dir + filename] = (kp1, des1)
            i+= 1
            print(i)
        with open('features.pickle', 'wb') as handle:
            pickle.dump(features, handle, protocol=pickle.HIGHEST_PROTOCOL)
    else:
        with open('features.pickle', 'rb') as handle:
            features = pickle.load(handle)

    matched_images = {}

    if not load_matches:
        for file1 in features:
            if file1 not in matched_images.values() and file1 not in matched_images:
                matched_images[file1] = []

            (kp1, des1) = features[file1]
            for file2 in features:
                if (file2 not in matched_images.values() and file2 not in matched_images) and file1 != file2:
                    (kp2, des2) = features[file2]
                    match = feature_detector.doMatching(file1, kp1, des1, file2, kp2, des2)

                    if match is not None:
                        matched_images[file1].append(file2)
        with open('matches.pickle', 'wb') as handle:
            pickle.dump(matched_images, handle, protocol=pickle.HIGHEST_PROTOCOL)
    else:
        with open('matches.pickle', 'rb') as handle:
            matched_images = pickle.load(handle)

    print(matched_images)

    for i in matched_images:
        print(i, len(matched_images[i]))

    input("exit")
    #load the images set

    #sort images

    #select only:
        # § outdoor scenes
        # § portraits (of one or a group of people)
        # § text documents
        # § images containing cars
        # § images containing sky
        # § images containing flowers
        # § images containing buildings, etc.


    #add image to the set and re-sort, etc.


    pass

if __name__ == '__main__':
    main()
    # app.run()