{
  nixpkgs,
  home-manager,
  inputs,
}: let
  helper = import ./module nixpkgs.lib;
in {
  "daifuku" = home-manager.lib.homeManagerConfiguration {
    pkgs = import nixpkgs {system = "x86_64-linux";};
    extraSpecialArgs = {inherit helper inputs;};
    modules = [
      ./module/home
      {
        # Demand-based configurations
        home.username = "daifuku";
        home.stateVersion = "25.05";
        home.homeDirectory = "/home/daifuku";
      }
    ];
  };

  "genzako" = home-manager.lib.homeManagerConfiguration {
    pkgs = import nixpkgs {system = "x86_64-linux";};
    modules = [
      ./module/home
      {
        # Demand-based configurations
      }
    ];
  };
}
