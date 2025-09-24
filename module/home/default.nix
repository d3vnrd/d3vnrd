{helper, ...}: {
  imports = helper.scanPath {path = ./.;};

  services.ssh-agentenable = true;

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "vcs" = {
        host = "gitlab.com github.com";
        addKeysToAgent = "confirm";
        identitiesOnly = true;
        identityFile = [
          "~/.ssh/vcs"
        ];
      };
    };
  };

  home = {
    file = {};
    sessionVariables = {};
  };
}
