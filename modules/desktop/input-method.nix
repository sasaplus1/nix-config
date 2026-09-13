{ pkgs, ... }:

{
  # model はキーボードの実体ごとに異なるため各ホストで指定する
  services.xserver.xkb.layout = "jp";

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5.addons = with pkgs; [
      fcitx5-mozc
    ];

    # SKIP_FCITX_USER_PATH=1 を立てて ~/.config/fcitx5 を読ませない
    # GUI から設定を変えられなくなる代わりに設定が drift しない
    fcitx5.ignoreUserConfig = true;

    # 既定のグループは Layout=us で作られる
    # us では keycode 92 と 94 にキーシムが割り当たらず下の Hotkey が死ぬ
    fcitx5.settings.inputMethod = {
      "Groups/0" = {
        Name = "Default";
        "Default Layout" = "jp";
        DefaultIM = "mozc";
      };

      "Groups/0/Items/0" = {
        Name = "keyboard-jp";
        Layout = "";
      };

      "Groups/0/Items/1" = {
        Name = "mozc";
        Layout = "";
      };

      GroupOrder."0" = "Default";
    };

    # かなキーでオン、英数キーでオフにする
    # UTM は かな を keycode 92、英数 を 94 で渡してくるので
    # jp レイアウトではそれぞれ Henkan と Muhenkan になる
    # Apple の内蔵キーボードは HID の LANG1/LANG2 をそのまま出すため
    # hid-apple 経由では Hangul と Hangul_Hanja になる
    fcitx5.settings.globalOptions = {
      # 既定値には Zenkaku_Hankaku と Hangul が含まれる
      # トグルは Control+space だけにする
      "Hotkey/TriggerKeys"."0" = "Control+space";

      "Hotkey/ActivateKeys" = {
        "0" = "Henkan_Mode";
        "1" = "Hangul";
      };

      "Hotkey/DeactivateKeys" = {
        "0" = "Muhenkan";
        "1" = "Hangul_Hanja";
      };
    };
  };
}
