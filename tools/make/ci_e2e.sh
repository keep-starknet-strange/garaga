#!/bin/bash

if command -v act &> /dev/null
then
    act -W .github/workflows/e2e.yml --secret-file .secrets
elif command -v gh &> /dev/null && gh act --version &> /dev/null
then
    gh act -W .github/workflows/e2e.yml --secret-file .secrets
else
    echo "Error: Neither 'act' nor 'gh act' command found. Please install one of them to proceed."
    exit 1
fi
