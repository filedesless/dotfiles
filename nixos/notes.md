# update nix channel

	nix-channel --update

# garbage collection

	nix-collect-garbage

# disable binary cache in nix

	nix-build --option substitute false
