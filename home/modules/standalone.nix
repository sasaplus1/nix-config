{ ... }:

{
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  programs.home-manager.enable = true;
}
