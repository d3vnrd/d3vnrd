{ pkgs, lib, config, ... }: {
  options = {
    xorg.enable = lib.mkEnableOption "Xorg";
  };

  config = lib.mkIf config.xorg.enable {
    services.xserver = {
      enable = true;
      autorun = false;
      displayManager = {
  	lightdm.enable = false;
	startx.enable = true;
      };
      windowManager.dwm.enable = true;
    };
  };
}
