#!/bin/bash
# install.sh - Installs cloc-go from GitHub release and tags the repository with v1.0.0

set -e  # Exit on any error

REPO="smokeyshawn18/cloc-go"
VERSION="v1.0.0"
BINARY_NAME="cloc-go"

echo "📦 Installing $BINARY_NAME from $REPO (version $VERSION)..."

# Detect OS and ARCH
OS=$(uname -s)
ARCH=$(uname -m)

case "$OS" in
  "Linux") PLATFORM="linux" ;;
  "Darwin") PLATFORM="darwin" ;;
  *)
    echo "❌ Unsupported OS: $OS"
    echo "Please download manually from: https://github.com/$REPO/releases/tag/$VERSION"
    exit 1
    ;;
esac

case "$ARCH" in
  "x86_64") ARCH="amd64" ;;
  "arm64" | "aarch64") ARCH="arm64" ;;
  *)
    echo "❌ Unsupported architecture: $ARCH"
    echo "Please download manually from: https://github.com/$REPO/releases/tag/$VERSION"
    exit 1
    ;;
esac

ZIP_NAME="${BINARY_NAME}-${PLATFORM}-${ARCH}.zip"
BIN_NAME="${BINARY_NAME}-${PLATFORM}-${ARCH}"
URL="https://github.com/$REPO/releases/download/$VERSION/$ZIP_NAME"

echo "➡️ Downloading $ZIP_NAME..."
curl -LO --fail --silent --show-error "$URL"
if [ $? -ne 0 ]; then
    echo "❌ Failed to download $ZIP_NAME. Check if the file exists at $URL."
    echo "Possible causes: File not uploaded, network issue, or GitHub release problem."
    exit 1
fi

# Verify file size (basic check for incomplete download)
FILE_SIZE=$(stat -c%s "$ZIP_NAME" 2>/dev/null || stat -f%z "$ZIP_NAME")
if [ "$FILE_SIZE" -lt 1000 ]; then
    echo "❌ Downloaded file $ZIP_NAME is too small ($FILE_SIZE bytes). Likely incomplete or corrupt."
    echo "Please verify the release at https://github.com/$REPO/releases/tag/$VERSION."
    exit 1
fi

echo "📂 Unzipping..."
unzip -o "$ZIP_NAME"
if [ $? -ne 0 ]; then
    echo "❌ Failed to unzip $ZIP_NAME. The file may be corrupt or not a valid zip."
    echo "Trying alternative extraction with 7z..."
    if command -v 7z >/dev/null 2>&1; then
        7z x "$ZIP_NAME"
        if [ $? -ne 0 ]; then
            echo "❌ 7z extraction failed. Please redownload the file or check the GitHub release."
            exit 1
        fi
    else
        echo "❌ 7z not installed. Install it with 'sudo apt install p7zip-full' (Ubuntu) or 'brew install p7zip' (macOS)."
        echo "Alternatively, download manually from https://github.com/$REPO/releases/tag/$VERSION."
        exit 1
    fi
fi

echo "🔧 Making executable..."
chmod +x "$BIN_NAME"
if [ $? -ne 0 ]; then
    echo "❌ Failed to make $BIN_NAME executable."
    exit 1
fi

echo "🚚 Moving to /usr/local/bin/$BINARY_NAME..."
sudo mv "$BIN_NAME" /usr/local/bin/$BINARY_NAME
if [ $? -ne 0 ]; then
    echo "❌ Failed to install $BINARY_NAME to /usr/local/bin."
    exit 1
fi

echo "✅ Installed! Try running: $BINARY_NAME --help"

