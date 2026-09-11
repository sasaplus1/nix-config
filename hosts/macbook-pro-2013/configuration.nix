{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/desktop
  ];

  # 内蔵キーボードは Apple の JIS 配列
  services.xserver.xkb.model = "apple";

  networking.hostName = "macbook-pro-2013";

  system.stateVersion = "26.05";
}
