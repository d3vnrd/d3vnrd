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
        else {
          type = "nixos";
          bootstrap = nixosSystem;
        };
    in
      genAttrs hosts (
        hostname:
          with opts;
            bootstrap {
              inherit system;
              specialArgs = {inherit inputs lib helper;};

              modules = [
                # --Include system configurations--
                ../module/system
                ./${system}/${hostname}

                # --Input home-manager & nix-secret as flake module--
                home-manager."${type}Modules".home-manager
                nix-secret."${type}Modules".secrets

                # --System predefined attributes--
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

                  networking.hostName = hostname;
                }
              ];
            }
      );

  genHome = {
    name,
    system,
    opts ? {
      home.username = name;
      home.stateVersion = "25.05";
      home.homeDirectory = "/home/" + name;
    },
  }: {
    "${name}" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {inherit system;};
      extraSpecialArgs = {inherit inputs helper;};
      modules = [../module/home opts];
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

    homeConfigurations = mergeAttrsList [
      (genHome {
        name = "daifuku";
        system = "x86_64-linux";
      })

      (genHome {
        name = "genzako";
        system = "x86_64-darwin";
      })
    ];
  }
