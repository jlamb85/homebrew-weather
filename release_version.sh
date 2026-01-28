#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: ./release_version.sh <major|minor|patch>

Runs:
  ./bump_version.sh <bump>
  git add VERSION
  git commit -m "Bump version"
  git tag "$(cat VERSION)"
  git push && git push --tags

Argument is required; no default.
USAGE
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if ! command -v git >/dev/null 2>&1; then
  echo "git not found in PATH." >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Working tree not clean. Commit or stash changes first." >&2
  exit 1
fi

bump="${1:-}"
if [[ -z "$bump" ]]; then
  echo "Missing required argument: major|minor|patch" >&2
  usage
  exit 1
fi
case "$bump" in
  major|minor|patch) ;;
  *)
    usage
    exit 1
    ;;
esac

./bump_version.sh "$bump"

git add VERSION
git commit -m "Bump version"
git tag "$(cat VERSION)"
git push && git push --tags
