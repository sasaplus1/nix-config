# nixos-config

my NixOS configurations

## Hosts

- `vm-aarch64` - a VM on [UTM](https://mac.getutm.app/)
- `macbook-pro-2013` - work in progress

## Setup

### vm-aarch64

Boot the aarch64 [minimal ISO](https://nixos.org/download/#nixos-iso) and run
every step below as root in the live environment, in this order.

1. Partition and mount. This destroys every existing partition on `/dev/vda`.

   ```sh
   nix --experimental-features 'nix-command flakes' run \
     'github:sasaplus1/nixos-config#disko' -- --yes-wipe-all-disks
   ```

   The `disko` output is this repository's own package, built from the `disko`
   revision pinned in `flake.lock`. Do not substitute
   `github:nix-community/disko/latest`, which is a mutable branch, for a script
   that repartitions a disk as root.

   `--yes-wipe-all-disks` skips the confirmation prompt. The VM owns nothing but
   `/dev/vda`, and the prompt reads from stdin, which breaks non-interactive
   runs. Do not carry this flag over to a host that has data worth keeping.

2. Write the password hash. `mkpasswd` asks for a password and prints its hash
   to stdout. Do not skip this step, see [Password](#password) for why.

   ```sh
   mkdir -p /mnt/etc/passwords
   nix-shell -p mkpasswd --run mkpasswd > /mnt/etc/passwords/sasaplus1
   chmod 600 /mnt/etc/passwords/sasaplus1
   ```

3. Install, then eject the ISO and reboot.

   ```sh
   nixos-install --no-root-password \
     --flake 'github:sasaplus1/nixos-config#vm-aarch64'
   ```

   `--no-root-password` skips the interactive prompt because `root` is left
   without a password on purpose.

### Password

`modules/users.nix` sets `users.mutableUsers = false` and reads the hash for
`sasaplus1` from `/etc/passwords/sasaplus1`. The file is not managed in this
repository, so write it once per machine.

This has three consequences.

- `passwd` does not persist. Changes are reverted on the next activation.
- `root` has no password. Use `sudo` as `sasaplus1` instead.
- The hash is re-read on **every** activation, so a missing file is recoverable.

To recover a locked account, mount the disk from the ISO, write the file, and
run the activation script.

```sh
nix --experimental-features 'nix-command flakes' run \
  'github:sasaplus1/nixos-config#nixosConfigurations.vm-aarch64.config.system.build.mount'

mkdir -p /mnt/etc/passwords
nix-shell -p mkpasswd --run mkpasswd > /mnt/etc/passwords/sasaplus1
chmod 600 /mnt/etc/passwords/sasaplus1

nixos-enter --root /mnt -- true
grep '^sasaplus1:' /mnt/etc/shadow
```

`nixos-enter` runs the activation script, which applies the hash. The `grep`
prints `!` while the account is still locked.

## Update

```sh
sudo nixos-rebuild switch \
  --flake 'github:sasaplus1/nixos-config#vm-aarch64'
```

## License

The MIT license
