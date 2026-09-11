{ ... }:

{
  home.stateVersion = "26.05";

  # ja_JP.UTF-8 だと日本語名のディレクトリが作られる
  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    # XDG_PROJECTS_DIR は標準ではない
    projects = null;
  };

  programs.plasma = {
    enable = true;

    workspace.lookAndFeel = "org.kde.breezedark.desktop";

    # Plasma は LANG ではなく kdeglobals の LANGUAGE を見る
    configFile.kdeglobals.Translations.LANGUAGE = "ja";

    # kxkbrc に Use=true が書かれると services.xserver.xkb より優先される
    input.keyboard = {
      model = "jp106";

      layouts = [
        { layout = "jp"; }
      ];
    };

    # UTM はトラックパッドを汎用USBデバイスとして見せる
    # ID はどちらも 0627:0001 で名前だけが異なる
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
