#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Dummy File
# @raycast.mode silent

# Optional parameters:
# @raycast.packageName Files
# @raycast.argument1 { "type": "dropdown", "placeholder": "Type", "optional": true, "data": [{"title": "Text (.txt)", "value": "txt"}, {"title": "PDF (.pdf)", "value": "pdf"}, {"title": "Image (.png)", "value": "png"}] }

# Documentation:
# @raycast.description Create a small dummy file and reveal it in Finder, ready to drag into an upload field.

# Raycast runs scripts without the shell environment, so resolve the cache dir here.
dir="${XDG_CACHE_HOME:-$HOME/.cache}/dummy-files"
ext="${1:-txt}"
file="$dir/dummy.$ext"
mkdir -p "$dir"

case "$ext" in
txt)
    echo "This is a dummy file." >"$file"
    ;;
pdf)
    # Smallest valid one-page PDF: a blank A4 page.
    printf '%s\n' \
        '%PDF-1.4' \
        '1 0 obj<</Type/Catalog/Pages 2 0 R>>endobj' \
        '2 0 obj<</Type/Pages/Kids[3 0 R]/Count 1>>endobj' \
        '3 0 obj<</Type/Page/Parent 2 0 R/MediaBox[0 0 595 842]>>endobj' \
        'xref' \
        '0 4' \
        '0000000000 65535 f ' \
        '0000000009 00000 n ' \
        '0000000052 00000 n ' \
        '0000000101 00000 n ' \
        'trailer<</Size 4/Root 1 0 R>>' \
        'startxref' \
        '164' \
        '%%EOF' >"$file"
    ;;
png)
    # A 1x1 transparent PNG.
    echo 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==' | base64 -d >"$file"
    ;;
*)
    echo "Unknown type: $ext"
    exit 1
    ;;
esac

open -R "$file"
echo "Created dummy.$ext"
