import copyreg
import os
import pickle
import shutil
from os import path

import cv2 as cv
import numpy as np

import feature_detector


# def innerLoop(args):
#     file1, seen, features = args
#     matches = np.zeros(len(features))
#     keys = list(features.keys())
#
#     dir = 'PhotoSorter_images/'
#     for file2 in features:
#         # Only do lower triangular
#         if file2 not in seen.keys() and file1 != file2:
#             (kp1, des1) = features[file1]
#             (kp2, des2) = features[file2]
#
#             (img1, img2), match_count = feature_detector.doMatching(dir + file1, kp1, des1, dir + file2,
#                                                                     kp2, des2)
#             print((os.path.split(img1)[1], os.path.split(img2)[1]), match_count)
#             idx1 = keys.index(os.path.split(img1)[1])
#             idx2 = keys.index(os.path.split(img2)[1])
#             matches[idx2] = match_count
#             # seen[file2] = 1
#     return matches

def computeFeatures():
    features = {}
    dir = 'PhotoSorter_images/'
    # Load all images and detect features
    if not path.exists("features.pickle"):

        directory = os.fsencode(dir)
        i = 0
        for file in os.listdir(directory):
            # Ignore hidden files
            if not file.startswith(b'.'):
                filename = os.fsdecode(file)
                img1 = cv.imread(dir + filename)
                img2 = cv.imread(dir + filename)
                kp1, des1 = feature_detector.doSIFT(img1)
                des1 = np.float32(des1)
                features[filename] = (kp1, des1)
                i += 1
                print(i)
        with open('features.pickle', 'wb') as handle:
            pickle.dump(features, handle, protocol=pickle.HIGHEST_PROTOCOL)
    else:
        with open('features.pickle', 'rb') as handle:
            features = pickle.load(handle)
    return features


def computeMatches(features, MATCH_LIMIT, recompute):
    dir = 'PhotoSorter_images/'
    seen = {}
    matched_images = {}
    # Do matching on all images
    if recompute:
        for file1 in features:
            if file1 not in seen.keys():
                matched_images[file1] = []

                (kp1, des1) = features[file1]
                for file2 in features:
                    if file2 not in seen.keys() and file1 != file2:
                        (kp2, des2) = features[file2]
                        # match, _ = feature_detector.doMatching_with_display(dir + file1, kp1, des1, dir + file2, kp2, des2, MATCH_LIMIT)
                        match, match_count = feature_detector.doMatching(dir+file1, kp1, des1, dir+file2, kp2, des2, MATCH_LIMIT)
                        if match is not None:
                            print((os.path.split(match[0])[1], os.path.split(match[1])[1]), match_count)
                            seen[file2] = 1
                            seen[file1] = 1
                            matched_images[file1].append(file2)

        with open('matches.pickle', 'wb') as handle:
            pickle.dump(matched_images, handle, protocol=pickle.HIGHEST_PROTOCOL)
    else:
        with open('matches.pickle', 'rb') as handle:
            matched_images = pickle.load(handle)
    return matched_images


def computeMatchesMatrix(features, recompute):
    dir = 'PhotoSorter_images/'
    N = len(features)
    # Store number of matches between all image pairs, diag is inf as each image is the same as itself
    matches = np.zeros(shape=(N, N))
    np.fill_diagonal(matches, np.inf)

    keys = list(features.keys())
    seen = {}
    if recompute:
        for file1 in features:
            if file1 not in seen.keys():
                for file2 in features:
                    # Only do lower triangular
                    if file2 not in seen.keys() and file1 != file2:
                        (kp1, des1) = features[file1]
                        (kp2, des2) = features[file2]

                        (img1, img2), match_count = feature_detector.doMatchingMatrix(dir + file1, kp1, des1, dir + file2,
                                                                                kp2, des2)
                        print((os.path.split(img1)[1], os.path.split(img2)[1]), match_count)
                        idx1 = keys.index(os.path.split(img1)[1])
                        idx2 = keys.index(os.path.split(img2)[1])
                        matches[idx1][idx2] = match_count
                        # seen[file2] = 1

                    seen[file1] = 1
        with open('matches_matrix.pickle', 'wb') as handle:
            pickle.dump(matches, handle, protocol=pickle.HIGHEST_PROTOCOL)
    else:
        with open('matches_matrix.pickle', 'rb') as handle:
            matches = pickle.load(handle)
    return matches


