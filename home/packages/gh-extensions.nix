# gh extensions are installed via programs.gh.extensions in
# home/modules/common.nix, so they are listed here instead of common.nix.
{ pkgs-unstable, lib }:
[
  pkgs-unstable.gh-dash
  pkgs-unstable.gh-poi
  pkgs-unstable.gh-stack
]
