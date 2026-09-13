# dotfiles

Small POSIX `sh` manager for linking files from this repository into `$HOME`.

```sh
# Adopt existing files from $HOME (copy them, then create symlinks)
./dotfiles add .profile .config/nvim
# Absolute paths inside $HOME are also accepted
./dotfiles add "$HOME/.profile"

# Create parent directories and symlink selected paths into $HOME, or all
# dotfiles when no path is provided
./dotfiles install .profile .config/nvim
./dotfiles install
# Running the command without arguments also installs all dotfiles
./dotfiles
# Replace existing targets without prompting
./dotfiles install --force
# Leave existing targets unchanged
./dotfiles install --ignore-existing

# Remove only symlinks created by this manager
./dotfiles remove .profile .config/nvim
# Remove every managed file
./dotfiles remove

# Show the state of selected files, or every dotfile when no path is provided
./dotfiles status .profile .config/nvim
./dotfiles status

# List files currently linked by this manager
./dotfiles list
```

Paths are relative to the repository. `install` warns and asks for
confirmation before replacing an existing target. With no paths, it installs
all files in the repository, excluding this script and the README.
`list` prints only repository files whose corresponding `$HOME` path is a
symlink back to this repository. `remove` refuses to remove a target that is
not a symlink back to this repository.
