{ ... }:

{
  # nixos-rebuild --flake を使うために必要
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # 世代を消さないと nix store は増える一方になる
  # persistent は既定で true なので、止めていた間の分は次回の起動で走る
  nix.gc = {
    automatic = true;
    dates = "weekly";

    # 現行世代は --delete-older-than の対象にならない
    options = "--delete-older-than 30d";
  };
}
