#!venv/bin/python3
import os
from os import listdir
from os.path import isfile, join
import readline
import blake3
import json
from tinydb import TinyDB, Query
import subprocess
import argparse

# Create an ArgumentParser object
parser = argparse.ArgumentParser(description="A simple script to demonstrate argparse")

# Define command-line arguments
parser.add_argument("-profile", action="store_true", help="force pprof profile")
parser.add_argument("-pie", action="store_true", help="create PIE object")

# Parse the command-line arguments
args = parser.parse_args()

if args.profile:
    print("Profiling is enabled")
else:
    print("Profiling is disabled")



CAIRO_PROGRAMS_FOLDERS = ["tests/cairo_programs/", "tests/cairo_snark/groth16/"]
DEP_FOLDERS = ["src/bn254/", "src"]

CAIRO_PROGRAMS = []
for folder in CAIRO_PROGRAMS_FOLDERS:
    CAIRO_PROGRAMS+= [join(folder, f) for f in listdir(folder) if isfile(join(folder, f)) if f.endswith('.cairo')]
# print(CAIRO_PROGRAMS)

# Get all dependency files
DEP_FILES = []
for dep_folder in DEP_FOLDERS:
    DEP_FILES += [join(dep_folder, f) for f in listdir(dep_folder) if isfile(join(dep_folder, f)) if f.endswith('.cairo')]
# print(DEP_FILES)

def get_hash_if_file_exists(file_path: str) -> str:
    isExist = os.path.exists(file_path)
    if isExist == False:
        return None
    else:
        json_bytes = open(file_path, "rb")
        bytes = json_bytes.read()
        hash = blake3.blake3(bytes).digest()
        return str(hash)

def mkdir_if_not_exists(path: str):
    isExist = os.path.exists(path)
    if not isExist:
        os.makedirs(path)
        print(f"Directory created : {path} ")

mkdir_if_not_exists("build")
mkdir_if_not_exists("build/compiled_cairo_files")
mkdir_if_not_exists("build/profiling")

def complete(text, state):
    volcab = [x.split('/')[-1] for x in CAIRO_PROGRAMS]
    results = [x for x in volcab if x.startswith(text)] + [None]
    return results[state]

readline.parse_and_bind("tab: complete")
readline.set_completer(complete)


def find_file_recurse():
    not_found=True# Find the full local path for the selected Cairo file
    while not_found:
        global FILENAME_DOT_CAIRO_PATH
        global FILENAME_DOT_CAIRO
        FILENAME_DOT_CAIRO = input('\n>>> Enter .cairo file name to run or double press <TAB> for autocompleted suggestions : \n\n')
        for cairo_path in CAIRO_PROGRAMS:
            if cairo_path.endswith(FILENAME_DOT_CAIRO):
                FILENAME_DOT_CAIRO_PATH = cairo_path
                not_found=False
                break
        if not_found:
            print(f"### File '{FILENAME_DOT_CAIRO}' not found in the Cairo programs folders.")


find_file_recurse()

print(f"Selected Cairo file: {FILENAME_DOT_CAIRO_PATH}")

FILENAME = FILENAME_DOT_CAIRO.removesuffix('.cairo')

JSON_INPUT_PATH = FILENAME_DOT_CAIRO_PATH.replace('.cairo', '_input.json')

input_exists = os.path.exists(JSON_INPUT_PATH)

mkdir_if_not_exists(f"build/profiling/{FILENAME}")

# Combine main and dependency files
ALL_FILES = CAIRO_PROGRAMS + DEP_FILES

def write_all_hash(db:TinyDB):
    for FILE in ALL_FILES:
        db.insert({'name':FILE, 'hash':get_hash_if_file_exists(FILE)})

def get_all_hash():
    r = []
    for FILE in ALL_FILES:
        r.append(get_hash_if_file_exists(FILE))
    return r 


db = TinyDB(f"build/programs_hash.json")

if len(db)!=(len(ALL_FILES)):
    db.remove(Query().name!=0)
    write_all_hash(db)

hash_table = db.all()
current_hash_table = get_all_hash()


def did_some_file_changed():
    for f,h in zip(hash_table,current_hash_table):
        # print(f, h )
        if f["hash"]!=h:
            return True
    return False

prev_hash = get_hash_if_file_exists(f"build/compiled_cairo_files/{FILENAME}.json")

compile_success = False
while not compile_success:

    print(f"Compiling {FILENAME_DOT_CAIRO} ... ")

    return_code=os.system(f"cairo-compile {FILENAME_DOT_CAIRO_PATH} --output build/compiled_cairo_files/{FILENAME}.json")
    if return_code==0:
        compile_success=True
    else:
        print(f"### Compilation failed. Please fix the errors and try again.")
        find_file_recurse()




new_hash = get_hash_if_file_exists(f"build/compiled_cairo_files/{FILENAME}.json")
profile_arg = f" --profile_output ./build/profiling/{FILENAME}/profile.pb.gz"
pie_arg = f" --cairo_pie_output ./build/profiling/{FILENAME}/{FILENAME}_pie.zip"
if input_exists:
    print(f"Running {FILENAME_DOT_CAIRO} with input {JSON_INPUT_PATH} ... ")

    cmd=f"cairo-run --program=build/compiled_cairo_files/{FILENAME}.json --program_input={JSON_INPUT_PATH} --layout=starknet_with_keccak --print_output"
    if args.profile:
        cmd+=profile_arg
    else:
        cmd+=" --print_info"
    if args.pie:
        cmd+=pie_arg

    os.system(cmd)

else:
    print(f"Running {FILENAME_DOT_CAIRO} ... ")

    cmd=f"cairo-run --program=build/compiled_cairo_files/{FILENAME}.json --layout=starknet_with_keccak"
    if args.profile:
        cmd+=profile_arg
    else:
        cmd+=" --print_info"
    if args.pie:
        cmd+=pie_arg

    os.system(cmd)


if args.profile:
    print(f"Running profiling tool for {FILENAME_DOT_CAIRO} ... ")
    os.system(f"cd ./build/profiling/{FILENAME} && go tool pprof -png profile.pb.gz ")



