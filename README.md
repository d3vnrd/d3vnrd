<h3 align="center">
  T|mpLab's Development Kits
</h3>

<p align="center">
  My personal user developing environment with Nix, Home-manager, and many more. Focusing on modularity, portability, usability while still being as minimal as possible.
</p>

> [!NOTE]<br>
> This config can be daunting for new comers, I highly suggest you first have a look at [Ryan Yin's Nix book](https://nixos-and-flakes.thiscute.world/introduction/) before trying to understand this. Also since you have decided to give Nix a try, beaware that this is a huge rabbit hole, and if not handle it carefully you will probably end up configure Nix every day for the rest of your life. `TODO: Need to improve this.`
>
> By the way, English is my second language, so if i make any mistakes in here, please be easy on me cause I'm trying to produce non-ai content to further improve my English. Cheers!

### Design Philosophy

Automatic, Scalable, Ease of Use

- `TODO: introduce about nix programming language, nixos, home-manager`
- `TODO: briefly explain the structure of config, folder's purposes`

### Instruction

- `TODO: provide some notes about how i get this to work`
- `TODO: how to deploy this flake`
- `TODO: what to notice when install`
- `TODO: how i manage my secret`

### Essentials

- `TODO: packages that i always use`

### References

A collection of resources I used to prevent myself going further down the hole:

- [NixOs & Flakes Book by Ryan Yin](https://nixos-and-flakes.thiscute.world/)
- [Vimjoyer's YouTube channel](https://www.youtube.com/@vimjoyer)

NixOs, Home-manager, Flakes options, functions, configurations, or packages can all be found in one of these links:

- [Search NixOs](https://search.nixos.org/packages?query=)
- [Noogle](https://noogle.dev/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/index.xhtml)

### Gratitude

My configurations would not be possible without these amazing guys:

- [Vimjoyer](https://github.com/vimjoyer)
- [Ryan Yin](https://github.com/ryan4yin/nix-config/tree/main)
- [EmergentMind](https://github.com/EmergentMind/nix-config)
- [Pinpox](https://github.com/pinpox/nixos)
- [NixOs's community on Reddit](https://www.reddit.com/r/NixOS/)

### Tips

- When merging attributes try to use `lib.mergeAttrsList` instead of `lib.mkMerge` as it can only get processed in NixOs modules.
