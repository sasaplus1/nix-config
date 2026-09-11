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

  # UTM はトラックパッドを汎用USBデバイスとして見せる
  # ID はどちらも 0627:0001 で名前だけが異なる
  # programs.plasma は modules/desktop と併せて import したときだけ存在する
  home-manager.users.sasaplus1.programs.plasma.input.mice = [
    {
      name = "QEMU QEMU USB Tablet";
      vendorId = "0627";
      productId = "0001";
      naturalScroll = true;
    }
    {
      name = "QEMU QEMU USB Mouse";
      vendorId = "0627";
      productId = "0001";
      naturalScroll = true;
    }
  ];
}
