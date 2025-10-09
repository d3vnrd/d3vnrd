set quiet := true
ROOT := justfile_directory() + "/content/vault/"

default:
    @just --list

# open:
#     file=$(find {{ROOT}}archive \
#                 {{ROOT}}resource \
#                 -type f | fzf)
#
#     wsl-open "obsidian://open?vault=vault&file=$$file"


open file:
    wsl-open "obsidian://open?vault=vault&file={{file}}"
