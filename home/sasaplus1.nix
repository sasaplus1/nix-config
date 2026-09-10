{ ... }:

{
  home.stateVersion = "26.05";

  programs.plasma = {
    # overrideConfig は既定の false のままにする
    # true にすると宣言していない設定が activation ごとに消える
    enable = true;
  };
}