def sortToFolders(matched_images):
    dir = 'PhotoSorter_images/'
    try:
        if os.path.exists("output/"):
            shutil.rmtree("output/")
        os.mkdir("output/")
    except Exception as e:
        print(e)

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


def sortToFoldersMatrix(matches, features, MATCH_LIMIT):
    dir = 'PhotoSorter_images/'
    keys = list(features.keys())
    # Sort images into folders
    try:
        if os.path.exists("output/"):
            shutil.rmtree("output/")
        os.mkdir("output/")
    except Exception as e:
        print(e)

    try:
        locs = np.argwhere((matches > MATCH_LIMIT))  # & (matches != np.inf))
        # print(locs)
        seen = {}
        for loc in locs:
            img1 = keys[loc[0]]
            img2 = keys[loc[1]]
            # print(loc[0], img1, loc[1], img2)
            if img1 not in seen:
                outDir = "output/" + img1[:-4]
                os.mkdir(outDir)
                shutil.copy(dir + img1, outDir)
                seen[img1] = 1
                # print("added")

            if img2 not in seen:
                outDir = "output/" + img1[:-4]
                shutil.copy(dir + img2, outDir)
                seen[img2] = 1
                # print("added")
    except Exception as e:
        print("Unable to copy file.", e)

def main():
    # Function to pickle cv.KeyPoint from:
    # https://stackoverflow.com/questions/10045363/pickling-cv2-keypoint-causes-picklingerror/48832618
    def _pickle_keypoints(point):
        return cv.KeyPoint, (*point.pt, point.size, point.angle,
                             point.response, point.octave, point.class_id)
    copyreg.pickle(cv.KeyPoint().__class__, _pickle_keypoints)


    #Testing
    recompute = True
    create_dirs = True
    MATCH_LIMIT = 250
    matched_images = {}

    features = computeFeatures()

    # matches = computeMatchesMatrix(features, recompute)
    matched_images = computeMatches(features, MATCH_LIMIT, recompute)

    if create_dirs:
        # sortToFoldersMatrix(matches, features, MATCH_LIMIT)
        sortToFolders(matched_images)

if __name__ == '__main__':
    main()
    pass

def unused():
    pass
    # # Cleanup duplicates
    # for i in list(matched_images):
    #     # print(i, matched_images[i])
    #     for j in list(matched_images):
    #         if j in matched_images[i]:
    #             print("del", j)
    #             del matched_images[j]

    # # Redo matching with first image in each cluster to get better accuracy
    # dir2 = os.fsencode("output/")
    # for folder in os.listdir(dir2):
    #     if os.path.exists(dir2 + folder):
    #         file1 = os.listdir(dir2 + folder)[0]
    #         img1name_raw = os.fsdecode(file1)
    #         img1name = os.path.split(img1name_raw)[1]
    #
    #         (kp1, des1) = features[img1name]
    #
    #         for folder2 in os.listdir(dir2):
    #
    #             if folder != folder2 and folder2 != ".DS_Store":
    #                 file2 = os.listdir(dir2 + folder2)[0]
    #                 img2name_raw = os.fsdecode(file2)
    #                 img2name = os.path.split(img2name_raw)[1]
    #
    #                 (kp2, des2) = features[img2name]
    #                 foldername1 = (dir2+folder).decode()
    #                 foldername2 = (dir2+folder2).decode()
    #
    #                 # print("TESTING:", foldername1+"/"+img1name, foldername2+"/"+img2name) #dir+img1name
    #                 match = feature_detector.doMatching(foldername1+"/"+img1name, kp1, des1, foldername2+"/"+img2name, kp2, des2, 10)
    #
    #                 if match is not None:
    #                     # Merge folders
    #
    #                     print("merging folders:", foldername1, foldername2)
    #                     # print(dir2, folder2)
    #                     for img in os.listdir(foldername2):
    #                         # print(img, "output/" + foldername1)
    #                         shutil.move(foldername2 + "/" + img, foldername1)
    #                     shutil.rmtree(foldername2)