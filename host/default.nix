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
    in
      genAttrs hosts (
        hostname:
          with opts;
            bootstrap {
              inherit system;
              specialArgs = {inherit inputs helper;};

              modules = flatten [
                secrets."${type}Modules".secrets
                (optional (type == "nixos") inputs.disko.nixosModules.disko)
                inputs.home-manager."${type}Modules".home-manager

                ../module/system
                ../module/system/${type}

                ({vars, ...}: {
                  home-manager.users.${vars.username}.imports = flatten [
                    secrets.homeModules.secrets
                    ../module/home
                    ({vars, ...}: {
                      home.username = mkForce vars.username;
                      home.stateVersion = mkForce vars.stateVersion;
                    })
                    (let
                      cfgPath = ./${system}/${hostname}/home.nix;
                    in
                      optional (builtins.pathExists cfgPath) cfgPath)
                  ];

                  home-manager.useGlobalPkgs = mkDefault true;
                  home-manager.useUserPackages = mkDefault true;
                  home-manager.extraSpecialArgs = mkForce {inherit inputs helper;};

                  networking.hostName = mkForce hostname;
                  nix.settings.experimental-features = mkForce ["nix-command" "flakes"];
                  nixpkgs.config.allowUnfree = mkDefault true;
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
      home.stateVersion = "25.05";
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
