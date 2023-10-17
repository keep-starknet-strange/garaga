#!venv/bin/python3
import os
from os import listdir
from os.path import isfile, join
import readline
import argparse
import time

# Create an ArgumentParser object
parser = argparse.ArgumentParser(description="A simple script to demonstrate argparse")

# Define command-line arguments
parser.add_argument("-profile", action="store_true", help="force pprof profile")
parser.add_argument("-pie", action="store_true", help="create PIE object")
parser.add_argument("-proof", action="store_true", help="Run in proof mode")

# Parse the command-line arguments
args = parser.parse_args()

if args.profile:
    print("Profiling is enabled")
else:
    print("Profiling is disabled")


CAIRO_PROGRAMS_FOLDERS = [
    "tests/cairo_programs/",
    "tests/cairo_snark/groth16/",
    "tests/cairo_programs/precompute_bls_sig_constants/",
    "tests/cairo_programs/drand/",
    "tests/cairo_programs/ethereum/",
]
DEP_FOLDERS = ["src/bn254/", "src/bls12_381/"]

CAIRO_PROGRAMS = []
for folder in CAIRO_PROGRAMS_FOLDERS:
    CAIRO_PROGRAMS += [
        join(folder, f)
        for f in listdir(folder)
        if isfile(join(folder, f))
        if f.endswith(".cairo")
    ]
# print(CAIRO_PROGRAMS)

# Get all dependency files
DEP_FILES = []
for dep_folder in DEP_FOLDERS:
    DEP_FILES += [
        join(dep_folder, f)
        for f in listdir(dep_folder)
        if isfile(join(dep_folder, f))
        if f.endswith(".cairo")
    ]
# print(DEP_FILES)


def mkdir_if_not_exists(path: str):
    isExist = os.path.exists(path)
    if not isExist:
        os.makedirs(path)
        print(f"Directory created : {path} ")


mkdir_if_not_exists("build")
mkdir_if_not_exists("build/compiled_cairo_files")
mkdir_if_not_exists("build/profiling")


def complete(text, state):
    volcab = [x.split("/")[-1] for x in CAIRO_PROGRAMS]
    results = [x for x in volcab if x.startswith(text)] + [None]
    return results[state]


readline.parse_and_bind("tab: complete")
readline.set_completer(complete)


def find_file_recurse():
    not_found = True  # Find the full local path for the selected Cairo file
    while not_found:
        global FILENAME_DOT_CAIRO_PATH
        global FILENAME_DOT_CAIRO
        FILENAME_DOT_CAIRO = input(
            "\n>>> Enter .cairo file name to run or double press <TAB> for autocompleted suggestions : \n\n"
        )
        for cairo_path in CAIRO_PROGRAMS:
            if cairo_path.endswith(FILENAME_DOT_CAIRO):
                FILENAME_DOT_CAIRO_PATH = cairo_path
                not_found = False
                break
        if not_found:
            print(
                f"### File '{FILENAME_DOT_CAIRO}' not found in the Cairo programs folders."
            )


find_file_recurse()

print(f"Selected Cairo file: {FILENAME_DOT_CAIRO_PATH}")

FILENAME = FILENAME_DOT_CAIRO.removesuffix(".cairo")

JSON_INPUT_PATH = FILENAME_DOT_CAIRO_PATH.replace(".cairo", "_input.json")

input_exists = os.path.exists(JSON_INPUT_PATH)
if input_exists:
    print(f"Input file found! : {JSON_INPUT_PATH} ")
mkdir_if_not_exists(f"build/profiling/{FILENAME}")

# Combine main and dependency files
ALL_FILES = CAIRO_PROGRAMS + DEP_FILES


compile_success = False
while not compile_success:
    print(f"Compiling {FILENAME_DOT_CAIRO} ... ")

    return_code = os.system(
        f"cairo-compile {FILENAME_DOT_CAIRO_PATH} --proof_mode --output build/compiled_cairo_files/{FILENAME}.json"
    )
    if return_code == 0:
        compile_success = True
    else:
        print(f"### Compilation failed. Please fix the errors and try again.")
        find_file_recurse()


profile_arg = f" --profile_output ./build/profiling/{FILENAME}/profile.pb.gz"
pie_arg = f" --cairo_pie_output ./build/profiling/{FILENAME}/{FILENAME}_pie.zip"
proof_mode_arg = " --proof_mode"
if input_exists:
    print(f"Running {FILENAME_DOT_CAIRO} with input {JSON_INPUT_PATH} ... ")

    cmd = f"cairo-run --program=build/compiled_cairo_files/{FILENAME}.json --program_input={JSON_INPUT_PATH} --layout=small --print_output --print_info"
    if args.profile:
        cmd += profile_arg
    if args.proof:
        cmd += proof_mode_arg
    if args.pie:
        cmd += pie_arg

    t0 = time.time()
    os.system(cmd)
    t1 = time.time()
    print(f"Time elapsed: {t1-t0} seconds")

else:
    print(f"Running {FILENAME_DOT_CAIRO} ... ")

    cmd = f"cairo-run --program=build/compiled_cairo_files/{FILENAME}.json --layout=small --print_info"
    if args.profile:
        cmd += profile_arg
    if args.proof:
        cmd += proof_mode_arg
    if args.pie:
        cmd += pie_arg
    t0 = time.time()
    os.system(cmd)
    t1 = time.time()
    print(f"Time elapsed: {t1-t0} seconds")

if args.profile:
    print(f"Running profiling tool for {FILENAME_DOT_CAIRO} ... ")
    os.system(f"cd ./build/profiling/{FILENAME} && go tool pprof -png profile.pb.gz ")
