{ inputs, pkgs-unstable, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    # 衝突したファイルを退避する
    # これがないと activation が失敗する
    backupFileExtension = "backup";

    extraSpecialArgs = { inherit pkgs-unstable; };

    sharedModules = [
      inputs.plasma-manager.homeModules.plasma-manager
    ];

    users.sasaplus1.imports = [
      ../home/modules/common.nix
      ../home/modules/nixos.nix
    ];
  };
}
