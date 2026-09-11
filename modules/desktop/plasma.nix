{ ... }:

{
  # plasma6 モジュールは SDDM の設定値を用意するだけなので
  # 有効化は別途必要になる
  services.displayManager.sddm.enable = true;

  services.desktopManager.plasma6.enable = true;
}
