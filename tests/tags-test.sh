#!/usr/bin/env sh

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

files_found="$(fd --type file --extension md "^idea " "$NOTES_DIR")"
tags_found="$(fd --type file --extension md --print0 "^idea " "$NOTES_DIR" | xargs -0 "$SCRIPT_DIR/../scripts/process-tags.pl")"

echo "$files_found"

echo "$(echo "$files_found" | wc -l) files found"

echo "$(echo "$tags_found" | wc -l) tags found"
