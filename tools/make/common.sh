#!/bin/bash

# Function to check for 'act' or 'gh act' and execute the appropriate command
run_ci_workflow() {
    local workflow_file=$1

    if command -v act &> /dev/null
    then
        act -W $workflow_file --secret-file .secrets
    elif command -v gh &> /dev/null && gh act --version &> /dev/null
    then
        gh act -W $workflow_file --secret-file .secrets
    else
        echo "Error: Neither 'act' nor 'gh act' command found. Please install one of them to proceed."
        exit 1
    fi
}
