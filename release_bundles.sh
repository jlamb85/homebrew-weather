#!/bin/bash
# Build and release bundles with tag awareness, and upload to GitHub Releases
# Requires: gh (GitHub CLI), pyinstaller, git
set -e

# Get version tag (from git or VERSION file)
if git describe --tags --abbrev=0 >/dev/null 2>&1; then
  TAG=$(git describe --tags --abbrev=0)
else
  TAG=$(cat VERSION)
fi
TAG=${TAG#v}

# Build bundles
./build_bundle.sh "$TAG"

# Create GitHub release if not exists
if ! gh release view "v$TAG" >/dev/null 2>&1; then
  gh release create "v$TAG" --title "Release v$TAG" --notes "Automated release for v$TAG"
fi

# Upload all bundles in dist/ to the release
for f in dist/*; do
  gh release upload "v$TAG" "$f" --clobber
  echo "Uploaded $f to release v$TAG"
done
