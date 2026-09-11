{ pkgs, pkgs-unstable, lib, ... }:

{
  home.packages = import ../packages/common.nix { inherit pkgs pkgs-unstable lib; };

  # ~/.local/share/gh/extensions が symlink になるので
  # gh extension install と gh extension upgrade は使えない
  programs.gh = {
    enable = true;
    package = pkgs-unstable.gh;
    extensions = import ../packages/gh-extensions.nix { inherit pkgs-unstable lib; };
  };
}
