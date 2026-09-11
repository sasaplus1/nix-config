{ ... }:

{
  # nixos-rebuild --flake を使うために必要
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
