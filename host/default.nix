{ lib, mylib, ... }@args: let
  genHosts = {system, isDarwin ? false}: let
    sysFunc = if isDarwin 
      then args.nix-darwin.lib.darwinSystem else lib.nixosSystem;
    sysType = if isDarwin
      then "darwin" else "linux";
    sysHosts = mylib.dirsIn ./${system};

  in lib.genAttrs sysHosts (
    hostname: sysFunc {
      inherit system specialArgs;
      modules = ( map mylib.relativeToRoot [ 
	"${system}/${hostname}/configuration.nix"
	"module/${sysType}"
      ]);
    }
  ); # return empty set if no hosts were found
in {
  nixosConfigurations = lib.mergeAttrsList [
    (genHosts {system = "x86_64-linux";})
    (genHosts {system = "aarch64-linux";})
  ];

  darwinConfigurations = lib.mergeAttrsList [
    (genHosts {system = "x86_64-darwin"; isDarwin = true;})
    (genHosts {system = "aarch64-darwin"; isDarwin = true;})
  ];
}
