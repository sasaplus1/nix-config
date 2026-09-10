{ pkgs, ... }:

{
  # NTP は services.timesyncd が既定で有効
  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "ja_JP.UTF-8";

  console.keyMap = "jp106";

  # model はキーボードの実体ごとに異なるため各ホストで指定する
  services.xserver.xkb.layout = "jp";

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5.addons = with pkgs; [
      fcitx5-mozc
    ];
  };
}
