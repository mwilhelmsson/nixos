#!/bin/sh

set -e

pushd ~/.dotfiles
home-manager switch --flake "./users#nixos"
popd
