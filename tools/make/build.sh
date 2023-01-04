#!/bin/bash
cairo_files=$(find ./src -name "*.cairo")

for cairo_file in $cairo_files
do
    filename=$(basename $cairo_file .cairo)
    echo "Compiling $cairo_file ..."
    cairo-compile $cairo_file --output "build/compiled_cairo_files/$filename.json"
done

cairo_files=$(find ./tests/cairo_programs -name "*.cairo")

for cairo_file in $cairo_files
do
    filename=$(basename $cairo_file .cairo)
    echo "Compiling $cairo_file ..."
    cairo-compile $cairo_file --output "build/compiled_cairo_files/$filename.json"
done

