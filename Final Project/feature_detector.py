import os

import numpy as np
import cv2 as cv
from matplotlib import pyplot as plt


def doSIFT(img):
    gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
    sift = cv.SIFT_create()
    kp, des = sift.detectAndCompute(gray, None)

    # img2 = cv.drawKeypoints(gray, kp, img, flags=cv.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS)
    # cv.imshow('SIFT', img2)
    # plt.imshow(img2), plt.show()
    # cv.waitKey()
    return kp, des


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


def doMatching(file1, kp1, des1, file2, kp2, des2, min_match_count):
    FLANN_INDEX_KDTREE = 1

    # img1 = cv.imread(file1)
    # img2 = cv.imread(file2)

    index_params = dict(algorithm=FLANN_INDEX_KDTREE, trees=5)
    search_params = dict(checks=50)
    flann = cv.FlannBasedMatcher(index_params, search_params)
    matches = flann.knnMatch(des1, des2, k=2)

    # store all the good matches as per Lowe's ratio test.
    good = []
    for m, n in matches:
        if m.distance < 0.7 * n.distance:
            good.append(m)
    # print(file1, file2, len(good))
    if len(good) > min_match_count:
        return (file1, file2), len(good)
    return None, len(good)
    # # print("{}/{}".format(len(good), min_match_count))
    # if len(good) > min_match_count:
    #     # print("*****" + os.path.split(file1)[1] + " matched " + os.path.split(file2)[1])
    #     return file2, len(good)
    # else:
    #     # print("No match: " + os.path.split(file1)[1] + " , " + os.path.split(file2)[1])
    #     return None, len(good)


def doMatchingMatrix(file1, kp1, des1, file2, kp2, des2):
    FLANN_INDEX_KDTREE = 1

    # img1 = cv.imread(file1)
    # img2 = cv.imread(file2)

    index_params = dict(algorithm=FLANN_INDEX_KDTREE, trees=5)
    search_params = dict(checks=50)
    flann = cv.FlannBasedMatcher(index_params, search_params)
    matches = flann.knnMatch(des1, des2, k=2)

    # store all the good matches as per Lowe's ratio test.
    good = []
    for m, n in matches:
        if m.distance < 0.7 * n.distance:
            good.append(m)
    # print(file1, file2, len(good))
    return (file1, file2), len(good)
    # # print("{}/{}".format(len(good), min_match_count))
    # if len(good) > min_match_count:
    #     # print("*****" + os.path.split(file1)[1] + " matched " + os.path.split(file2)[1])
    #     return file2, len(good)
    # else:
    #     # print("No match: " + os.path.split(file1)[1] + " , " + os.path.split(file2)[1])
    #     return None, len(good)


def doMatching_with_display(file1, kp1, des1, file2, kp2, des2, min_match_count):
    FLANN_INDEX_KDTREE = 1

    img1 = cv.imread(file1)
    img2 = cv.imread(file2)

    index_params = dict(algorithm=FLANN_INDEX_KDTREE, trees=5)
    search_params = dict(checks=50)
    flann = cv.FlannBasedMatcher(index_params, search_params)
    matches = flann.knnMatch(des1, des2, k=2)

    # store all the good matches as per Lowe's ratio test.
    good = []
    for m, n in matches:
        if m.distance < 0.7 * n.distance:
            good.append(m)

    print("{}/{}".format(len(good), min_match_count))
    if len(good) > min_match_count:
        src_pts = np.float32([kp1[m.queryIdx].pt for m in good]).reshape(-1, 1, 2)
        dst_pts = np.float32([kp2[m.trainIdx].pt for m in good]).reshape(-1, 1, 2)
        M, mask = cv.findHomography(src_pts, dst_pts, cv.RANSAC, 5.0)
        matchesMask = mask.ravel().tolist()
        h, w, d = img1.shape
        pts = np.float32([[0, 0], [0, h - 1], [w - 1, h - 1], [w - 1, 0]]).reshape(-1, 1, 2)
        try:
            valid = M.shape == (3, 3)
            dst = cv.perspectiveTransform(pts, M)
            img2 = cv.polylines(img2, [np.int32(dst)], True, 255, 3, cv.LINE_AA)
        except Exception as e:
            print("Cant generate Homography, not enough points", e)

        draw_params = dict(matchColor=(0, 255, 0),  # draw matches in green color
                           singlePointColor=None,
                           matchesMask=matchesMask,  # draw only inliers
                           flags=2)
        img3 = cv.drawMatches(img1, kp1, img2, kp2, good, None, **draw_params)
        plt.imshow(img3, 'gray'), plt.show()
        print("*****" + os.path.split(file1)[1] + " matched " + os.path.split(file2)[1])
        return file2, len(good)
    else:
        print("No match: " + os.path.split(file1)[1] + " , " + os.path.split(file2)[1])
        return None, len(good)