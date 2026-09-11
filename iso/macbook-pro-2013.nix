# MacBookPro11,1 (MacBook Pro Retina 13-inch, Late 2013)
{ config, lib, modulesPath, ... }:

{
  imports = [
    (modulesPath
      + "/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix")
  ];

  nixpkgs.config = {
    allowUnfree = true;

    # broadcom_sta は insecure 扱いになることがあるため
    allowInsecurePredicate =
      pkg: lib.getName pkg == "broadcom-sta";
  };

  boot.initrd.kernelModules = [ "wl" ];

  boot.kernelModules = [
    "kvm-intel"
    "wl"
  ];

  boot.extraModulePackages = [
    config.boot.kernelPackages.broadcom_sta
  ];
}
