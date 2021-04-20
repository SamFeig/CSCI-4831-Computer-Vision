import copyreg
import os
import pickle
import shutil

import cv2 as cv
import numpy as np
from matplotlib import pyplot as plt


# Function to pickle cv.KeyPoint from:
# https://stackoverflow.com/questions/10045363/pickling-cv2-keypoint-causes-picklingerror/48832618
def _pickle_keypoints(point):
    return cv.KeyPoint, (*point.pt, point.size, point.angle,
                         point.response, point.octave, point.class_id)


copyreg.pickle(cv.KeyPoint().__class__, _pickle_keypoints)


# Compute features and descriptors using the SIFT algorithm
# Works better than ORB (more features detected), but is slower
def doSIFT(img):
    gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
    sift = cv.SIFT_create()
    kp, des = sift.detectAndCompute(gray, None)

    # img2 = cv.drawKeypoints(gray, kp, img, flags=cv.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS)
    # cv.imshow('SIFT', img2)
    # plt.imshow(img2), plt.show()
    # cv.waitKey()
    return kp, des


# Compute features and descriptors using the ORB algorithm
def doORB(img):
    # Initiate ORB detector
    orb = cv.ORB_create()
    # find the keypoints with ORB
    kp = orb.detect(img, None)
    # compute the descriptors with ORB
    kp, des = orb.compute(img, kp)
    # draw only keypoints location,not size and orientation
    # img2 = cv.drawKeypoints(img, kp, None, color=(0, 255, 0), flags=cv.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS)
    # cv.imshow('ORB', img2)
    # plt.imshow(img2), plt.show()
    # cv.waitKey()
    return kp, des


# Load all images and detect features
def compute_features(photos_dir, photos=None, recompute=True):
    features = {}

    # Do not recompute feature data if asked to load it instead
    if recompute:
        i = 0
        # If given list of files, use only those files, otherwise use entire directory
        if photos is not None and len(photos) != 0:
            num = len(photos)
            # Handle removal of hidden files
            if any(photo.startswith('.') for photo in photos):
                num = num - 1
            # Loop through all photos and detect features on them
            for filename in photos:
                if not filename.startswith('.'):
                    img1 = cv.imread(os.path.join(photos_dir, filename))
                    kp1, des1 = doSIFT(img1)
                    des1 = np.float32(des1)
                    features[filename] = (kp1, des1)
                    i += 1
                    print("Processed file %d of %d" % (i, num))
        else:
            num = len([f for f in os.listdir(photos_dir) if not f.startswith('.')])
            # Loop through all photos and detect features on them
            for file in os.listdir(os.fsencode(photos_dir)):
                # Ignore hidden files
                if not file.startswith(b'.'):
                    filename = os.fsdecode(file)
                    img1 = cv.imread(os.path.join(photos_dir, filename))
                    kp1, des1 = doSIFT(img1)
                    des1 = np.float32(des1)
                    features[filename] = (kp1, des1)
                    i += 1
                    print("Processed file %d of %d" % (i, num))
        print("Done detecting features!")

        # Save data when done
        with open('features.pickle', 'wb') as handle:
            pickle.dump(features, handle, protocol=pickle.HIGHEST_PROTOCOL)
        print("Data saved to file: \'features.pickle\'")
    else:
        # Load data from file
        with open('features.pickle', 'rb') as handle:
            features = pickle.load(handle)
        print("Data loaded from file: \'features.pickle\'")
    return features


# Attempt to match two images to each other using the descriptors from the features
def doMatching(file1, kp1, des1, file2, kp2, des2, min_match_count):
    FLANN_INDEX_KDTREE = 1

    # Match using FLANN (Fast Library for Approximate Nearest Neighbors) and kNN with k=2
    index_params = dict(algorithm=FLANN_INDEX_KDTREE, trees=5)
    search_params = dict(checks=50)
    flann = cv.FlannBasedMatcher(index_params, search_params)
    matches = flann.knnMatch(des1, des2, k=2)

    # Filter matches with ratio test
    good = []
    for m, n in matches:
        if m.distance < 0.7 * n.distance:
            good.append(m)
    # print(file1, file2, len(good))
    # print("{}/{}".format(len(good), min_match_count))
    if len(good) > min_match_count:
        # print("*****" + os.path.split(file1)[1] + " matched " + os.path.split(file2)[1])
        return (file1, file2), len(good)
    # print("No match: " + os.path.split(file1)[1] + " , " + os.path.split(file2)[1])
    return None, len(good)


# Attempt to match two images to each other using the descriptors from the features
# Same as doMatching, but without the min_match_count thresholding
def doMatchingMatrix(file1, kp1, des1, file2, kp2, des2):
    FLANN_INDEX_KDTREE = 1

    # Match using FLANN (Fast Library for Approximate Nearest Neighbors) and kNN with k=2
    index_params = dict(algorithm=FLANN_INDEX_KDTREE, trees=5)
    search_params = dict(checks=50)
    flann = cv.FlannBasedMatcher(index_params, search_params)
    matches = flann.knnMatch(des1, des2, k=2)

    # Filter matches with ratio test
    good = []
    for m, n in matches:
        if m.distance < 0.7 * n.distance:
            good.append(m)

    return (file1, file2), len(good)


