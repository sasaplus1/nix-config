{ config, inputs, ... }:

{
  home-manager = {
    sharedModules = [
      inputs.plasma-manager.homeModules.plasma-manager
    ];

    users.sasaplus1 = {
      imports = [
        ../../home/modules/desktop.nix
      ];

      # kxkbrc に Use=true が書かれると services.xserver.xkb より優先される
      # 食い違わないよう同じ値を流す
      programs.plasma.input.keyboard = {
        inherit (config.services.xserver.xkb) model;

        layouts = [
          { inherit (config.services.xserver.xkb) layout; }
        ];
      };
    };
  };
}
