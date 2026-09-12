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

  outputs =
    inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, disko, ... }:
    let
      allowUnfreePredicate = import ./lib/allow-unfree.nix nixpkgs.lib;

      # NOTE: builtins.currentSystem と getEnv を使うので --impure が必要
      mkHome =
        machine:
        let
          system = builtins.currentSystem;
          config = { inherit allowUnfreePredicate; };
          pkgs = import nixpkgs { inherit system config; };
          pkgs-unstable = import nixpkgs-unstable { inherit system config; };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = { inherit pkgs-unstable; };

          modules = [ machine ];
        };

    in
    {
      nixosConfigurations.vm-aarch64 =
        nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";

          specialArgs = { inherit inputs; };

          modules = [
            disko.nixosModules.disko

            ./hosts/vm-aarch64/configuration.nix
          ];
        };

      nixosConfigurations.macbook-pro-2013 =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = { inherit inputs; };

          modules = [
            disko.nixosModules.disko

            ./hosts/macbook-pro-2013/configuration.nix
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
      packages.aarch64-linux.disko-vm-aarch64 =
        self.nixosConfigurations.vm-aarch64.config.system.build.destroyFormatMount;

      # hardware-configuration.nix を生成する前に走らせる必要があるため
      # ホストの構成ではなくディスク定義だけから組み立てる
      packages.x86_64-linux.disko-macbook-pro-2013 =
        (nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            disko.nixosModules.disko

            ./hosts/macbook-pro-2013/disk-config.nix
          ];
        }).config.system.build.destroyFormatMount;

      packages.x86_64-linux.iso =
        self.nixosConfigurations.macbook-pro-2013-iso.config.system.build.isoImage;

      homeConfigurations = {
        work = mkHome ./home/machines/work.nix;
        macbook-air = mkHome ./home/machines/macbook-air.nix;
      };
    };
}
