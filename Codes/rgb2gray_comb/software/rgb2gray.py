from PIL import Image

if __name__ == '__main__':
    rgb = Image.open('img_rgb.jpg')
    xSize, ySize = rgb.size
    gray = Image.new('L', (xSize, ySize))
    for x in range(xSize):
        for y in range(ySize):
            r, g, b = rgb.getpixel((x, y))
            grayColor = (r + g + b) / 3
            gray.putpixel((x, y), int(grayColor))
    gray.save('img_gray.jpg')
