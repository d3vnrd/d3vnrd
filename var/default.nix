{ lib, ulib }: {
  user = "tlmplab";

  systems = rec {
    all = ulib.getSystems;
    linux = builtins.filter (dir: lib.hasSuffix "linux" dir) all;
    dawrin = builtins.filter (dir: lib.hasSuffix "darwin" dir) all;
  };
}
