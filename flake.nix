{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, ... }: {
    nixosConfigurations.vm-aarch64 =
      nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";

        modules = [
          disko.nixosModules.disko

          ./hosts/vm-aarch64/configuration.nix
        ];
      };

    nixosConfigurations.macbook-pro-2013-iso =
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./iso/macbook-pro-2013.nix
        ];
      };

    # flake.lock で固定した disko を使う
    # nix run github:nix-community/disko/latest は可変ブランチなので使わない
    packages.aarch64-linux.disko =
      self.nixosConfigurations.vm-aarch64.config.system.build.destroyFormatMount;

    packages.x86_64-linux.iso =
      self.nixosConfigurations.macbook-pro-2013-iso.config.system.build.isoImage;
  };
}
