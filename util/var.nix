{ lib, mylib }: {
  user = "tlmp59";

  systems = rec {
    all = mylib.dirsIn (mylib.relativeToRoot "host/";
    linux = builtins.filter (dir: lib.hasSuffix "linux" dir) all;
    dawrin = builtins.filter (dir: lib.hasSuffix "darwin" dir) all;
  };
}
