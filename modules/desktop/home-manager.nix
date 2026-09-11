{ inputs, ... }:

{
  home-manager = {
    sharedModules = [
      inputs.plasma-manager.homeModules.plasma-manager
    ];

    users.sasaplus1.imports = [
      ../../home/modules/desktop.nix
    ];
  };
}
