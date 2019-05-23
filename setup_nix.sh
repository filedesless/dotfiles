#!/usr/bin/env bash

case "$1" in
    "box" | "pad")
	./install -c install.conf.yaml
	./install -c install.nix.conf.yaml
	sudo cp nix/common.nix /etc/nixos/common.nix
	sudo cp nix/"$1".nix /etc/nixos/configuration.nix
	sudo nixos-rebuild test
	;;
    *)
	echo "Usage: $0 box|pad" 1>&2
	exit 1
	;;
esac
