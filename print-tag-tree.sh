#!/usr/bin/env sh

here_path=$(realpath $(dirname $0))
notes_root=$(realpath $here_path/..)

$here_path/print-tags.sh | $here_path/to-tree.py
