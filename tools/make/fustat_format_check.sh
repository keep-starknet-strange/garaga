#!/bin/bash

# Function to check a file formatting and print a message based on the outcome
format_file() {
    cairo-format -c "$1"
    local status=$?
    if [ $status -eq 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - File $1 is formatted correctly"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - File $1 is not formatted correctly"
        return $status
    fi
}

# Export the function so it's available in subshells
export -f format_file

# Find all .cairo files under src/ and tests/ directories and format them in parallel
# Using --halt soon,fail=1 to stop at the first failure
find ./src/fustat ./tests/fustat_programs -name '*.cairo' | parallel --halt soon,fail=1 format_file

# Capture the exit status of parallel
exit_status=$?

# Exit with the captured status
echo "Parallel execution exited with status: $exit_status"
exit $exit_status
