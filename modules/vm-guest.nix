{ modulesPath, ... }:

{
  imports = [
    # virtio 系のカーネルモジュールを initrd に入れる
    # hardware-configuration.nix を使わないため必要
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # クリップボード共有に使う
  # UTM は QEMU / Apple どちらのバックエンドでも SPICE 経由で共有する
  services.spice-vdagentd.enable = true;

  # QEMU バックエンド用のゲストエージェント
  # Apple バックエンドではチャネルが存在しないため起動しない
  services.qemuGuest.enable = true;
}
