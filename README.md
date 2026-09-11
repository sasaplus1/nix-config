# nix-config

my NixOS and Home Manager configurations

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
     'git+https://github.com/sasaplus1/nix-config#disko' -- --yes-wipe-all-disks
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
     --flake 'git+https://github.com/sasaplus1/nix-config#vm-aarch64'
   ```

   `--no-root-password` skips the interactive prompt because `root` is left
   without a password on purpose.

### macbook-pro-2013

Boot the ISO built from `.#iso`, which carries the `broadcom_sta` driver the
built-in Wi-Fi needs, and run every step below as root in the live environment.

Unlike `vm-aarch64`, this host is not in `nixosConfigurations` until its
`hardware-configuration.nix` exists, so the file has to be generated and
committed in the middle of the installation.

1. Confirm the disk. The stock Apple PCIe SSD is an AHCI device, so it shows up
   as `/dev/sda`, but a machine whose blade was swapped for an NVMe drive shows
   up as `/dev/nvme0n1`.

   ```sh
   lsblk -o NAME,SIZE,MODEL,TRAN
   ```

   Correct `hosts/macbook-pro-2013/disk-config.nix` if it does not say `sata`.

2. Partition and mount. This destroys everything on the disk, macOS included.

   ```sh
   nix --experimental-features 'nix-command flakes' run \
     'git+https://github.com/sasaplus1/nix-config#disko-macbook-pro-2013'
   ```

   The prompt asks for confirmation. Do not pass `--yes-wipe-all-disks` here.

3. Generate the hardware configuration and add it to the repository. The
   filesystems come from `disk-config.nix`, so they are left out.

   ```sh
   nixos-generate-config --no-filesystems --root /mnt
   ```

   Copy `/mnt/etc/nixos/hardware-configuration.nix` into
   `hosts/macbook-pro-2013/`, commit it, and add the host to
   `nixosConfigurations` in `flake.nix`.

4. Write the password hash, as in step 2 of `vm-aarch64`.

5. Install, then eject the ISO and reboot.

   ```sh
   nixos-install --no-root-password \
     --flake 'git+https://github.com/sasaplus1/nix-config#macbook-pro-2013'
   ```

### Password

`modules/core/users.nix` sets `users.mutableUsers = false` and reads the hash for
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
  'git+https://github.com/sasaplus1/nix-config#nixosConfigurations.vm-aarch64.config.system.build.mount'

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
  --flake 'git+https://github.com/sasaplus1/nix-config#vm-aarch64'
```

The `git+https:` scheme is used instead of `github:` throughout this file.
`github:` resolves a branch name through `api.github.com`, which is rate limited
per source address and fails behind a shared one. Revisions pinned in
`flake.lock` are unaffected either way, because an unauthenticated download goes
to `https://github.com/OWNER/REPO/archive/REV.tar.gz`.

## License

The MIT license
