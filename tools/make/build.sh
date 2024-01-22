#!/bin/bash

process_cairo_file() {
    local cairo_file="$1"
    local filename=$(basename "$cairo_file" .cairo)
    local first_line=$(head -n 1 "$cairo_file")

    if [[ "$first_line" == "%lang starknet" ]]; then
        echo "Compiling $cairo_file using starknet-compile ..."
        starknet-compile "$cairo_file" --output "build/compiled_cairo_files/$filename.json" --abi "build/compiled_cairo_files/$filename_abi.json"
    else
        echo "Compiling $cairo_file using cairo-compile ..."
        cairo-compile "$cairo_file" --output "build/compiled_cairo_files/$filename.json"
    fi
}

export -f process_cairo_file

find ./src ./tests/cairo_programs -name "*.cairo" | parallel process_cairo_file
