let 
  system = builtins.baseNameOf ./.;
  hosts = builtins.attrNames (builtins.readDir ./.);
in
{
 inherit system hosts;
}
