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

    # かなキーでオン、英数キーでオフにする
    # UTM は かな を keycode 92、英数 を 94 で渡してくるので
    # jp レイアウトではそれぞれ Henkan と Muhenkan になる
    fcitx5.settings.globalOptions = {
      # 既定値には Zenkaku_Hankaku と Hangul が含まれる
      # トグルは Control+space だけにする
      "Hotkey/TriggerKeys"."0" = "Control+space";

      "Hotkey/ActivateKeys"."0" = "Henkan_Mode";

      "Hotkey/DeactivateKeys"."0" = "Muhenkan";
    };
  };
}
