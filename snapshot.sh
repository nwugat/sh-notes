#!/usr/bin/env sh

here_path=$(realpath $(dirname $0))
notes_root=$(realpath $here_path/..)

git add $notes_root/*.md ; git commit -m "$(date +"%Y-%m-%d-%H:%M Snapshot")"
