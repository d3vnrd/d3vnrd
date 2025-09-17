{helper, ...}: {
  imports = helper.scanPath {path = ./.;};

  home = {
    file = {};
    sessionVariables = {};
  };
}
