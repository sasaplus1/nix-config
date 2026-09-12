{ ... }:

{
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/desktop
  ];

  boot.loader.systemd-boot.enable = true;

  # Apple のファームウェアは NVRAM のエントリを見ずに ESP を走査するので
  # EFI 変数は触らず、bootctl が置く EFI/BOOT/BOOTX64.EFI から起動させる
  boot.loader.efi.canTouchEfiVariables = false;

  # 内蔵キーボードは Apple の JIS 配列
  services.xserver.xkb.model = "apple";

  networking.hostName = "macbook-pro-2013";

  system.stateVersion = "26.05";
}
