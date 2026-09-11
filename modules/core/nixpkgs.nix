{ inputs, lib, pkgs, ... }:

let
  allowUnfreePredicate = import ../../lib/allow-unfree.nix lib;
in
{
  nixpkgs.config = { inherit allowUnfreePredicate; };

  # home-manager モジュールへは modules/home-manager.nix から渡す
  _module.args.pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;

    config = { inherit allowUnfreePredicate; };
  };
}
