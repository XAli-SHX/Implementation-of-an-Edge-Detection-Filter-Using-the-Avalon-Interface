from PIL import Image


def main():
    img = Image.open('img_gray_in.jpg')
    xSize, ySize = img.size
    pixelFile = open('pixel_out.txt', 'w')
    pixelFile.write(str(xSize) + ' ' + str(ySize) + '\n')
    for y in range(ySize):
        for x in range(xSize):
            pixel = img.getpixel((x, y))
            pixelFile.write(bin(pixel).replace("0b", "") + '\n')
    pixelFile.close()


if __name__ == "__main__":
    main()