# Attempt to match two images to each other using the descriptors from the features
# Also display the Homography and feature match lines on the image
def doMatching_with_display(file1, kp1, des1, file2, kp2, des2, min_match_count):
    FLANN_INDEX_KDTREE = 1

    img1 = cv.imread(file1)
    img2 = cv.imread(file2)

    # Match using FLANN (Fast Library for Approximate Nearest Neighbors) and kNN with k=2
    index_params = dict(algorithm=FLANN_INDEX_KDTREE, trees=5)
    search_params = dict(checks=50)
    flann = cv.FlannBasedMatcher(index_params, search_params)
    matches = flann.knnMatch(des1, des2, k=2)

    # Filter matches with ratio test
    good = []
    for m, n in matches:
        if m.distance < 0.7 * n.distance:
            good.append(m)

    print("{}/{}".format(len(good), min_match_count))
    # Check that matches meet minimum threshold
    if len(good) > min_match_count:
        # Calculate values for homography and perspective transforms
        src = np.float32([kp1[m.queryIdx].pt for m in good]).reshape(-1, 1, 2)
        dst = np.float32([kp2[m.trainIdx].pt for m in good]).reshape(-1, 1, 2)
        # Use RANSAC to do Homography mapping
        M, mask = cv.findHomography(src, dst, cv.RANSAC, 5.0)
        matchesMask = mask.ravel().tolist()
        h, w, d = img1.shape
        # Get corners of the image
        pts = np.float32([[0, 0], [0, h - 1], [w - 1, h - 1], [w - 1, 0]]).reshape(-1, 1, 2)
        try:
            # If Homography is valid, do the perspective transform, otherwise ignore it
            valid = M.shape == (3, 3)
            dst = cv.perspectiveTransform(pts, M)
            img2 = cv.polylines(img2, [np.int32(dst)], True, 255, 3, cv.LINE_AA)
        except Exception as e:
            print("Cant generate Homography, not enough points", e)

        # Draw matches and display image for testing
        draw_params = dict(matchColor=(0, 255, 0), #Green lines for matches
                           singlePointColor=None,
                           matchesMask=matchesMask, #Inliers only
                           flags=2)
        img3 = cv.drawMatches(img1, kp1, img2, kp2, good, None, **draw_params)
        plt.imshow(img3, 'gray'), plt.show()
        print("*****" + os.path.split(file1)[1] + " matched " + os.path.split(file2)[1])
        return (file1, file2), len(good)
    else:
        print("No match: " + os.path.split(file1)[1] + " , " + os.path.split(file2)[1])
        return None, len(good)


# Compute matches on all images
# Faster than matrix version as it optimizes to only match each image to one other, but matches must be
# Recomputed if the match_limit is changed
def compute_matches(features, match_limit, photos_dir, recompute=True):
    seen = {}
    matched_images = {}

    # Do not recompute match data if asked to load it instead
    if recompute:
        # Loop through all files that have features, ignoring ones that have already been seen/computed
        for file1 in features:
            if file1 not in seen.keys():
                matched_images[file1] = []

                (kp1, des1) = features[file1]
                # Get second image to attempt to map to, ignoring ones that have already been seen/computed
                for file2 in features:
                    if file2 not in seen.keys() and file1 != file2:
                        (kp2, des2) = features[file2]
                        # match, match_count = doMatching_with_display(os.path.join(photos_dir,file1),
                        #                                                               kp1, des1,
                        #                                                               os.path.join(photos_dir,file2),
                        #                                                               kp2, des2, match_limit)
                        match, match_count = doMatching(os.path.join(photos_dir, file1), kp1, des1,
                                                        os.path.join(photos_dir, file2), kp2, des2,
                                                        match_limit)
                        # If doMatching returned a valid match above match_limit,
                        # then mark both files as seen and add it to the match list for file1
                        if match is not None:
                            print("****Matched:", (os.path.split(match[0])[1], os.path.split(match[1])[1]), match_count)
                            seen[file2] = 1
                            seen[file1] = 1
                            matched_images[file1].append(file2)
        print("Done computing matches")
        # Save data when done
        with open('matches.pickle', 'wb') as handle:
            pickle.dump(matched_images, handle, protocol=pickle.HIGHEST_PROTOCOL)
        print("Data saved to file: \'matches.pickle\'")
    else:
        # Load data from file
        with open('matches.pickle', 'rb') as handle:
            matched_images = pickle.load(handle)
        print("Data loaded from file: \'matches.pickle\'")
    return matched_images


