import sys, os, os.path, shutil

directory = sys.argv[sys.argv.index('--directory') + 1]
pattern = sys.argv[sys.argv.index('--pattern') + 1]

for dirpath, dirnames, filenames in os.walk(directory):
    for dirname in dirnames:
        if dirname.endswith(pattern):
            folderPath = os.path.join(dirpath, dirname)
            print(folderPath)
            shutil.rmtree(folderPath)


