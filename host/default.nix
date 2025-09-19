{
  inputs,
  systems,
  helper,
}: let
  inherit (inputs) nixpkgs home-manager nix-darwin nix-secret;
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
        else throw "Current ${system} are not supported by this flake.";
    in
      genAttrs hosts (
        hostname:
          with opts;
            bootstrap {
              inherit system;
              specialArgs = {inherit inputs lib helper;};

              modules = [
                # --Predefined system configurations--
                ../module/system
                ../module/system/${type}

                # --Input home-manager & nix-secret as flake module--
                home-manager."${type}Modules".home-manager
                nix-secret."${type}Modules".secrets

                # --Common system attributes--
                {
                  home-manager.users."tlmp59".imports = [
                    nix-secret.homeModules.secrets
                    ../module/home
                    {
                      home.username = "tlmp59";
                      home.stateVersion = "25.05";
                    }
                    ./${system}/${hostname}/home.nix
                  ];

                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.extraSpecialArgs = {inherit inputs helper;};

                  # --Set machine hostname--
                  networking.hostName = hostname;

                  # --Misc--
                  nix.settings.experimental-features = mkForce ["nix-command" "flakes"];
                  nixpkgs.config.allowUnfree = mkDefault true;

                  # --Precaution --
                  system.stateVersion = mkForce "25.05";
                }

                # --System-based configurations--
                ./${system}/${hostname}
              ];
            }
      );

  genHome = {
    username,
    system,
    opts ? {
      home.username = username;
      home.stateVersion = "25.05";
      home.homeDirectory = "/home/" + username;
    },
  }: {
    "${username}" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {inherit system;};
      extraSpecialArgs = {inherit inputs helper;};

      modules = [
        ../module/home
        opts
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
