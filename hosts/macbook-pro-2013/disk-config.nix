{ ... }:

{
  disko.devices = {
    disk = {
      main = {
        # 純正の PCIe SSD は NVMe ではなく AHCI なので ahci に掴まれて sda になる
        # NVMe に換装してあると nvme0n1 になるため実機で lsblk を確認する
        device = "/dev/sda";
        type = "disk";

        content = {
          type = "gpt";

          partitions = {
            ESP = {
              type = "EF00";
              size = "512M";

              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            # ハイバネートはしないので本来は RAM 未満でも足りるが
            # 後から切り直せないので RAM と同じ 8G を取る
            swap = {
              size = "8G";

              content = {
                type = "swap";
              };
            };

            root = {
              size = "100%";

              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
