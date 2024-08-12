import os

import pytest


def get_input_json_files(folder, start_with, end_with="_input.json"):
    input_json_files = []
    for file in os.listdir(folder):
        print(file)
        if file.startswith(start_with) and file.endswith(end_with):
            input_json_files.append(os.path.join(folder, file))
    return input_json_files


CAIRO_PROGRAMS_FOLDERS = [
    "tests/fustat_programs/",
]
SPECIAL_CASES = {
    "sample_groth16.cairo": get_input_json_files(
        "tests/fustat_programs/", "sample_groth16"
    ),
    "test_pairing.cairo": get_input_json_files(
        "build/program_inputs/", "test_pairing", ".json"
    ),
}

print(SPECIAL_CASES)
COMPILED_FILES_DIR = "build/compiled_cairo_files"


# Helper function to get all .cairo files
def get_cairo_files():
    cairo_files = []
    for folder in CAIRO_PROGRAMS_FOLDERS:
        for file in os.listdir(folder):
            if file.endswith(".cairo"):
                cairo_files.append(file)
    return cairo_files


# Parametrize test for all .cairo files
@pytest.mark.parametrize("cairo_file", get_cairo_files())
def test_cairo_files(cairo_file):
    filename = cairo_file.removesuffix(".cairo")
    compiled_path = os.path.join(COMPILED_FILES_DIR, f"{filename}.json")

    if not os.path.exists(compiled_path):
        pytest.fail(
            f"Compiled file {compiled_path} not found. Please compile it first."
        )

    if cairo_file in SPECIAL_CASES:
        pytest.skip(f"Skipping {cairo_file} due to special case")
    else:
        json_input_path = os.path.join(
            CAIRO_PROGRAMS_FOLDERS[0], f"{filename}_input.json"
        )
        input_flag = (
            f" --program_input={json_input_path}"
            if os.path.exists(json_input_path)
            else ""
        )

    run_command = f"cairo-run --program={compiled_path} --layout=all_cairo {input_flag} --print_info"

    # Run the command and check if it executes successfully
    assert os.system(run_command) == 0


# Flatten SPECIAL_CASES for parametrization
special_cases_param = [
    (cairo_file, json_input_path)
    for cairo_file, input_files in SPECIAL_CASES.items()
    for json_input_path in input_files
]


@pytest.mark.parametrize("cairo_file, json_input_path", special_cases_param)
def test_special_cases(cairo_file, json_input_path):
    filename = cairo_file.removesuffix(".cairo")
    compiled_path = os.path.join(COMPILED_FILES_DIR, f"{filename}.json")

    run_command = f"cairo-run --program={compiled_path} --layout=all_cairo --program_input={json_input_path} --print_info"
    assert os.system(run_command) == 0
