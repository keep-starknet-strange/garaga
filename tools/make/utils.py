import os


def create_directory(path: str):
    if not os.path.exists(path):
        os.makedirs(path)
        print(f"Directory created: {path}")


def get_files_from_folders(folders, ext=".cairo"):
    return [
        os.path.join(folder, f)
        for folder in folders
        for f in os.listdir(folder)
        if os.path.isfile(os.path.join(folder, f)) and f.endswith(ext)
    ]
