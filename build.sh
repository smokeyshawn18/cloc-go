#!/bin/bash
# build.sh - Builds the cloc-go project for multiple platforms and creates zipped archives

set -e  # Exit on any error

APP_NAME="cloc-go"
DIST="dist"
ENTRY="./cmd/cloc/main.go"
VERSION="v1.0.0"

echo "🔨 Building $APP_NAME version $VERSION for multiple platforms..."

# Create dist directory
mkdir -p $DIST

# Clean previous builds
rm -f $DIST/*

# Build matrix
build() {
  GOOS=$1
  GOARCH=$2
  EXT=$3
  OUTPUT="${DIST}/${APP_NAME}-${GOOS}-${GOARCH}${EXT}"

  echo "📦 Building for $GOOS/$GOARCH..."
  GOOS=$GOOS GOARCH=$GOARCH go build -ldflags "-X main.version=${VERSION}" -o "$OUTPUT" "$ENTRY"
  if [ $? -eq 0 ]; then
    echo "✅ Build successful: $OUTPUT"
  else
    echo "❌ Build failed for $GOOS/$GOARCH!"
    exit 1
  fi
}

# Linux builds
build linux amd64 ""
build linux arm64 ""

# macOS builds
build darwin amd64 ""
build darwin arm64 ""

# Windows builds
build windows amd64 ".exe"
build windows arm64 ".exe"

# Zip all binaries
echo "🗜️ Zipping binaries..."
cd $DIST
for f in *; do
  zip -q "${f}.zip" "$f"
  if [ $? -eq 0 ]; then
    echo "✅ Zipped: ${f}.zip"
  else
    echo "❌ Failed to zip $f!"
    exit 1
  fi
done
cd ..

echo "✅ Build complete. Binaries and archives are in ./$DIST"