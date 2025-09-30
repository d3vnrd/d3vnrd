{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.M.disk;
in {
  options.M.disk = {
    device = mkOption {
      type = types.str;
      default = "";
      description = "Device to perform format.";
    };

    #@ Tips: conditional options declaration won't work
    format = mkOption {
      type = types.enum [
        "btrfs-default"
        "btrfs-luks"
        "btrfs-luks-impermanance"
      ];
      description = "Disk format options.";
    };

    swap = mkOption {
      type = types.ints.unsigned; # only positive value
      description = "Assign swap size for disk format.";
    };
  };

  config = mkIf (cfg.device != "") (mkMerge [
    (mkIf (cfg.format == "btrfs-default") {
      disko.devices.disk = {
        disk0 = {
          inherit (cfg) device;
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                priority = 1;
                name = "ESP";
                start = "1M";
                end = "512M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = ["defaults"];
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"]; # override exiting partition
                  subvolumes = {
                    "@root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "@swap" = mkIf (cfg.swap > 0) {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "${builtins.toString cfg.swap}G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    })

    (mkIf (cfg.format == "btrfs-luks-impermanance") {
      disko.devices.disk0 = {};
    })
  ]);
}
