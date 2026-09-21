# dotfiles

Small POSIX `sh` manager for linking files from this repository into `$HOME`.

```sh
# Adopt existing files from $HOME (copy them, then create symlinks)
./dotfiles add .profile .config/nvim
# Absolute paths inside $HOME are also accepted
./dotfiles add "$HOME/.profile"

# Create parent directories and symlink selected paths into $HOME, or all
# dotfiles when no path is provided
./dotfiles link .profile .config/nvim
./dotfiles link
# Running the command without arguments prints usage
./dotfiles
# Replace existing targets without prompting
./dotfiles link --force
# Leave existing targets unchanged
./dotfiles link --ignore-existing

# Remove only symlinks created by this manager
./dotfiles unlink .profile .config/nvim
# Remove every managed file
./dotfiles unlink

# Show the state of selected files, or every dotfile when no path is provided
./dotfiles status .profile .config/nvim
./dotfiles status

# List files currently linked by this manager
./dotfiles list
```

Paths are relative to the repository. `link` warns and asks for
confirmation before replacing an existing target. With no paths, `link`
links all files in the repository, excluding this script and the README;
running `./dotfiles` with no command prints usage instead.
`list` prints only repository files whose corresponding `$HOME` path is a
symlink back to this repository. `unlink` refuses to remove a target that
is not a symlink back to this repository.

## Package list

`pkg/pacman.txt` and `pkg/aur.txt` track explicitly installed native and
AUR packages (`pacman -Qqen` / `pacman -Qqem`). A pacman hook keeps them
in sync automatically: every install/remove transaction re-dumps both
lists and, if they changed, commits the diff to this repo as the
`filedesless` user.

To set this up on a fresh machine:

```sh
sudo ln -s "$PWD/pkg/dotfiles-pkglist.hook" /etc/pacman.d/hooks/dotfiles-pkglist.hook
```

The hook runs `pkg/sync-pkglist.sh`, which can also be run by hand. To
restore packages on a new install:

```sh
sudo pacman -S --needed - < pkg/pacman.txt
paru -S --needed - < pkg/aur.txt
```
