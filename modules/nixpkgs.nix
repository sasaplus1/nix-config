{ inputs, lib, pkgs, ... }:

let
  allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      # Bitwarden License
      "bws"
      # Docker Subscription Service Agreement
      "docker-sbx"
    ];
in
{
  nixpkgs.config = { inherit allowUnfreePredicate; };

  # home-manager モジュールへは modules/home-manager.nix から渡す
  _module.args.pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;

    config = { inherit allowUnfreePredicate; };
  };
}
