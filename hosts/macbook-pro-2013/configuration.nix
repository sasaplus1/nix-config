{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/common.nix
  ];

  networking.hostName = "macbook-pro-2013";

  system.stateVersion = "26.05";
}
