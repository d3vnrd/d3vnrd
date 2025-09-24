{helper, ...}: {
  imports = helper.scanPath {path = ./.;};

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "vcs" = {
        host = "gitlab.com github.com";
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
