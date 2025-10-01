{
  inputs,
  systems,
  helper,
}: let
  inherit (inputs) nixpkgs nix-darwin secrets home-manager;
  inherit (nixpkgs) lib;

  osOpts = {
    darwin = {
      type = "darwin";
      bootstrap = nix-darwin.lib.darwinSystem;
      module = [
        secrets.darwinModules.secrets
        home-manager.darwinModules.home-manager
        ../module/system/darwin
      ];
    };

    linux = {
      type = "nixos";
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
              cfg = ./${system}/${hostname}; # host-specific
            in [
              opts.module

              ({vars, ...}: {
                imports = flatten [../module/system];

                home-manager.users.${vars.username}.imports = flatten (let
                  cfg = ./${system}/${hostname}/home.nix; # host-specific
                in [
                  ({vars, ...}: {
                    imports = flatten [
                      secrets.homeModules.secrets
                      ../module/home
                    ];

                    home = {
                      username = mkForce vars.username;
                      stateVersion = mkForce vars.stateVersion;
                    };
                  })

                  (optional (builtins.pathExists cfg) cfg)
                ]);

                home-manager = {
                  useGlobalPkgs = mkDefault true;
                  useUserPackages = mkDefault true;
                  extraSpecialArgs = mkForce {inherit inputs helper;};
                };

                networking.hostName = mkForce hostname;
              })

              (optional (builtins.pathExists cfg) cfg)
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
