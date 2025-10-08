{
  inputs,
  systems,
  helper,
  ...
}: let
  inherit (inputs) nixpkgs nix-darwin secrets home-manager;
  inherit (nixpkgs) lib;

  osOpts = {
    darwin = {
      bootstrap = nix-darwin.lib.darwinSystem;
      module = [
        secrets.darwinModules.secrets
        home-manager.darwinModules.home-manager
        ../module/system/darwin
      ];
    };

    linux = {
      bootstrap = lib.nixosSystem;
      module = [
        secrets.nixosModules.secrets
        home-manager.nixosModules.home-manager
        ../module/system/nixos
      ];
    };
  };

  getOsOpts = system: let
    m = lib.match ".*-(linux|darwin)$" system;
  in
    if m == null
    then throw "Unsupported system: ${system}"
    else lib.elemAt m 0;

  genOs = system:
    with lib; let
      hosts = helper.scanPath {
        path = ./${system};
        full = false;
        filter = "dir";
      };

      opts = osOpts.${getOsOpts system};
    in
      genAttrs hosts (
        hostname:
          opts.bootstrap {
            inherit system;
            specialArgs = {inherit inputs helper;};

            modules = flatten (let
              host-config = ./${system}/${hostname}; # host-specific
              hardware = ./${system}/${hostname}/hardware-configuration.nix;
            in [
              ../module/system
              opts.module

              ({vars, ...}: {
                home-manager.users.${vars.username}.imports = flatten (let
                  home-config = ./${system}/${hostname}/home.nix; # host-specific
                in [
                  ({vars, ...}: {
                    imports = [
                      secrets.homeModules.secrets
                      ../module/home
                    ];

                    home = {
                      username = mkForce vars.username;
                      stateVersion = mkForce vars.stateVersion;
                    };
                  })

                  (optional (builtins.pathExists home-config) home-config)
                ]);

                home-manager = {
                  useGlobalPkgs = mkDefault true;
                  useUserPackages = mkDefault true;
                  extraSpecialArgs = mkForce {inherit inputs helper;};
                };

                networking.hostName = mkForce hostname;
              })

              (optional (builtins.pathExists hardware) hardware)
              (optional (builtins.pathExists host-config) host-config)
            ]);
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
    ${username} = home-manager.lib.homeManagerConfiguration {
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
    nixosConfigurations = helper.mergeNoOverride (
      map genOs
      (builtins.filter (dir: hasSuffix "linux" dir) systems)
    );

    darwinConfigurations = helper.mergeNoOverride (
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
