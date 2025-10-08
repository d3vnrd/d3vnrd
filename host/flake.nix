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
                host-config = ./${system}/${hostname};
              in [
                {
                  networking.hostName = mkForce hostname;
                  nix.settings.experimental-features = mkForce ["nix-command" "flakes"];
                  nixpkgs.config.allowUnfree = true;

                  services.openssh = {
                    enable = mkForce true;
                    settings = {
                      PasswordAuthentication = mkForce false; # disable passwd login
                      PermitRootLogin = mkForce "no"; # no ssh login for root
                    };
                  };

                  users.mutableUsers = mkForce false; # disable user alternation locally
                  users.users = {
                    nixos = {
                      isNormalUser = mkForce true;
                      description = "Bootstrap user (only for testing purposes).";
                      extraGroups = ["wheel" "networkmanager"];
                      initialHashedPassword = "$y$j9T$1KBu8pvh7ZaL4B7ucW9eB/$JineoKvouit/1l7FcRsCxI1WtQSIe8AfcimHeDmgWS5";
                    };

                    root.initialHashedPassword = "!"; # disable passwd login locally
                  };
                }

                (optional (builtins.pathExists host-config) host-config)
              ]);
            }
        );

    genIso = system:
      with lib; {
        "iso-${system}" = nixosSystem {
          inherit system;
          modules = [
            (
              {modulesPath, ...}: {
                imports = ["${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"];

                services.openssh = {
                  enable = true;
                  settings = {
                    PasswordAuthentication = false;
                    PermitRootLogin = "prohibit-password"; # only allow ssh authentication
                  };
                };

                users.users.root.openssh.authorizedKeys.keys = [
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHAdbOcH4X1gybi1dl/nzBSyvxYdTW+tPz3F3tPh5PtF bootstrap"
                ];
              }
            )
          ];
        };
      };
  in
    with lib; {
      nixosConfigurations =
        (
          helper.mergeNoOverride (
            map genInit
            (builtins.filter (dir: hasSuffix "linux" dir) systems)
          )
        )
        // (
          mergeAttrsList (
            map genIso
            (builtins.filter (dir: hasSuffix "linux" dir) systems)
          )
        );
    };
}
