{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.macbook-pro-11-1-iso =
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./iso/macbook-pro-11-1.nix
        ];
      };

    packages.x86_64-linux.iso =
      self.nixosConfigurations.macbook-pro-11-1-iso.config.system.build.isoImage;
  };
}
