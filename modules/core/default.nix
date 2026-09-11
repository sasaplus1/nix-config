{ ... }:

{
  imports = [
    ./nix-settings.nix
    ./nixpkgs.nix
    ./users.nix
    ./home-manager.nix
    ./openssh.nix
    ./locale.nix
    ./packages.nix
  ];
}
