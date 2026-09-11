{ ... }:

{
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
  };
}
