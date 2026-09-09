# nixos-config

my NixOS configurations

## Hosts

- `vm-aarch64` - a VM on [UTM](https://mac.getutm.app/)
- `macbook-pro-2013` - work in progress

## Setup

### vm-aarch64

Boot the aarch64 [minimal ISO](https://nixos.org/download/#nixos-iso) and run
the following as root in the live environment.

`disko` destroys every existing partition on `/dev/vda`.

```sh
nix --experimental-features 'nix-command flakes' \
  run github:nix-community/disko/latest -- \
  --mode destroy,format,mount \
  --flake 'github:sasaplus1/nixos-config#vm-aarch64'
```

Put the password hash before installing. See [Password](#password) below.

```sh
nixos-install --flake 'github:sasaplus1/nixos-config#vm-aarch64'
```

Eject the ISO, then reboot.

### Password

`modules/users.nix` reads the password hash from `/etc/passwords/sasaplus1`.
The file is not managed in this repository, so create it once per machine.

`mkpasswd` asks for a password and writes its hash to stdout.

```sh
mkdir -p /mnt/etc/passwords
nix-shell -p mkpasswd --run mkpasswd > /mnt/etc/passwords/sasaplus1
chmod 600 /mnt/etc/passwords/sasaplus1
```

Do this in the live environment, before running `nixos-install`. NixOS applies
`hashedPasswordFile` only while creating the account, so a hash placed after the
first activation is ignored and the account stays locked.

Drop the `/mnt` prefix when the system is already installed. In that case, reset
the password with `passwd sasaplus1` as well.

## Update

```sh
sudo nixos-rebuild switch --flake 'github:sasaplus1/nixos-config#vm-aarch64'
```

## License

The MIT license
