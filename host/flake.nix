{
  description = "Minimal flake for bootstraping NixOs systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    inherit (nixpkgs) lib;
    helper = import ../module lib;

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
              modules = [
                ../module/system
                ../module/system/nixos
                {
                  networking.hostName = mkForce hostname;
                  nix.settings.experimental-features = mkForce ["nix-command" "flakes"];
                  system.stateVersion = mkForce "25.05";
                }
                ./${system}/${hostname}
              ];
            }
        );
  in
    with lib; {
      nixosConfigurations = mergeAttrsList (
        map genInit
        (builtins.filter (dir: hasSuffix "linux" dir) systems)
      );
    };
}
