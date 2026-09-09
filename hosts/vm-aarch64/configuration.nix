{ ... }:

{
  imports = [
    ../../modules/common.nix
    ../../modules/vm-guest.nix
  ];

  # インストール時に mkfs で付けるラベルと対応させる
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };

  # UTM の aarch64 VM は UEFI ブートになる
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "vm-aarch64";

  system.stateVersion = "26.05";
}
