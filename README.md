# nix-config

my NixOS and Home Manager configurations

## Hosts

- `vm-aarch64` - a VM on [UTM](https://mac.getutm.app/)
- `macbook-pro-2013` - a MacBookPro11,1

## Setup

### vm-aarch64

Boot the aarch64 [minimal ISO](https://nixos.org/download/#nixos-iso) and run
these as root. This destroys every partition on `/dev/vda`.

```sh
nix --experimental-features 'nix-command flakes' run \
  'git+https://github.com/sasaplus1/nix-config#disko-vm-aarch64' -- --yes-wipe-all-disks

mkdir -p /mnt/etc/passwords
nix-shell -p mkpasswd --run mkpasswd > /mnt/etc/passwords/sasaplus1
chmod 600 /mnt/etc/passwords/sasaplus1

nixos-install --no-root-password \
  --flake 'git+https://github.com/sasaplus1/nix-config#vm-aarch64'
```

Do not carry `--yes-wipe-all-disks` over to a host that has data worth keeping.

### macbook-pro-2013

Boot the ISO built from `.#iso`, which carries the `broadcom_sta` driver the
built-in Wi-Fi needs, and run these as root. This destroys every partition on
the disk, macOS included.

```sh
lsblk -o NAME,SIZE,MODEL,TRAN

nix --experimental-features 'nix-command flakes' run \
  'git+https://github.com/sasaplus1/nix-config#disko-macbook-pro-2013' -- --yes-wipe-all-disks

mkdir -p /mnt/etc/passwords
nix-shell -p mkpasswd --run mkpasswd > /mnt/etc/passwords/sasaplus1
chmod 600 /mnt/etc/passwords/sasaplus1

nixos-install --option tarball-ttl 0 --no-root-password \
  --flake 'git+https://github.com/sasaplus1/nix-config#macbook-pro-2013'
```

The stock Apple PCIe SSD is AHCI, so it comes up as `/dev/sda`, but a blade
swapped for NVMe comes up as `/dev/nvme0n1`. Correct `disk-config.nix` if
`lsblk` disagrees.

`broadcom_sta` does not speak SAE, so the access point has to offer WPA2. It
will not associate with a WPA3-only network.

`hardware-configuration.nix` is already committed. Regenerate it with
`nixos-generate-config --no-filesystems --root /mnt` only if the hardware
changes.

### Password

`modules/core/users.nix` reads the hash for `sasaplus1` from
`/etc/passwords/sasaplus1`, which is not managed here. Write it once per
machine. `root` has no password, so use `sudo`.

The hash is re-read on every activation, so a locked account is recoverable
from the ISO.

```sh
nix --experimental-features 'nix-command flakes' run \
  'git+https://github.com/sasaplus1/nix-config#nixosConfigurations.vm-aarch64.config.system.build.mount'

mkdir -p /mnt/etc/passwords
nix-shell -p mkpasswd --run mkpasswd > /mnt/etc/passwords/sasaplus1
chmod 600 /mnt/etc/passwords/sasaplus1

nixos-enter --root /mnt -- true
```

## Update

```sh
sudo nixos-rebuild switch \
  --flake 'git+https://github.com/sasaplus1/nix-config#vm-aarch64'
```

`github:` resolves branch names through `api.github.com`, which is rate limited
per source address, so `git+https:` is used throughout.

A branch name resolves to whatever revision was cached within the last hour.
Pass `--option tarball-ttl 0` to pick up a commit pushed just before.

## License

The MIT license
