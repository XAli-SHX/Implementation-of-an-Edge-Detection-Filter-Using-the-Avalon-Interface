from PIL import Image


def main():
    pixelFile = open('pixel_in.txt', 'r')
    pixelLines = pixelFile.readlines()
    pixelFile.close()
    xSize, ySize = pixelLines.pop(0).split()
    xSize = int(xSize)
    ySize = int(ySize)
    img = Image.new('L', (xSize, ySize))
    for x in range(xSize):
        for y in range(ySize):
            img.putpixel((x, y), int(pixelLines[y * xSize + x], 2))
    img.save('img_out.png')


if __name__ == "__main__":
    main()
