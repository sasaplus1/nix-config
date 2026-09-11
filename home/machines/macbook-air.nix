{ pkgs, lib, ... }:

{
  imports = [
    ../modules/common.nix
    ../modules/standalone.nix
  ];

  home.stateVersion = "25.11";

  home.packages = import ../packages/music.nix { inherit pkgs lib; };
}
