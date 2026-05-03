#!/usr/bin/env sh

# Tag-related functionality

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"
source "$SCRIPT_DIR/../lib/note-names.sh"

# gets all tags from all notes
# result UNSORTED and INCLUDE REPETITIONS
find_tags() {
  fd --type file --extension md --print0 . "$NOTES_DIR" | xargs -0 $SCRIPT_DIR/../scripts/process-tags.pl
}

# gets all tags from all notes + each nested/tag is expanded to all subtags
# result UNSORTED and INCLUDE REPETITIONS
find_tags_expanded() {
  fd --type file --extension md --print0 . "$NOTES_DIR" | xargs -0 $SCRIPT_DIR/../scripts/process-tags.pl --deep
}

find_notes_with_tags() {
  selected_tags="$@"

  # pre-filter: remove all files that don't even match the keywords
  files_candidates="$(find_notes)"
  while IFS= read -r tag; do
    files_candidates="$(printf "%s" "$files_candidates" | tr '\n' '\0' | xargs -0 rg -l -F "$tag")"
  done <<< "$selected_tags"

  # filter: remove false positives (matches that aren't actual tags)
  files_result=""
  while IFS= read -r file; do
    file_stays=true
    processed_tags=$("$SCRIPT_DIR/../scripts/process-tags.pl" --deep "$file" | sort | uniq)
    while IFS= read -r tag; do
      # $processed_tags contains $tag? $file_stays stays true, else = false, else = false
      printf "%s" "$processed_tags" | grep -Fxq "$tag" || {
        file_stays=false;
        break;
      }
    done <<< "$selected_tags"
    test "$file_stays" = true && files_result=$(printf "%s\n%s" "$files_result" "$file")
  done <<< "$files_candidates"

  printf "%s" "$files_result"
}
