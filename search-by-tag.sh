#!/usr/bin/env sh

here_path="$(realpath $(dirname $0))"
notes_root="$(realpath $here_path/..)"

selected_tags=$($here_path/print-tags.sh | fzf --multi)

test -z "$selected_tags" && { echo "^Cancelled" ; exit 0; }

# pre-filter: remove all files that don't even match the keywords
files_candidates="$(rg --files --glob *.md "$notes_root")"
while IFS= read -r tag; do
  files_candidates="$(printf "%s" "$files_candidates" | tr '\n' '\0' | xargs -0 rg -l -F "$tag")"
done <<< "$selected_tags"

# filter: remove false positives (matches that aren't actual tags)
files_result=""
while IFS= read -r file; do
  file_stays=true
  processed_tags=$("$here_path/process-tags.pl" "$file" | sort | uniq)
  while IFS= read -r tag; do
    # $processed_tags contains $tag? $file_stays stays true, else = false, else = false
    printf "%s" "$processed_tags" | grep -Fxq "$tag" || {
      file_stays=false;
      break;
    }
  done <<< "$selected_tags"
  test "$file_stays" = true && files_result=$(printf "%s\n%s" "$files_result" "$file")
done <<< "$files_candidates"

test -z "$files_result" && { echo "No matching files found" ; exit 0; }

selected_file=$(echo "$files_result" | fzf)

test -z "$selected_file" && { echo "No file selected" ; exit 0; }

nvim +"cd $notes_root" "$selected_file"
