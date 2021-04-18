import flask
import numpy as np
import cv2 as cv
import os
import pickle
import copyreg
import shutil
import sys
from os import path
from matplotlib import pyplot as plt
import feature_detector

images = []

def addImgsToSet():


    images.append()


    pass

def sortImages():
    images.sort()


def main():
    # Function to pickle cv.KeyPoint from:
    # https://stackoverflow.com/questions/10045363/pickling-cv2-keypoint-causes-picklingerror/48832618
    def _pickle_keypoints(point):
        return cv.KeyPoint, (*point.pt, point.size, point.angle,
                             point.response, point.octave, point.class_id)
    copyreg.pickle(cv.KeyPoint().__class__, _pickle_keypoints)


    #Testing
    load_matches = True
    create_dirs = True
    features = {}
    matched_images = {}
    dir = 'PhotoSorter_images/'

    # Load all images and detect features
    if not path.exists("features.pickle"):

        directory = os.fsencode(dir)
        i = 0
        for file in os.listdir(directory):
            filename = os.fsdecode(file)
            img1 = cv.imread(dir + filename)
            img2 = cv.imread(dir + filename)
            kp1, des1 = feature_detector.doORB(img1)
            des1 = np.float32(des1)
            features[filename] = (kp1, des1)
            i+= 1
            print(i)
        with open('features.pickle', 'wb') as handle:
            pickle.dump(features, handle, protocol=pickle.HIGHEST_PROTOCOL)
    else:
        with open('features.pickle', 'rb') as handle:
            features = pickle.load(handle)

    seen = {}
    # Do matching on all images
    if not load_matches:
        for file1 in features:
            if file1 not in seen.keys():
                matched_images[file1] = []

                (kp1, des1) = features[file1]
                for file2 in features:
                    if file2 not in seen.keys() and file1 != file2:
                        (kp2, des2) = features[file2]
                        match = feature_detector.doMatching(dir+file1, kp1, des1, dir+file2, kp2, des2, 5)

                        if match is not None:
                            seen[file2] = 1
                            seen[file1] = 1
                            matched_images[file1].append(file2)

        with open('matches.pickle', 'wb') as handle:
            pickle.dump(matched_images, handle, protocol=pickle.HIGHEST_PROTOCOL)
    else:
        with open('matches.pickle', 'rb') as handle:
            matched_images = pickle.load(handle)

    # Cleanup duplicates
    for i in list(matched_images):
        # print(i, matched_images[i])
        for j in list(matched_images):
            if j in matched_images[i]:
                print("del", j)
                del matched_images[j]

    # Sort images into folders
    if create_dirs:
        try:
            shutil.rmtree("output/")
            os.mkdir("output/")
        except:
            pass

        try:
            for img in matched_images:
                # head, tail = os.path.split(img)
                # outDir1 = "output/" + tail[:-4]
                outDir1 = "output/" + img[:-4]
                os.mkdir(outDir1)

                shutil.copy(dir+img, outDir1)

                for img2 in matched_images[img]:
                    # head2, tail2 = os.path.split(img2)
                    # outDir2 = outDir1 + "/" + tail2
                    outDir2 = outDir1 + "/" + img2

                    shutil.copy(dir+img2, outDir2)
        except Exception as e:
            print("Unable to copy file.", e)

        # Redo matching with first image in each cluster to get better accuracy
        dir2 = os.fsencode("output/")
        for folder in os.listdir(dir2):
            if os.path.exists(dir2 + folder):
                file1 = os.listdir(dir2 + folder)[0]
                img1name_raw = os.fsdecode(file1)
                img1name = os.path.split(img1name_raw)[1]

                (kp1, des1) = features[img1name]

                for folder2 in os.listdir(dir2):

                    if folder != folder2 and folder2 != ".DS_Store":
                        file2 = os.listdir(dir2 + folder2)[0]
                        img2name_raw = os.fsdecode(file2)
                        img2name = os.path.split(img2name_raw)[1]

                        (kp2, des2) = features[img2name]
                        foldername1 = (dir2+folder).decode()
                        foldername2 = (dir2+folder2).decode()

                        # print("TESTING:", foldername1+"/"+img1name, foldername2+"/"+img2name) #dir+img1name
                        match = feature_detector.doMatching(foldername1+"/"+img1name, kp1, des1, foldername2+"/"+img2name, kp2, des2, 4)

                        if match is not None:
                            # Merge folders

                            print("merging folders:", foldername1, foldername2)
                            # print(dir2, folder2)
                            for img in os.listdir(foldername2):
                                # print(img, "output/" + foldername1)
                                shutil.move(foldername2 + "/" + img, foldername1)
                            shutil.rmtree(foldername2)





    print(matched_images)

    # for i in matched_images:
    #     print(i, len(matched_images[i]))


    #sort images
    # sortImages()

    #select only:
        # § outdoor scenes
        # § portraits (of one or a group of people)
        # § text documents
        # § images containing cars
        # § images containing sky
        # § images containing flowers
        # § images containing buildings, etc.


    #add image to the set and re-sort, etc.


if __name__ == '__main__':
    main()
    # app.run()