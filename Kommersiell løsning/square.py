from squaredetector import SquareDetector
import argparse
import imutils
import cv2 as cv

# python square.py -i/--img level??.py
parser = argparse.ArgumentParser()
parser.add_argument("-i", "--img", required=True,
	help ="python thisfile.extension -i (OR) --img yourimage.extension")
args = vars(parser.parse_args())


# last inn bildet og endre storrelsen til en mindre faktor
# paa den maaten kan vi approksimere formene bedre
image = cv.imread(args["img"])
resized = imutils.resize(image, width=800)
ratio = image.shape[0] / float(resized.shape[0])

# konverter bildet til graaskala og blur det litt
# sett en threshold
gray = cv.cvtColor(resized, cv.COLOR_BGR2GRAY)
blurred = cv.GaussianBlur(gray, (5, 5), 0)
thresh = cv.threshold(blurred, 60, 255,cv.THRESH_BINARY_INV)[1]

# finn konturene i det naa thresholdede bildet og initialiser
# shapetector.py. Samt totalt antall firkanter
cnts = cv.findContours(thresh.copy(), cv.RETR_EXTERNAL,
	cv.CHAIN_APPROX_SIMPLE)
cnts = cnts[0] if imutils.is_cv2() else cnts[1]
sq_detector = SquareDetector()
sq_total = 0

# vi looper over konturene
for c in cnts:
	# regn ut den midtre delen av konturene
	# detekter figuren utifra konturene
	M = cv.moments(c)
	# vil unngaa 0 som verdi i nevneren, programmet krasjer ellers
	if M["m00"] != 0:
		cX = int((M["m10"] / M["m00"]) * ratio)
		cY = int((M["m01"] / M["m00"]) * ratio)
	else:
		cX, cY = 0, 0
	shape = sq_detector.detect(c)

	# multipliser saa konturene (x,y) ko-ordinater med resize ratio
	# vi tegner saa konturene og navnet paa figuren
	c = c.astype("float")
	c *= ratio
	c = c.astype("int")
	cv.drawContours(resized, [c], -1, (0, 255, 0), 2)
	cv.putText(resized, shape, (cX, cY), cv.FONT_HERSHEY_SIMPLEX,
		0.5, (255, 255, 255), 2)

	if shape == "square":
		sq_total += 1

	print("There are a total of "+str(sq_total)+" squares in the image")

	cv.imshow("Image", image)
	cv.waitKey(0)
	if cv.waitKey(10) == ord('q'):
		break