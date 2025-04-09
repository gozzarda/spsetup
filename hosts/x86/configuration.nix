{ inputs, ... }:

{
  imports = [
    inputs.self.nixosModules.base
    inputs.disko.nixosModules.disko
  ];
  nixpkgs.hostPlatform = "x86_64-linux";

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        imageSize = "7G";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              name = "ESP";
              size = "100M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                mountpoint = "/";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };
}
