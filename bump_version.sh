#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: ./bump_version.sh [major|minor|patch]
       ./bump_version.sh --set X.Y.Z

Increments VERSION (MAJOR.MINOR.PATCH).
Defaults to patch if no argument is provided.
USAGE
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

if [[ ! -f VERSION ]]; then
  echo "VERSION file not found" >&2
  exit 1
fi

raw_version="$(cat VERSION)"
version="${raw_version#v}"
if ! [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "VERSION must be in MAJOR.MINOR.PATCH format" >&2
  exit 1
fi

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ "${1:-}" == "--set" ]]; then
  new_version="${2:-}"
  if ! [[ "$new_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Version must be in MAJOR.MINOR.PATCH format" >&2
    exit 1
  fi
  echo "v$new_version" > VERSION
  echo "VERSION set to $new_version"
  exit 0
fi

bump="${1:-patch}"
IFS='.' read -r major minor patch <<< "$version"

case "$bump" in
  major)
    major=$((major + 1))
    minor=0
    patch=0
    ;;
  minor)
    minor=$((minor + 1))
    patch=0
    ;;
  patch)
    patch=$((patch + 1))
    ;;
  *)
    usage
    exit 1
    ;;
esac

echo "v${major}.${minor}.${patch}" > VERSION

echo "VERSION bumped to ${major}.${minor}.${patch}"
