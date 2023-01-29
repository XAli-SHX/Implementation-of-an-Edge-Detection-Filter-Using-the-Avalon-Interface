import PIL.Image as Image
import numpy as np

if __name__ == "__main__":
    rgb = Image.open("img_rgb.jpg")
    gray = rgb.convert("L")
    xSize, ySize = gray.size
    kx = np.array([[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]])
    ky = np.array([[1, 2, 1], [0, 0, 0], [-1, -2, -1]])
    edge = []
    for ix in range(xSize):
        row = []
        for iy in range(ySize):
            kxResult = 0
            kyResult = 0
            for i in range(3):
                for j in range(3):
                    if ix + 2 >= xSize or iy + 2 >= ySize:
                        continue
                    kxResult += kx[i][j] * gray.getpixel((ix + i, iy + j))
                    kyResult += ky[i][j] * gray.getpixel((ix + i, iy + j))
            row.append((abs(kxResult) + abs(kyResult)) / 2)
        edge.append(row)
    edgeImage = Image.new("L", (xSize, ySize))
    for x in range(xSize):
        for y in range(ySize):
            edgeImage.putpixel((x, y), int(edge[x][y]))
    edgeImage.save("img_edge.jpg")
    edgeImage.show()
