{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # 一部のパッケージだけ unstable から取る
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # plasma-manager にリリースブランチはないので trunk を使う
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs@{ self, nixpkgs, disko, ... }: {
    nixosConfigurations.vm-aarch64 =
      nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";

        specialArgs = { inherit inputs; };

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
