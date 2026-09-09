{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/plasma.nix
    ../../modules/japanese.nix
    ../../modules/packages-cui.nix
    ../../modules/packages-gui.nix
  ];

  networking.hostName = "macbook-pro-2013";

  system.stateVersion = "26.05";
}
