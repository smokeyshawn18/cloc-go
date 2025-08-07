#!/bin/bash
# install.sh - Installs cloc-go from GitHub release and tags the repository with v1.0.0

set -e  # Exit on any error

REPO="yourusername/cloc-go"
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

echo "➡️ Downloading $ZIP_NAME..."
curl -LO "https://github.com/$REPO/releases/download/$VERSION/$ZIP_NAME"
if [ $? -ne 0 ]; then
    echo "❌ Failed to download $ZIP_NAME"
    exit 1
fi

echo "📂 Unzipping..."
unzip -o "$ZIP_NAME"
if [ $? -ne 0 ]; then
    echo "❌ Failed to unzip $ZIP_NAME"
    exit 1
fi

echo "🔧 Making executable..."
chmod +x "$BIN_NAME"
if [ $? -ne 0 ]; then
    echo "❌ Failed to make $BIN_NAME executable"
    exit 1
fi

echo "🚚 Moving to /usr/local/bin/$BINARY_NAME..."
sudo mv "$BIN_NAME" /usr/local/bin/$BINARY_NAME
if [ $? -ne 0 ]; then
    echo "❌ Failed to install $BINARY_NAME to /usr/local/bin"
    exit 1
fi

echo "✅ Installed! Try running: $BINARY_NAME --help"

echo "🏷️ Tagging repository with $VERSION..."
git tag -a "$VERSION" -m "Release $BINARY_NAME $VERSION"
if [ $? -eq 0 ]; then
    echo "✅ Git tag $VERSION created successfully."
else
    echo "❌ Failed to create Git tag!"
    exit 1
fi

echo "🚀 Pushing tag to remote repository..."
git push origin "$VERSION"
if [ $? -eq 0 ]; then
    echo "✅ Tag $VERSION pushed successfully."
else
    echo "❌ Failed to push Git tag!"
    exit 1
fi