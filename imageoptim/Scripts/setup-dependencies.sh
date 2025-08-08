#!/bin/bash
# Setup script for ImageOptim Enhanced dependencies

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "Setting up ImageOptim Enhanced dependencies..."

# Install CocoaPods if not present
if ! command -v pod >/dev/null 2>&1; then
    echo "Installing CocoaPods..."
    sudo gem install cocoapods
fi

# Install WebP via CocoaPods
echo "Installing WebP via CocoaPods..."
cd "$PROJECT_DIR"
pod install

# Install libavif
echo "Installing libavif..."
"$SCRIPT_DIR/install-libavif.sh"

echo "Dependencies setup completed!"
echo ""
echo "Next steps:"
echo "1. Open ImageOptim.xcworkspace (not .xcodeproj) in Xcode"
echo "2. Add the libavif library and headers to your project"
echo "3. Add HAVE_LIBAVIF and HAVE_LIBWEBP to your preprocessor definitions"
echo "4. Build and test the enhanced features"