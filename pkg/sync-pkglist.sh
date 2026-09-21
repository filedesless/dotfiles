#!/bin/sh
# Regenerates pkg/pacman.txt and pkg/aur.txt from the explicitly installed
# package set and commits the change. Run automatically by the pacman hook
# in pkg/dotfiles-pkglist.hook (installed via ./dotfiles link), or by hand.
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
pkg_dir=$repo_dir/pkg

pacman -Qqen > "$pkg_dir/pacman.txt"
pacman -Qqem > "$pkg_dir/aur.txt"

cd "$repo_dir"
git add pkg/pacman.txt pkg/aur.txt
git diff --cached --quiet -- pkg/ && exit 0

git commit -q -m "pkg: sync package list ($(date +%F))" -- pkg/pacman.txt pkg/aur.txt
