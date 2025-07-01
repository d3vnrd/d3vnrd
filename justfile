default:
    @just --list

[group('nix')]
switch host:
    @echo "Running flake switch on {{arch()}}-{{os()}} machine with {{host}} as host..."
    sudo nixos-rebuild switch --show-trace --flake .#{{host}}

[group('nix')]
test host:
    nixos-rebuild test --show-trace --flake .#{{host}}

[group('nix')]
update:
    nix flake update

[group('nix')]
history:
    nix profile history --profile /nix/var/nix/profiles/system

[group('nix')]
collect:
    sudo nix-collect-garbage --delete-older-than 7d
    nix-collect-garbage --delete-older-than 7d

[group('nix')]
wipe:
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d
