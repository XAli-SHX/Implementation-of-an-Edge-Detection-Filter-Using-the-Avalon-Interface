import os
import pyperclip


def main():
    directory = os.getcwd()
    fileList = []
    for root, dirs, files in os.walk(directory):
        for filename in files:
            if root.startswith(".") or filename.startswith(".") or root.startswith("@"):
                continue
            fileList.append(os.path.join(root, filename))
    fileStr = ""
    for file in fileList:
        if file.endswith(".v"):
            fileStr += file + " "
    pyperclip.copy(fileStr.replace("\\", "/"))


if __name__ == "__main__":
    main()
