{
  description = "Minimal flake for bootstraping NixOs systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {...} @ inputs: let
    inherit (inputs.nixpkgs) lib;

    helper = import ../module lib;
    systems = helper.scanPath {
      path = ./.;
      full = false;
      filter = "dir";
    };

    genInit = system:
      with lib; let
        hosts = helper.scanPath {
          path = ./${system};
          full = false;
          filter = "dir";
        };
      in
        genAttrs hosts (
          hostname:
            nixosSystem {
              inherit system;
              specialArgs = {inherit inputs helper;};
              modules = flatten (let
                cfg = ./${system}/${hostname};
              in [
                ../module/system/nixos/disk.nix
                {
                  networking.hostName = mkForce hostname;
                  nix.settings.experimental-features = mkForce ["nix-command" "flakes"];
                  nixpkgs.config.allowUnfree = mkDefault true;
                  system.stateVersion = mkForce "25.05";
                }
                (optional (builtins.pathExists cfg) cfg)
              ]);
            }
        );

    genIso = system:
      with lib; {
        "iso-${system}" = nixosSystem {
          inherit system;
          modules = [
            (
              {
                lib,
                modulesPath,
                ...
              }:
                with lib; {
                  imports = ["${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"];

                  networking.useDHCP = mkDefault true;

                  services.openssh = {
                    enable = true;
                    settings = {
                      PasswordAuthentication = false;
                      PermitRootLogin = "prohibit-password";
                    };
                  };

                  users.users.nixos.openssh.authorizedKeys.keys = [
                    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKzGrfkbSKcBDUd4ZNy72cApL3M1VP79mBn1yQGLaebP root@init"
                  ];
                }
            )
          ];
        };
      };
  in
    with lib; {
      nixosConfigurations =
        (helper.mergeNoOverride (
          map genInit
          (builtins.filter (dir: hasSuffix "linux" dir) systems)
        ))
        // (
          mergeAttrsList (
            map genIso
            (builtins.filter (dir: hasSuffix "linux" dir) systems)
          )
        );
    };
}
