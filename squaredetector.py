import cv2 as cv

class SquareDetector:
	def __init__(self):
		pass

	def detect(self, c):
		# initialiserer form variabler og approksimerer
		# konturene
		shape = "unidentified"
		peri = cv.arcLength(c, True)
		approx = cv.approxPolyDP(c, 0.04 * peri, True)

		if len(approx) == 4:
			(x, y, w, h) = cv.boundingRect(approx)
			ar = w / float(h)
			shape = "square" if ar >= 0.95 and ar <= 1.05 else "unidentified"

		return shape
