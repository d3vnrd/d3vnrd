{
  config,
  lib,
  ...
}:
with lib; {
  options.M = {
  };

  assertions = {
  };

  config = mkMerge [
    (mkIf (config.M.displayServer == "xserver") {
      services.xserver = {
        enable = true;
        autorun = false;
        displayManager.startx.enable = true;
      };
    })

    #@TODO: on hold for more stable features to come
    (mkIf (config.M.displayServer == "wayland") {})
  ];
}