# Compute matches on all images
# Store the results in a upper triangular matrix allowing for the matching threshold to be adjusted without
# The need to recompute the matches, but is must slower than non matrix version
def compute_matches_matrix(features, photos_dir, recompute=True):
    n = len(features)
    # Store number of matches between all image pairs, diag is inf as each image is the same as itself
    matches = np.zeros(shape=(n, n))
    np.fill_diagonal(matches, np.inf)

    keys = list(features.keys())
    seen = {}
    # Do not recompute match data if asked to load it instead
    if recompute:
        # Loop through all files that have features, ignoring ones that have already been seen/computed
        for file1 in features:
            if file1 not in seen.keys():
                # Get second image to attempt to map to, ignoring ones that have already been seen/computed
                for file2 in features:
                    # Only do upper triangular matrix calculations as others are unnecessary
                    if file2 not in seen.keys() and file1 != file2:
                        (kp1, des1) = features[file1]
                        (kp2, des2) = features[file2]

                        (img1, img2), match_count = doMatchingMatrix(os.path.join(photos_dir, file1), kp1, des1,
                                                                     os.path.join(photos_dir, file2),
                                                                     kp2, des2)
                        print((os.path.split(img1)[1], os.path.split(img2)[1]), match_count)
                        idx1 = keys.index(os.path.split(img1)[1])
                        idx2 = keys.index(os.path.split(img2)[1])
                        # Add returned match_cout to the matrix at the index of those two images
                        matches[idx1][idx2] = match_count
                    # Mark file1 as seen only after running it against all other potential valid images
                    seen[file1] = 1
        print("Done computing matches")
        # Save data when done
        with open('matches_matrix.pickle', 'wb') as handle:
            pickle.dump(matches, handle, protocol=pickle.HIGHEST_PROTOCOL)
        print("Data saved to file: \'matches_matrix.pickle\'")
    else:
        # Load data from file
        with open('matches_matrix.pickle', 'rb') as handle:
            matches = pickle.load(handle)
    return matches


# Sort images into folders
def write_output(matched_images, photos_dir, out_dir):
    # Remove output directory if it exists and remake the folder
    try:
        if os.path.exists(out_dir):
            shutil.rmtree(out_dir)
        os.mkdir(out_dir)
    except Exception as e:
        print(e)

    try:
        # Create a folder for each image that was matched to and move that image to its folder
        for img in matched_images:
            out_dir1 = os.path.join(out_dir, img[:-4])
            os.mkdir(out_dir1)

            shutil.copy(os.path.join(photos_dir, img), out_dir1)

            # Add all images that were matching to that folder
            for img2 in matched_images[img]:
                out_dir2 = os.path.join(out_dir1, img2)
                shutil.copy(os.path.join(photos_dir, img2), out_dir2)
    except Exception as e:
        print("Unable to copy file.", e)


# Sort images into folders from matrix
def write_output_matrix(matches, features, match_limit, photos_dir, out_dir):
    keys = list(features.keys())
    # Remove output directory if it exists and remake the folder
    try:
        if os.path.exists(out_dir):
            shutil.rmtree(out_dir)
        os.mkdir(out_dir)
    except Exception as e:
        print(e)

    try:
        # Filter the matrix to get a list of locations that are greater than the minimum match_limit
        locs = np.argwhere((matches > match_limit))  # & (matches != np.inf))
        seen = {}
        # Iterate through all matching locations
        for loc in locs:
            img1 = keys[loc[0]]
            img2 = keys[loc[1]]
            # print(loc[0], img1, loc[1], img2)

            # Create a folder for each image that was matched to and move that image to its folder
            # Marking it as seen so as not to recreate folders
            if img1 not in seen:
                out_dir = os.path.join(out_dir, img1[:-4])
                os.mkdir(out_dir)
                shutil.copy(os.path.join(photos_dir, img1), out_dir)
                seen[img1] = 1

            # Add second image that was matched to it to the folder and mark as seen when done
            if img2 not in seen:
                out_dir = os.path.join(out_dir, img1[:-4])
                shutil.copy(os.path.join(photos_dir, img2), out_dir)
                seen[img2] = 1
    except Exception as e:
        print("Unable to copy file.", e)


if __name__ == '__main__':
    recompute_feat = True
    recompute = True
    match_limit = 400

    features = compute_features('PhotoSorter_images', None, recompute_feat)
    matched_images = compute_matches(features, match_limit, 'PhotoSorter_images', recompute)
    write_output(matched_images, 'PhotoSorter_images', 'output')

    # IF MATRIX USE THESE
    # matches = feature_detector.compute_matches_matrix(features, recompute)
    # feature_detector.write_output_matrix(matches, features, match_limit)

# UNNEEDED BUT POTENTIALLY USEFUL
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
#                 match = feature_detector.doMatching(foldername1+"/"+img1name, kp1, des1, foldername2+"/"+img2name,
#                                                       kp2, des2, 10)
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
