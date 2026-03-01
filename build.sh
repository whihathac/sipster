#!/bin/bash
set -e

APP_NAME="Sipster"
BUILD_DIR=".build/release"
BUNDLE_DIR="${BUILD_DIR}/${APP_NAME}.app"
CONTENTS_DIR="${BUNDLE_DIR}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

echo "Building ${APP_NAME}..."
swift build -c release 2>&1

echo "Creating .app bundle..."
rm -rf "${BUNDLE_DIR}"
mkdir -p "${MACOS_DIR}"
mkdir -p "${RESOURCES_DIR}"

cp "${BUILD_DIR}/${APP_NAME}" "${MACOS_DIR}/${APP_NAME}"
cp "Resources/Info.plist" "${CONTENTS_DIR}/Info.plist"

if [ -f "Resources/Assets/AppIcon.icns" ]; then
    cp "Resources/Assets/AppIcon.icns" "${RESOURCES_DIR}/AppIcon.icns"
fi

echo "Code signing..."
codesign --force --sign - "${BUNDLE_DIR}"

echo ""
echo "Build complete: ${BUNDLE_DIR}"
echo "Run with: open ${BUNDLE_DIR}"
