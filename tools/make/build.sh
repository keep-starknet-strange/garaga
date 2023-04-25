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

cairo_files=$(find ./src -name "*.cairo")

for cairo_file in $cairo_files
do
    process_cairo_file "$cairo_file"
done

cairo_files=$(find ./tests/cairo_programs -name "*.cairo")

for cairo_file in $cairo_files
do
    process_cairo_file "$cairo_file"
done