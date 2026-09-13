{ config, lib, ... }:

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

  # 内蔵 Wi-Fi は BCM4360 で、カーネル同梱の brcmfmac では動かない
  # 有線ポートがないので入れないとインストール後に何も繋がらない
  boot.initrd.kernelModules = [ "wl" ];
  boot.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  # broadcom_sta は insecure 扱いになることがあるため
  nixpkgs.config.allowInsecurePredicate =
    pkg: lib.getName pkg == "broadcom-sta";

  networking.networkmanager.enable = true;
  users.users.sasaplus1.extraGroups = [ "networkmanager" ];

  # 内蔵キーボードは Apple の JIS 配列
  services.xserver.xkb.model = "apple";

  # 内蔵トラックパッドはキーボードとは別のデバイスとして出てくる
  home-manager.users.sasaplus1.programs.plasma.input.touchpads = [
    {
      name = "bcm5974";
      vendorId = "05ac";
      productId = "025b";
      naturalScroll = true;
    }
  ];

  networking.hostName = "macbook-pro-2013";

  system.stateVersion = "26.05";
}
