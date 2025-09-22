{pkgs, ...}: {
  home.packages = with pkgs; [btop];

  #TODO: there is some error with setting up ssh client for tlmp59
  # programs.ssh.enable = true;
}
