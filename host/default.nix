{
  inputs,
  systems,
  helper,
}: let
  inherit (inputs) nixpkgs nix-darwin secrets;
  inherit (nixpkgs) lib;

  genOs = system:
    with lib; let
      hosts = helper.scanPath {
        path = ./${system};
        full = false;
        filter = "dir";
      };

      opts =
        if hasSuffix "darwin" system
        then {
          type = "darwin";
          bootstrap = nix-darwin.lib.darwinSystem;
        }
        else if hasSuffix "linux" system
        then {
          type = "nixos";
          bootstrap = nixosSystem;
        }
        else
          throw
          "${system} is not supported.";

      check = {
        cpath,
        message ? "",
      }:
        if builtins.pathExists cpath
        then p
        else builtins.warn message;
    in
      genAttrs hosts (
        hostname:
          with opts;
            bootstrap {
              inherit system;
              specialArgs = {inherit inputs helper;};

              modules = flatten [
                ../module/system
                ../module/system/${type}

                secrets."${type}Modules".secrets
                (optional (type == "nixos") inputs.disko.nixosModules.disko)
                inputs.home-manager."${type}Modules".home-manager

                ({vars, ...}: {
                  home-manager.users.${vars.username}.imports = [
                    ../module/home
                    secrets.homeModules.secrets

                    ({vars, ...}: {
                      home.username = mkForce vars.username;
                      home.stateVersion = mkForce vars.stateVersion;
                    })

                    (
                      check {
                        cpath = ./${system}/${hostname}/home.nix;
                        message = ''
                          Home configs for ${hostname} not found.
                          Consider create "home.nix" under host/${system}/${hostname}.
                        '';
                      }
                    )
                  ];

                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.extraSpecialArgs = mkForce {inherit inputs helper;};

                  networking.hostName = mkForce hostname;
                  nix.settings.experimental-features = mkForce ["nix-command" "flakes"];
                  nixpkgs.config.allowUnfree = true;
                  system.stateVersion = mkForce vars.stateVersion;
                })

                ./${system}/${hostname}
              ];
            }
      );

  genHome = {
    username,
    system,
    addOpts ? {
      home.username = username;
      home.stateVersion = secrets.stateVersion;
      home.homeDirectory = "/home/" + username;
    },
  }: {
    ${username} = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {inherit system;};
      extraSpecialArgs = {inherit inputs helper;};

      modules = [
        ../module/home
        addOpts
      ];
    };
  };
in
  with lib; {
    nixosConfigurations = mergeAttrsList (
      map genOs
      (builtins.filter (dir: hasSuffix "linux" dir) systems)
    );

    darwinConfigurations = mergeAttrsList (
      map genOs
      (builtins.filter (dir: hasSuffix "darwin" dir) systems)
    );

    homeConfigurations = mergeAttrsList (
      map genHome
      [
        {
          username = "daifuku";
          system = "x86_64-linux";
        }
        {
          username = "genzako";
          system = "x86_64-darwin";
        }
      ]
    );
  }
