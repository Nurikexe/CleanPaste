#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_PATH="$ROOT_DIR/CleanPaste.xcodeproj"
SCHEME="CleanPaste"
CONFIGURATION="Release"
VERSION="${1:-1.0}"

BUILD_DIR="$ROOT_DIR/build"
DERIVED_DATA_PATH="$BUILD_DIR/DerivedData"
DIST_DIR="$ROOT_DIR/dist"
DMG_STAGING_DIR="$BUILD_DIR/dmg-staging"
APP_PATH="$DERIVED_DATA_PATH/Build/Products/$CONFIGURATION/CleanPaste.app"
DMG_PATH="$DIST_DIR/CleanPaste-$VERSION.dmg"

rm -rf "$DERIVED_DATA_PATH" "$DMG_STAGING_DIR"
mkdir -p "$DIST_DIR" "$DMG_STAGING_DIR"

xcodebuild \
  -project "$PROJECT_PATH" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  -destination "platform=macOS" \
  build

ditto "$APP_PATH" "$DMG_STAGING_DIR/CleanPaste.app"
ln -s /Applications "$DMG_STAGING_DIR/Applications"

hdiutil create \
  -volname "CleanPaste" \
  -srcfolder "$DMG_STAGING_DIR" \
  -ov \
  -format UDZO \
  "$DMG_PATH"

echo "Created $DMG_PATH"
