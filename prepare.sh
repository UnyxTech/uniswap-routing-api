#!/bin/bash

# Exit on error
set -e

# Get the absolute path of the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Configuration
SMART_ORDER_ROUTER_REPO="https://github.com/UnyxTech/uniswap-smart-order-router.git"
SMART_ORDER_ROUTER_BRANCH="release/v3.16.22"
TEMP_DIR="$SCRIPT_DIR/temp"
LOCAL_DEPS_DIR="$SCRIPT_DIR/deps"
SOR_DIR="$LOCAL_DEPS_DIR/smart-order-router"

# Create necessary directories
mkdir -p "$TEMP_DIR"
mkdir -p "$LOCAL_DEPS_DIR"

# Clone and build smart-order-router
echo "Cloning smart-order-router..."
git clone $SMART_ORDER_ROUTER_REPO "$TEMP_DIR/smart-order-router"
cd "$TEMP_DIR/smart-order-router"
git checkout $SMART_ORDER_ROUTER_BRANCH

# Install dependencies and build
echo "Installing dependencies..."
npm install

# Compile types and build
echo "Building smart-order-router..."
npm run build

# Create local dependency directory
echo "Preparing local dependency..."
mkdir -p "$SOR_DIR"

# Copy necessary files based on package.json "files" field
mkdir -p "$SOR_DIR/build"
cp -r build/main "$SOR_DIR/build/"
cp -r build/module "$SOR_DIR/build/"
cp CHANGELOG.md LICENSE README.md "$SOR_DIR/" 2>/dev/null || true
cp package.json "$SOR_DIR/"

# Clean up
echo "Cleaning up..."
cd "$SCRIPT_DIR"
rm -rf "$TEMP_DIR"

echo "Smart-order-router dependency prepared successfully!"
