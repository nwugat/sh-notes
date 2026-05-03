#!/usr/bin/env sh

NOTES_DIR="$HOME/notes"

die() {
  echo "$*" >&2
  exit 1
}
