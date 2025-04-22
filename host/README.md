Insert new system types as directory, the function genHosts in host/default.nix will automatically generate new host under this new directory.

Every dirs within a system dir should contain at least a `default.nix` and a `home.nix` file, hardware-configuration.nix is optional based on different machine uses.

System configurations can be done by changing setting in `default.nix`
Users configurations, on the other hand, is configurable in `home.nix` 
