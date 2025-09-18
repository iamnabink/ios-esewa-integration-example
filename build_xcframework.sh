#!/bin/bash
set -e

# -------------------------------
# Configuration
# -------------------------------
FRAMEWORK_SCHEME="EsewWebToSDKV"
ARCHIVE_NAME="EsewWebToSDKV $(date '+%d-%m-%Y, %H.%M')"
BUILD_DIR="./build"
SIMULATOR_DIR="$BUILD_DIR/iphonesimulator"
DEVICE_ARCHIVE_DIR="$BUILD_DIR/archives"

# -------------------------------
# Step 1: Archive for iOS Devices
# -------------------------------
mkdir -p "$DEVICE_ARCHIVE_DIR"

echo "📦 Archiving $FRAMEWORK_SCHEME for iOS devices..."
xcodebuild archive \
  -scheme "$FRAMEWORK_SCHEME" \
  -configuration Release \
  -destination "generic/platform=iOS" \
  -archivePath "$DEVICE_ARCHIVE_DIR/$ARCHIVE_NAME.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

DEVICE_FRAMEWORK="$DEVICE_ARCHIVE_DIR/$ARCHIVE_NAME.xcarchive/Products/Library/Frameworks/$FRAMEWORK_SCHEME.framework"

# -------------------------------
# Step 2: Build for iOS Simulator
# -------------------------------
mkdir -p "$SIMULATOR_DIR"

echo "📱 Building $FRAMEWORK_SCHEME for iOS Simulator..."
xcodebuild build \
  -scheme "$FRAMEWORK_SCHEME" \
  -configuration Release \
  -sdk iphonesimulator \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SKIP_INSTALL=NO \
  BUILD_DIR="$SIMULATOR_DIR"

SIMULATOR_FRAMEWORK="$SIMULATOR_DIR/Release-iphonesimulator/$FRAMEWORK_SCHEME.framework"

# -------------------------------
# Step 3: Create XCFramework
# -------------------------------
XCFRAMEWORK_OUTPUT="$BUILD_DIR/$FRAMEWORK_SCHEME.xcframework"

echo "🔗 Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "$DEVICE_FRAMEWORK" \
  -framework "$SIMULATOR_FRAMEWORK" \
  -output "$XCFRAMEWORK_OUTPUT"

echo "✅ XCFramework created successfully!"
echo "Path: $XCFRAMEWORK_OUTPUT"
