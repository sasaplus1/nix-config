{ ... }:

{
  home.stateVersion = "26.05";

  # ロケールに合わせて日本語のディレクトリ名が作られるのを止める
  # 既定値が Desktop, Documents, Downloads などの英語名になっている
  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    # XDG_PROJECTS_DIR は標準ではないので作らない
    projects = null;
  };

  programs.plasma = {
    # overrideConfig は既定の false のままにする
    # true にすると宣言していない設定が activation ごとに消える
    enable = true;

    workspace.lookAndFeel = "org.kde.breezedark.desktop";

    # UTM はトラックパッドをタッチパッドではなく汎用USBデバイスとして見せる
    # ID はどちらも QEMU の 0627:0001 で、名前だけが異なる
    input.mice = [
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
  };
}
