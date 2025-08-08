#!/bin/bash
# Script to build and install libavif for ImageOptim

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DEPS_DIR="$PROJECT_DIR/Dependencies"
LIBAVIF_DIR="$DEPS_DIR/libavif"

echo "Installing libavif dependencies..."

# Create dependencies directory
mkdir -p "$DEPS_DIR"
cd "$DEPS_DIR"

# Check if we already have libavif
if [ -d "$LIBAVIF_DIR" ] && [ -f "$LIBAVIF_DIR/build/libavif.a" ]; then
    echo "libavif already installed"
    exit 0
fi

# Install dependencies via Homebrew if available
if command -v brew >/dev/null 2>&1; then
    echo "Installing dependencies via Homebrew..."
    brew install cmake nasm dav1d aom
else
    echo "Homebrew not found. Please install cmake, nasm, dav1d, and aom manually."
    exit 1
fi

# Clone libavif
if [ ! -d "$LIBAVIF_DIR" ]; then
    echo "Cloning libavif..."
    git clone --depth 1 --branch v1.0.3 https://github.com/AOMediaCodec/libavif.git "$LIBAVIF_DIR"
fi

cd "$LIBAVIF_DIR"

# Create build directory
mkdir -p build
cd build

# Configure with CMake
echo "Configuring libavif build..."
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=OFF \
    -DAVIF_CODEC_DAV1D=ON \
    -DAVIF_CODEC_AOM=ON \
    -DAVIF_BUILD_APPS=OFF \
    -DAVIF_BUILD_TESTS=OFF \
    -DAVIF_BUILD_EXAMPLES=OFF \
    -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15

# Build
echo "Building libavif..."
make -j$(sysctl -n hw.ncpu)

echo "libavif build completed successfully!"
echo "Static library location: $LIBAVIF_DIR/build/libavif.a"
echo "Headers location: $LIBAVIF_DIR/include/"