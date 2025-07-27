#!/bin/bash

SCRIPT_DIR=$(dirname $(realpath "$0"))

# Remove the dist folder if it exists
rm -rvf "$SCRIPT_DIR/../dist"

# Run PyInstaller with the standalone specification file
pyinstaller "$SCRIPT_DIR/standalone.spec"

# Copy README.txt to dist/SweetDreams directory
cp "$SCRIPT_DIR/README.txt" "$SCRIPT_DIR/../dist/SweetDreams"

# Clean up by removing the build folder
rm -rvf "$SCRIPT_DIR/../build"

# Zip the result
originalDir=$(pwd)
cd "$SCRIPT_DIR/../dist/SweetDreams"
zip -r -9 "SweetDreams-vX.X.X-linux.zip" "."
cd "$originalDir"