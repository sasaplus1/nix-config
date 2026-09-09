{ pkgs, ... }:

{
  i18n.defaultLocale = "ja_JP.UTF-8";

  console.keyMap = "jp106";

  services.xserver.xkb = {
    layout = "jp";
    model = "apple";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5.addons = with pkgs; [
      fcitx5-mozc
    ];
  };
}
