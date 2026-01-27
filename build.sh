#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

if [[ ! -f "config.default.json" ]]; then
  echo "Missing config.default.json. Create it from config.json first." >&2
  exit 1
fi

if ! command -v pyinstaller >/dev/null 2>&1; then
  echo "pyinstaller not found. Activate your venv or install it." >&2
  exit 1
fi

echo "Cleaning previous build artifacts..."
rm -rf build dist

copy_runtime_files() {
  local target_dir="$1"
  mkdir -p "$target_dir"
  cp "config.default.json" "$target_dir/config.default.json"
  if [[ ! -f "$target_dir/config.json" ]]; then
    cp "config.default.json" "$target_dir/config.json"
  fi
}

VERSION="$(cat VERSION)"
VERSION="${VERSION#v}"

OS_NAME="$(uname -s)"
case "$OS_NAME" in
  Darwin)
    NAME_ONEFILE="weather-v${VERSION}-macos"
    NAME_ONEDIR="weather-v${VERSION}-macos-dir"
    ;;
  Linux)
    NAME_ONEFILE="weather-v${VERSION}-linux-x86_64"
    NAME_ONEDIR="weather-v${VERSION}-linux-x86_64-dir"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    NAME_ONEFILE="weather-v${VERSION}-win.exe"
    NAME_ONEDIR="weather-v${VERSION}-win-dir"
    ;;
  *)
    echo "Unsupported OS: $OS_NAME" >&2
    exit 1
    ;;
esac

echo "Building one-file executable..."
pyinstaller --clean --noconfirm --onefile weather.py -n "$NAME_ONEFILE"

if [[ -f "dist/$NAME_ONEFILE" ]]; then
  copy_runtime_files "dist"
elif [[ -f "dist/$NAME_ONEFILE.exe" ]]; then
  copy_runtime_files "dist"
fi

echo "Building one-folder executable..."
pyinstaller --clean --noconfirm --onedir weather.py -n "$NAME_ONEDIR"
copy_runtime_files "dist/$NAME_ONEDIR"

echo "Builds complete. Outputs are in dist/."
