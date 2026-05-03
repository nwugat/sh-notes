#!/usr/bin/env sh

# Tag parsing functionality

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

# gets all tags from all notes
# result UNSORTED and INCLUDES REPETITIONS
find_tags() {
  fd --type file --extension md --print0 . "$NOTES_DIR" | xargs -0 $SCRIPT_DIR/../scripts/process-tags.pl
}

# gets all tags from all notes + each nested/tag is expanded to all subtags
# result UNSORTED and INCLUDES REPETITIONS
find_tags_expanded() {
  fd --type file --extension md --print0 . "$NOTES_DIR" | xargs -0 $SCRIPT_DIR/../scripts/process-tags.pl --deep
}
