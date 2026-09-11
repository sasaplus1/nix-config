{ pkgs, lib, ... }:

{
  imports = [
    ../modules/common.nix
    ../modules/standalone.nix
  ];

  home.stateVersion = "25.11";

  home.packages = import ../packages/dev.nix { inherit pkgs lib; };
}
