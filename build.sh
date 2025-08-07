#!/bin/bash
# build.sh - Builds the cloc-go project and creates a zipped archive

set -e  # Exit on any error

echo "Building cloc-go..."
go mod tidy
mkdir -p bin
go build -o bin/cloc-go ./cmd/cloc
if [ $? -eq 0 ]; then
    echo "Build successful! Binary located at bin/cloc-go"
else
    echo "Build failed!"
    exit 1
fi

echo "Creating zip archive..."
zip bin/cloc-go-v1.0.0.zip bin/cloc-go
if [ $? -eq 0 ]; then
    echo "Zip archive created at bin/cloc-go-v1.0.0.zip"
else
    echo "Zip creation failed!"
    exit 1
fi