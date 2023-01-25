import PIL.Image as Image
import numpy as np

if __name__ == "__main__":
    rgb = Image.open("img_rgb.jpg")
    gray = rgb.convert("L")
    grayPixels = []
    xSize, ySize = gray.size
    for x in range(xSize):
        for y in range(ySize):
            grayPixels.append(gray.getpixel((x, y)))
    grayPixels = np.array(grayPixels)
    kx = np.array([[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]])
    ky = np.array([[-1, -2, -1], [0, 0, 0], [1, 2, 1]])
    for ix in range(0, xSize):
        for iy in range(0, ySize):
            kxResult = 0
            kyResult = 0
            for kx in range(-1, 2):
                pass
