# dotfiles

Small POSIX `sh` manager for linking files and folders from this repository
into `$HOME`.

```sh
# Adopt existing files or folders from $HOME (copy them, then create symlinks)
./dotfiles add .profile .config/nvim
# Folders are copied recursively before being linked
./dotfiles add .config
# Absolute paths inside $HOME are also accepted
./dotfiles add "$HOME/.profile"

# Create parent directories and symlink selected paths into $HOME
./dotfiles install .profile .config/nvim
# Install all dotfile paths in the repository
./dotfiles install

# Remove only symlinks created by this manager
./dotfiles remove .profile .config/nvim
```

Paths are relative to the repository. `install` warns and asks for
confirmation before replacing an existing target. With no paths, it installs
all top-level dotfile paths, excluding this script, the README, and `.git`.
`remove` refuses to remove a target that is not a symlink back to this
repository.
