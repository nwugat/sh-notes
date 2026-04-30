#!/usr/bin/env sh

here_path=$(realpath $(dirname $0))
notes_root=$(realpath $here_path/..)

$here_path/process-tags.pl $notes_root/*.md | sort | uniq
