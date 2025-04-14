{ lib, mlib }: {
  user = "tlmp59";

  systems = rec {
    all = mlib.getSystems;
    linux = builtins.filter (dir: lib.hasSuffix "linux" dir) all;
    dawrin = builtins.filter (dir: lib.hasSuffix "darwin" dir) all;
  };
}
