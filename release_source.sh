#!/bin/bash
# Create and upload a source code archive to GitHub Releases
# Requires: gh (GitHub CLI), git
set -e

# Get version tag (from git or VERSION file)
if git describe --tags --abbrev=0 >/dev/null 2>&1; then
  TAG=$(git describe --tags --abbrev=0)
else
  TAG=$(cat VERSION)
fi
TAG=${TAG#v}

ARCHIVE=weather-v${TAG}-source.tar.gz

git archive --format=tar.gz -o "$ARCHIVE" HEAD

echo "Uploading $ARCHIVE to release v$TAG..."
if ! gh release view "v$TAG" >/dev/null 2>&1; then
  gh release create "v$TAG" --title "Release v$TAG" --notes "Automated source release for v$TAG"
fi

gh release upload "v$TAG" "$ARCHIVE" --clobber

echo "Source archive uploaded."
