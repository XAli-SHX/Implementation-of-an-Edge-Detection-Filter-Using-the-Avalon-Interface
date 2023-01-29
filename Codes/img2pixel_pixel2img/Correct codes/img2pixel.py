from PIL import Image


def main():
    img = Image.open('img_gray_in.jpg')
    xSize, ySize = img.size
    pixelFile = open('input.txt', 'w')
    pixelFile.write(str(xSize) + ' ' + str(ySize) + '\n')
    for x in range(xSize):
        for y in range(ySize):
            pixel = img.getpixel((x, y))
            pixelFile.write(bin(pixel).replace("0b", "") + '\n')
    pixelFile.close()


if __name__ == "__main__":
    main()
