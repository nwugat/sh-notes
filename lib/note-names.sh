#!/usr/bin/env sh

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

# prints all note FILE NAMES
find_notes() {
  #TODO use alternative if fd is unavailable
  fd --type file --extension md . "$NOTES_DIR"
}

# prints all note FILE NAMES, separated by \0
find_notes_0() {
  #TODO use alternative if fd is unavailable
  fd --type file --extension md . "$NOTES_DIR" --print0
}

#TODO implement `find_notes_filtered` like find_notes but accounts for filters
find_notes_filtered() {
  echo "Not implemented" >&2 ; exit 1
}

#TODO
find_note_aliases() {
  # takes a file and returns all aliases, including file name
  echo "Not implemented" >&2 ; exit 1
}
