#!/usr/bin/env bash
# Install chezmoi: curl+tar download on Linux, Homebrew on macOS.

set -euo pipefail

case "$(uname -s)" in
  Linux)
    chezmoi_version="v2.72.2"
    chezmoi_url="https://github.com/twpayne/chezmoi/releases/download/${chezmoi_version}"
    chezmoi_archive="chezmoi_${chezmoi_version#v}_linux_amd64.tar.gz"
    curl -sfL "${chezmoi_url}/${chezmoi_archive}" | tar -xz -C /tmp
    sudo mv /tmp/chezmoi /usr/local/bin/chezmoi
    ;;
  Darwin)
    brew update
    brew install chezmoi
    ;;
  *)
    echo "Unsupported OS: $(uname -s)" >&2
    exit 1
    ;;
esac
