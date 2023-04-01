#!venv/bin/python3
import os
from os import listdir
from os.path import isfile, join
import readline
import blake3
import json
from tinydb import TinyDB, Query
import subprocess

CAIRO_PROGRAMS_FOLDERS = ["tests/cairo_programs/", "tests/cairo_snark/groth16/"]
DEP_FOLDERS = ["src/bn254/", "src"]

CAIRO_PROGRAMS = []
for folder in CAIRO_PROGRAMS_FOLDERS:
    CAIRO_PROGRAMS+= [join(folder, f) for f in listdir(folder) if isfile(join(folder, f)) if f.endswith('.cairo')]
print(CAIRO_PROGRAMS)

# Get all dependency files
DEP_FILES = []
for dep_folder in DEP_FOLDERS:
    DEP_FILES += [join(dep_folder, f) for f in listdir(dep_folder) if isfile(join(dep_folder, f)) if f.endswith('.cairo')]
print(DEP_FILES)

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

FILENAME_DOT_CAIRO = input('\n>>> Enter cairo program to run or double press for suggestions <TAB> : \n\n')

# Find the full local path for the selected Cairo file
for cairo_path in CAIRO_PROGRAMS:
    if cairo_path.endswith(FILENAME_DOT_CAIRO):
        FILENAME_DOT_CAIRO_PATH = cairo_path
        break
else:
    raise FileNotFoundError(f"File {FILENAME_DOT_CAIRO} not found in the Cairo programs folders.")

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

if did_some_file_changed() or os.path.exists(f"build/compiled_cairo_files/{FILENAME}.json")==False:
    print(f"Compiling {FILENAME_DOT_CAIRO} because some files have changed ... ")

    os.system(f"cairo-compile {FILENAME_DOT_CAIRO_PATH} --output build/compiled_cairo_files/{FILENAME}.json")
else:
    print(f"Skipping compilation for {FILENAME_DOT_CAIRO} since no file has changed.")


new_hash = get_hash_if_file_exists(f"build/compiled_cairo_files/{FILENAME}.json")
if input_exists:
    print(f"Running {FILENAME_DOT_CAIRO} with input {JSON_INPUT_PATH} ... ")
    profile_arg = " --profile_output ./build/profiling/{FILENAME}/profile.pb.gz"
    pie_arg = " --cairo_pie_output ./build/profiling/{FILENAME}/{FILENAME}_pie.zip"
    cmd=f"cairo-run --program=build/compiled_cairo_files/{FILENAME}.json --program_input={JSON_INPUT_PATH} --print_info --layout=starknet_with_keccak --print_output"
    # cmd+=profile_arg+pie_arg
    # process = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.STDOUT,shell=True,text=True)
    os.system(cmd)
    # print(f"Running profiling tool for {FILENAME_DOT_CAIRO} because the compiled file has changed ... ")
    # os.system(f"cd ./build/profiling/{FILENAME} && go tool pprof -png profile.pb.gz ")
else:
    print(f"Running {FILENAME_DOT_CAIRO} ... ")
    cmd=f"cairo-run --program=build/compiled_cairo_files/{FILENAME}.json --layout=starknet_with_keccak --print_output --profile_output ./build/profiling/{FILENAME}/profile.pb.gz --cairo_pie_output ./build/profiling/{FILENAME}/{FILENAME}_pie.zip"
    # process = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.STDOUT,shell=True,text=True)
    os.system(cmd)




