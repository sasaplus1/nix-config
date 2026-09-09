{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nix-settings.nix
    ../../modules/users.nix
    ../../modules/plasma.nix
    ../../modules/japanese.nix
    ../../modules/packages-cui.nix
    ../../modules/packages-gui.nix
    ../../modules/vm-guest.nix
  ];

  # UTM の aarch64 VM は UEFI ブートになる
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "vm-aarch64";

  system.stateVersion = "26.05";
}
