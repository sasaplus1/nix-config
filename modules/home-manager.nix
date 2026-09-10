{ inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    # NixOS 側の pkgs をそのまま使う
    # home-manager が nixpkgs を別に評価しなくなる
    useGlobalPkgs = true;

    # パッケージを ~/.nix-profile ではなく /etc/profiles 以下に置く
    useUserPackages = true;

    # 既存ファイルと衝突したら退避してから上書きする
    # これがないと activation が失敗して切り替わらない
    backupFileExtension = "backup";

    sharedModules = [
      inputs.plasma-manager.homeModules.plasma-manager
    ];

    users.sasaplus1 = import ../home/sasaplus1.nix;
  };
}
