#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "--------------------------------------------------------------------------------"
echo "Starting Flutter Web Build"
echo "--------------------------------------------------------------------------------"

# Install Flutter
if [ -d "flutter" ]; then
  echo "Flutter directory already exists."
else
  echo "Cloning Flutter stable branch..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

# Add flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Check Flutter version
echo "Checking Flutter version..."
flutter --version

# Enable web support (just in case)
flutter config --enable-web

# Get dependencies
echo "Getting dependencies..."
flutter pub get

# Build web
echo "Building web bundle..."
flutter build web --release

echo "--------------------------------------------------------------------------------"
echo "Build Successful!"
echo "--------------------------------------------------------------------------------"
