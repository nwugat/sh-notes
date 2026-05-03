# sh-notes

Trying to mimic Obsidian's features with small scripts.

## Project structure

```
.
├── bin     # user-facing scripts
├── lib     # *shell* libs
├── src     # reusable code, separated by lang
├── scripts # one-off scripts
└── tests   # test scripts
```

## Dependencies

- bash
- python
- perl
- fd
- rg

## Features I want

- tag
    - search all tags
    - search notes by tag
    - rename tag
- search notes by name
    - file name
    - aliases
- note query
    - search notes by metadata
