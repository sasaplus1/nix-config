{ ... }:

{
  imports = [
    ./disk-config.nix

    ../../modules/common.nix
    ../../modules/vm-guest.nix
  ];

  # UTM の aarch64 VM は UEFI ブートになる
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "vm-aarch64";

  system.stateVersion = "26.05";
}
