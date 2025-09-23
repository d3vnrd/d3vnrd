{
  config,
  lib,
  ...
}:
with lib; {
  options.M = {
    openssh = mkEnableOption ''
      Enable configurations for Openssh server (sshd) to
      handle connections to the current host machine.

      Tips: Start with the client side first (i.e., programs.ssh)
    '';
  };

  config = mkIf config.M.openssh {
    services.openssh = {
      enable = true;
      # settings = {
      #   PasswordAuthentication = false;
      #   PermitRootLogin = "no";
      #   AllowUsers = ["devon"];
      # };
    };
  };
}
