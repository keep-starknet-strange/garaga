#!/bin/bash
cairo_files=$(find ./tests/cairo_programs -name "*.cairo")

for cairo_file in $cairo_files
do
    filename=$(basename $cairo_file .cairo)
    echo "Compiling $cairo_file ..."
    cairo-compile $cairo_file --output "build/$filename.json"
done
