#!/usr/bin/env bash

export TARGET=$HOSTNAME

if [ -z "$TARGET" ]
then
    if [ -z "$1" ]
    then
	echo "Usage: $0 box|pad" 1>&2
	exit 1
    fi
    export TARGET="$1"
fi

if [ -f nix/"$TARGET".nix ]
then
    echo "Building system for $TARGET"
    ./install -c install.conf.yaml
    ./install -c install.nix.conf.yaml
    sudo cp nix/common.nix /etc/nixos/common.nix
    sudo cp nix/"$TARGET".nix /etc/nixos/configuration.nix
    sudo nixos-rebuild switch
else
    echo "No such file or directory: nix/${TARGET}.nix"
fi
